package com.localcommerce.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.localcommerce.dto.Result;
import com.localcommerce.entity.VoucherOrder;
import com.localcommerce.mapper.VoucherOrderMapper;
import com.localcommerce.service.ISeckillVoucherService;
import com.localcommerce.service.IVoucherOrderService;
import com.localcommerce.utils.RedisIdWorker;
import com.localcommerce.utils.UserHolder;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.connection.stream.Consumer;
import org.springframework.data.redis.connection.stream.MapRecord;
import org.springframework.data.redis.connection.stream.ReadOffset;
import org.springframework.data.redis.connection.stream.StreamOffset;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.data.redis.stream.StreamMessageListenerContainer;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.Collections;

@Slf4j
@Service
public class VoucherOrderServiceImpl extends ServiceImpl<VoucherOrderMapper, VoucherOrder>
        implements IVoucherOrderService {

    private static final String queueName = "stream.orders";
    private static final String groupName = "g1";
    private static final String consumerName = "c1";

    @Resource
    private ISeckillVoucherService seckillVoucherService;

    @Resource
    private RedisIdWorker redisIdWorker;

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private RedissonClient redissonClient;

    @Resource
    private StreamMessageListenerContainer<String, MapRecord<String, String, String>>
            streamMessageListenerContainer;

    private IVoucherOrderService proxy;

    private static final DefaultRedisScript<Long> SECKILL_SCRIPT;

    static {
        SECKILL_SCRIPT = new DefaultRedisScript<>();
        SECKILL_SCRIPT.setLocation(new ClassPathResource("seckill.lua"));
        SECKILL_SCRIPT.setResultType(Long.class);
    }

    @PostConstruct
    private void init() {
        if (!Boolean.TRUE.equals(stringRedisTemplate.hasKey(queueName))) {
            stringRedisTemplate.opsForStream()
                    .add(queueName, Collections.singletonMap("init", "1"));
        }

        try {
            stringRedisTemplate.opsForStream().createGroup(queueName, groupName);
        } catch (Exception e) {
            log.debug("消费者组已存在");
        }

        streamMessageListenerContainer.receiveAutoAck(
                Consumer.from(groupName, consumerName),
                StreamOffset.create(queueName, ReadOffset.lastConsumed()),
                message -> {
                    VoucherOrder voucherOrder = BeanUtil.fillBeanWithMap(
                            message.getValue(),
                            new VoucherOrder(),
                            false
                    );
                    handleVoucherOrder(voucherOrder);
                }
        );

        streamMessageListenerContainer.start();
    }

    @Override
    public Result seckillVoucher(Long voucherId) {
        Long userId = UserHolder.getUser().getId();
        long orderId = redisIdWorker.nextId("order");

        // Lua 里会产生 Stream 消息，监听线程可能在方法返回前就读取消息。
        // 所以必须在执行 Lua 前设置事务代理。
        proxy = (IVoucherOrderService) AopContext.currentProxy();

        Long result = stringRedisTemplate.execute(
                SECKILL_SCRIPT,
                Collections.emptyList(),
                voucherId.toString(),
                userId.toString(),
                String.valueOf(orderId)
        );

        if (result == null) {
            return Result.fail("秒杀失败");
        }

        int r = result.intValue();

        if (r == 1) {
            return Result.fail("库存不足！");
        }

        if (r == 2) {
            return Result.fail("不能重复下单！");
        }
        return Result.ok(orderId);
    }

    private void handleVoucherOrder(VoucherOrder voucherOrder) {
        Long userId = voucherOrder.getUserId();

        RLock lock = redissonClient.getLock("lock:order:" + userId);
        boolean isLock = lock.tryLock();

        if (!isLock) {
            log.error("不允许重复下单");
            return;
        }

        try {
            proxy.createVoucherOrder(voucherOrder);
        } finally {
            lock.unlock();
        }
    }

    @Override
    @Transactional
    public void createVoucherOrder(VoucherOrder voucherOrder) {
        Long userId = voucherOrder.getUserId();
        Long voucherId = voucherOrder.getVoucherId();

        int count = query()
                .eq("user_id", userId)
                .eq("voucher_id", voucherId)
                .count();

        if (count > 0) {
            log.error("不允许重复下单");
            return;
        }

        boolean success = seckillVoucherService
                .update()
                .setSql("stock = stock - 1")
                .eq("voucher_id", voucherId)
                .gt("stock", 0)
                .update();

        if (!success) {
            log.error("库存不足");
            return;
        }

        save(voucherOrder);
    }
}
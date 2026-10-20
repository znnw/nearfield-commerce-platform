package com.localcommerce;

import com.localcommerce.entity.Shop;
import com.localcommerce.service.impl.ShopServiceImpl;
import com.localcommerce.utils.CacheClient;
import com.localcommerce.utils.RedisConstants;
import com.localcommerce.utils.RedisIdWorker;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.connection.RedisGeoCommands;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.geo.Point;

import javax.annotation.Resource;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;
import java.util.stream.Collectors;

import static com.localcommerce.utils.RedisConstants.CACHE_SHOP_KEY;

@SpringBootTest
class LocalCommerceApplicationTests {


    @Resource
    private ShopServiceImpl shopService;

    @Resource
    private CacheClient cacheClient;

    @Resource
    private StringRedisTemplate stringRedisTemplate;


    @Resource
    private RedisIdWorker redisIdWorker;

    private ExecutorService es = Executors.newFixedThreadPool(500);
    @Test
    void testIdWorker() throws InterruptedException {
        CountDownLatch latch = new CountDownLatch(300);

        Runnable task = () -> {
            for (int i = 0; i < 100; i++) {
                long id = redisIdWorker.nextId("order");
                System.out.println("id = "+id);
            }
            latch.countDown();
        };
        long begin = System.currentTimeMillis();
        for(int i = 0; i < 300; i++){
            es.submit(task);
        }
        latch.await();
        long end = System.currentTimeMillis();
        System.out.println("time = " + (end - begin));
    }

    @Test
    void testSaveShop() throws InterruptedException {
        Shop shop = shopService.getById(1L);
        cacheClient.setWithLogicalExpire(CACHE_SHOP_KEY+1L, shop, 10L, TimeUnit.SECONDS);
    }

    @Test
    void loadShopData() {
        // 1. 查询所有店铺
        List<Shop> shopList = shopService.list();

        // 2. 按照店铺类型分组
        // key：typeId
        // value：该类型的店铺集合
        Map<Long, List<Shop>> map = shopList.stream()
                .collect(Collectors.groupingBy(Shop::getTypeId));

        // 3. 分批写入 Redis GEO
        for (Map.Entry<Long, List<Shop>> entry : map.entrySet()) {
            Long typeId = entry.getKey();
            List<Shop> shops = entry.getValue();

            // 当前类型的 GEO key，例如 shop:geo:1
            String key = RedisConstants.SHOP_GEO_KEY + typeId;

            // 4. 把当前类型的店铺转换为 Redis GEO 坐标
            List<RedisGeoCommands.GeoLocation<String>> locations =
                    new ArrayList<>(shops.size());

            for (Shop shop : shops) {
                locations.add(
                        new RedisGeoCommands.GeoLocation<>(
                                shop.getId().toString(),
                                new Point(shop.getX(), shop.getY())
                        )
                );
            }

            // 5. 写入 Redis GEO
            stringRedisTemplate.opsForGeo().add(key, locations);
        }
    }

    @Test
    void testHyperLogLog() {
        // 每批存储 1000 个用户，减少网络请求次数
        String[] values = new String[1000];

        // 当前批次的数组下标
        int j = 0;

        // 总共模拟 100 万个用户
        for (int i = 0; i < 1_000_000; i++) {
            j = i % 1000;

            // 构造不重复的用户 ID
            values[j] = "user_" + i;

            // 每凑满 1000 个用户，批量写入 HyperLogLog
            if (j == 999) {
                stringRedisTemplate.opsForHyperLogLog()
                        .add("hl1", values);
            }
        }

        // 获取 HyperLogLog 统计的 UV 数量
        Long count = stringRedisTemplate.opsForHyperLogLog()
                .size("hl1");

        System.out.println("UV count = " + count);
    }

}

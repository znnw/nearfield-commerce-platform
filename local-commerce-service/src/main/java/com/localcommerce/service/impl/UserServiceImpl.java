package com.localcommerce.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.bean.copier.CopyOptions;
import cn.hutool.core.util.RandomUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.localcommerce.dto.LoginFormDTO;
import com.localcommerce.dto.Result;
import com.localcommerce.dto.UserDTO;
import com.localcommerce.entity.User;
import com.localcommerce.mapper.UserMapper;
import com.localcommerce.service.IUserService;
import com.localcommerce.utils.RedisConstants;
import com.localcommerce.utils.RegexUtils;
import com.localcommerce.utils.UserHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import cn.hutool.core.lang.UUID;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.localcommerce.utils.RedisConstants.*;
import static com.localcommerce.utils.SystemConstants.USER_NICK_NAME_PREFIX;

import java.time.format.DateTimeFormatter;

import org.springframework.data.redis.connection.BitFieldSubCommands;

import java.util.List;

/**
 * <p>
 * 服务实现类
 * </p>
 */
@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {


    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public Result sendCode(String phone, HttpSession session) {
        //校验手机号
        if (RegexUtils.isPhoneInvalid(phone)) {
            return Result.fail("手机号格式错误！");
        }
        //如果不符合，返回错误信息

        String code=RandomUtil.randomNumbers(6);

        //保存到Redis当中
        stringRedisTemplate.opsForValue().set(LOGIN_CODE_KEY + phone, code,LOGIN_CODE_TTL, TimeUnit.MINUTES);
        //符合，生成验证码
        log.debug("发送短信验证码成功，验证码：{}", code);

        // 保存验证码会话
        // 发送验证码
        //返回结果


        return Result.ok();
    }
    @Override
    public Result login(LoginFormDTO loginForm, HttpSession session) {
        //1.校验手机号
        String phone = loginForm.getPhone();
        if (RegexUtils.isPhoneInvalid(phone)) {
            return Result.fail("手机号格式错误!");
        }
        // 2.从Redis获取验证码并校验验证码
        Object cacheCode = stringRedisTemplate.opsForValue().get(LOGIN_CODE_KEY + phone);
        String code = loginForm.getCode();
        if(cacheCode == null || !cacheCode.equals(code)){
            //3.不一致，报错
            return Result.fail("验证码错误");
        }


        //4.一致，根据手机号查询用户
        User user = query().eq("phone",phone).one();
        //5.判断用户是否存在

        if (user == null) {
            user = createUserWithPhone(phone);
        }
        //6.不存在，创建新用户并保存




        //7.保存用户信息到redis中
        // 7.1 生成token,作为登录凭证
        String token = UUID.randomUUID().toString(true);
        // 7.2 将User对象转为Hash存储
        UserDTO userDTO = BeanUtil.copyProperties(user, UserDTO.class);
        Map<String, Object> userMap = BeanUtil.beanToMap(userDTO,new HashMap<>(),
                CopyOptions.create()
                           .setIgnoreNullValue(true)
                           .setFieldValueEditor((fieldName, fieldValue) -> fieldValue.toString()));
        // 7.3 存储
        String tokenKey = LOGIN_USER_KEY + token;
        stringRedisTemplate.opsForHash().putAll(tokenKey,userMap);
        // 7.4 设置token过期时间
        stringRedisTemplate.expire(tokenKey,LOGIN_USER_TTL, TimeUnit.MINUTES);
        // 8.返回token
        return Result.ok(token);
    }

    @Override
    public Result sign() {
        // 获取当前登录用户
        Long userId = UserHolder.getUser().getId();

        // 获取当前时间
        LocalDateTime now = LocalDateTime.now();

        // 拼接签到 key，例如：sign:1:202610
        String keySuffix = now.format(DateTimeFormatter.ofPattern(":yyyyMM"));
        String key = RedisConstants.USER_SIGN_KEY + userId + keySuffix;

        // 获取今天是本月的第几天
        int dayOfMonth = now.getDayOfMonth();

        // 写入 Redis Bitmap
        // Bitmap 下标从 0 开始，所以 offset 是 dayOfMonth - 1
        stringRedisTemplate.opsForValue()
                .setBit(key, dayOfMonth - 1, true);

        return Result.ok();
    }

    private User createUserWithPhone(String phone) {
        User user = new User();
        user.setPhone(phone);
        user.setNickName( USER_NICK_NAME_PREFIX +RandomUtil.randomString(10));

        //保存用户
        save(user);
        return user;
    }

    @Override
    public Result signCount() {
        // 获取当前登录用户
        Long userId = UserHolder.getUser().getId();

        // 获取当前时间
        LocalDateTime now = LocalDateTime.now();

        // 拼接当前月份的签到 key，例如 sign:1:202610
        String keySuffix = now.format(DateTimeFormatter.ofPattern(":yyyyMM"));
        String key = RedisConstants.USER_SIGN_KEY + userId + keySuffix;

        // 获取今天是本月第几天
        int dayOfMonth = now.getDayOfMonth();

        // 获取本月截至今天的所有签到 Bitmap 数据
        // 从 offset 0 开始，读取 dayOfMonth 位无符号整数
        List<Long> result = stringRedisTemplate.opsForValue().bitField(
                key,
                BitFieldSubCommands.create()
                        .get(BitFieldSubCommands.BitFieldType.unsigned(dayOfMonth))
                        .valueAt(0)
        );

        if (result == null || result.isEmpty()) {
            return Result.ok(0);
        }

        Long num = result.get(0);

        if (num == null || num == 0) {
            return Result.ok(0);
        }

        // 从最低位开始统计连续 1 的个数
        int count = 0;
        while (true) {
            if ((num & 1) == 0) {
                break;
            } else {
                count++;
                num >>>= 1;
            }
        }

        return Result.ok(count);
    }
}

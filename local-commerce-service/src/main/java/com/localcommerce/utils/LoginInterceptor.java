package com.localcommerce.utils;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.localcommerce.dto.UserDTO;
import com.localcommerce.entity.User;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;
import java.util.concurrent.TimeUnit;


public class LoginInterceptor implements HandlerInterceptor {


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
/*
        //1.获取请求头中的token
        String token=request.getHeader("authorization");
        if (StrUtil.isBlank(token)) {
            response.setStatus(401);
            return false;
        }
        // 2.基于token获取Redis中的用户
        String key=RedisConstants.LOGIN_USER_KEY + token;
        Map<Object,Object> userMap = stringRedisTemplate.opsForHash().entries(key);


        // 3.判断用户是否存在
        if (userMap.isEmpty()) {

            response.setStatus(401);
            return false;
            //4.不存在，拦截
        }
        //5.将Hash中的数据转为UserDTO对象
        UserDTO userDTO = BeanUtil.fillBeanWithMap(userMap, new UserDTO(), false);
        // 6.存在，保存用户信息到Treadlocal
        UserHolder.saveUser(userDTO);
        //7.刷新token中的有效期
        stringRedisTemplate.expire(key,RedisConstants.LOGIN_USER_TTL, TimeUnit.MINUTES);
        //8.放行
        return true;
 */

        //优化拦截器
        //1.判断是否需要拦截（ThreadLocal是否有用户）
        if (UserHolder.getUser()==null) {
            //没有，需要拦截，设置状态码
            response.setStatus(401);
            //拦截
            return false;
        }
        //


        //有用户，放行
        return true;

    }

}

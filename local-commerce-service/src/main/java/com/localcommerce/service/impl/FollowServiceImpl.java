/**
 * <p>
 *  服务实现类
 * </p>
 */

package com.localcommerce.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.localcommerce.dto.Result;
import com.localcommerce.entity.Follow;
import com.localcommerce.mapper.FollowMapper;
import com.localcommerce.service.IFollowService;
import com.localcommerce.utils.UserHolder;
import org.springframework.stereotype.Service;

import cn.hutool.core.bean.BeanUtil;
import com.localcommerce.dto.UserDTO;
import com.localcommerce.entity.User;
import com.localcommerce.service.IUserService;
import org.springframework.data.redis.core.StringRedisTemplate;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class FollowServiceImpl extends ServiceImpl<FollowMapper, Follow>
        implements IFollowService {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Resource
    private IUserService userService;

    @Override
    public Result follow(Long followUserId, Boolean isFollow) {
        // 当前登录用户
        Long userId = UserHolder.getUser().getId();

        // 当前用户的关注集合
        String key = "follows:" + userId;

        if (isFollow) {
            // 关注：写入数据库
            Follow follow = new Follow();
            follow.setUserId(userId);
            follow.setFollowUserId(followUserId);
            boolean isSuccess = save(follow);

            if (isSuccess) {
                // 同时写入 Redis Set
                stringRedisTemplate.opsForSet()
                        .add(key, followUserId.toString());
            }
        } else {
            // 取关：删除数据库记录
            boolean isSuccess = remove(new QueryWrapper<Follow>()
                    .eq("user_id", userId)
                    .eq("follow_user_id", followUserId));
            if (isSuccess) {
                // 同时从 Redis Set 移除
                stringRedisTemplate.opsForSet()
                        .remove(key, followUserId.toString());
            }
        }

        return Result.ok();
    }
    @Override
    public Result isFollow(Long followUserId) {
        // 获取当前登录用户 ID
        Long userId = UserHolder.getUser().getId();

        // 查询是否有关注记录
        Integer count = query()
                .eq("user_id", userId)
                .eq("follow_user_id", followUserId)
                .count();

        return Result.ok(count > 0);
    }

    @Override
    public Result followCommons(Long id) {
        // 当前登录用户 ID
        Long userId = UserHolder.getUser().getId();

        // 当前用户的关注集合
        String key = "follows:" + userId;

        // 目标用户的关注集合
        String key2 = "follows:" + id;

        // 求两个集合的交集
        Set<String> intersect = stringRedisTemplate.opsForSet()
                .intersect(key, key2);

        // 没有共同关注
        if (intersect == null || intersect.isEmpty()) {
            return Result.ok(Collections.emptyList());
        }

        // Set 中是 String，转换为 Long
        List<Long> ids = intersect.stream()
                .map(Long::valueOf)
                .collect(Collectors.toList());

        // 查询共同关注用户的信息
        List<UserDTO> users = userService.listByIds(ids)
                .stream()
                .map(user -> BeanUtil.copyProperties(user, UserDTO.class))
                .collect(Collectors.toList());

        return Result.ok(users);
    }


}
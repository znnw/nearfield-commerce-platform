package com.localcommerce.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.localcommerce.dto.Result;
import com.localcommerce.dto.UserDTO;
import com.localcommerce.entity.Blog;
import com.localcommerce.entity.Follow;
import com.localcommerce.entity.User;
import com.localcommerce.mapper.BlogMapper;
import com.localcommerce.service.IBlogService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.localcommerce.service.IFollowService;
import com.localcommerce.service.IUserService;
import com.localcommerce.utils.SystemConstants;
import com.localcommerce.utils.UserHolder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.BooleanUtil;
import com.localcommerce.utils.RedisConstants;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.BooleanUtil;
import cn.hutool.core.util.StrUtil;

import com.localcommerce.dto.ScrollResult;
import org.springframework.data.redis.core.ZSetOperations;

import java.util.ArrayList;
import java.util.Set;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 */
@Service
public class BlogServiceImpl extends ServiceImpl<BlogMapper, Blog> implements IBlogService {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Resource
    private IFollowService followService;

    @Override
    public Result queryBlogById(Long id) {
        Blog blog = getById(id);
        if (blog == null) {
            return Result.fail("笔记不存在！");
        }

        queryBlogUser(blog);
        isBlogLiked(blog);

        return Result.ok(blog);
    }



    @Override
    public Result likeBlog(Long id) {
        // 获取当前登录用户
        UserDTO user = UserHolder.getUser();
        if (user == null) {
            return Result.fail("请先登录");
        }

        Long userId = user.getId();

        // Redis key：blog:liked:{blogId}
        String key = RedisConstants.BLOG_LIKED_KEY + id;

        // 查询当前用户在 ZSet 中的 score
        // score 不为空，说明当前用户已经点过赞
        Double score = stringRedisTemplate.opsForZSet()
                .score(key, userId.toString());

        if (score == null) {
            // 当前用户未点赞：数据库点赞数 +1
            boolean success = update()
                    .setSql("liked = liked + 1")
                    .eq("id", id)
                    .update();

            if (success) {
                // 用户 ID 作为 ZSet 的 member
                // 当前时间戳作为 score，记录点赞顺序
                stringRedisTemplate.opsForZSet().add(
                        key,
                        userId.toString(),
                        System.currentTimeMillis()
                );
            }
        } else {
            // 当前用户已点赞：数据库点赞数 -1
            boolean success = update()
                    .setSql("liked = liked - 1")
                    .eq("id", id)
                    .gt("liked", 0)
                    .update();

            if (success) {
                // 从 ZSet 中移除当前用户
                stringRedisTemplate.opsForZSet()
                        .remove(key, userId.toString());
            }
        }

        return Result.ok();
    }

    @Resource
    private IUserService userService;

    @Override
    public Result queryHotBlog(Integer current) {

        // 根据用户查询
        Page<Blog> page = query()
                .orderByDesc("liked")
                .page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        // 获取当前页数据
        List<Blog> records = page.getRecords();
        // 查询用户
        records.forEach(blog -> {
            queryBlogUser(blog);
            isBlogLiked(blog);
        });
        return Result.ok(records);
    }

    private void queryBlogUser(Blog blog) {
        Long userId = blog.getUserId();
        User user = userService.getById(userId);
        blog.setName(user.getNickName());
        blog.setIcon(user.getIcon());
    }

    private void isBlogLiked(Blog blog) {
        // 未登录用户不需要设置点赞状态
        UserDTO user = UserHolder.getUser();
        if (user == null) {
            return;
        }

        Long userId = user.getId();

        // 当前笔记的点赞 ZSet
        String key = RedisConstants.BLOG_LIKED_KEY + blog.getId();

        // score 不为空，说明当前用户点过赞
        Double score = stringRedisTemplate.opsForZSet()
                .score(key, userId.toString());

        // 设置给前端，用于点亮/取消点亮点赞图标
        blog.setIsLike(score != null);
    }


    @Override
    public Result queryBlogLikes(Long id) {
        // 当前笔记的点赞 ZSet
        String key = RedisConstants.BLOG_LIKED_KEY + id;

        // 按 score 升序取前 5 个用户
        // range(key, 0, 4) 表示取下标 0 到 4，共 5 个
        Set<String> top5 = stringRedisTemplate.opsForZSet()
                .range(key, 0, 4);

        // 没有人点赞，直接返回空集合
        if (top5 == null || top5.isEmpty()) {
            return Result.ok(Collections.emptyList());
        }

        // ZSet 中保存的是 String 类型用户 ID，转换为 Long
        List<Long> ids = top5.stream()
                .map(Long::valueOf)
                .collect(Collectors.toList());

        // 拼接 ID，用于让 MySQL 按 ZSet 的顺序返回用户
        String idStr = StrUtil.join(",", ids);

        // 查询用户信息
        // ORDER BY FIELD 保证数据库返回顺序和 ZSet 点赞顺序一致
        List<UserDTO> userDTOS = userService.query()
                .in("id", ids)
                .last("ORDER BY FIELD(id," + idStr + ")")
                .list()
                .stream()
                .map(user -> BeanUtil.copyProperties(user, UserDTO.class))
                .collect(Collectors.toList());

        // 返回排行榜前 5 名用户
        return Result.ok(userDTOS);
    }

    @Override
    public Result saveBlog(Blog blog) {

        UserDTO user = UserHolder.getUser();
        blog.setUserId(user.getId());

        // 保存探店笔记
        boolean isSuccess = save(blog);

        if (!isSuccess) {

            return Result.fail("新增笔记失败！");
        }

        // 查询所有粉丝
        List<Follow> follows = followService.query()
                .eq("follow_user_id", user.getId())
                .list();

        // 将笔记推送到每个粉丝的收件箱
        for (Follow follow : follows) {
            Long fanId = follow.getUserId();
            String key = RedisConstants.FEED_KEY + fanId;

            // member 是博客 ID，score 是当前时间戳
            stringRedisTemplate.opsForZSet().add(
                    key,
                    blog.getId().toString(),
                    System.currentTimeMillis()
            );
        }

        return Result.ok(blog.getId());
    }

    @Override
    public Result queryBlogOfFollow(Long max, Integer offset) {
        // 获取当前登录用户
        Long userId = UserHolder.getUser().getId();

        // 当前用户的收件箱 key
        String key = RedisConstants.FEED_KEY + userId;

        // 按 score 从大到小查询
        // max：上一次查询的最小时间戳
        // offset：上一次查询中相同时间戳的偏移量
        // 每次查询 2 条
        Set<ZSetOperations.TypedTuple<String>> typedTuples =
                stringRedisTemplate.opsForZSet()
                        .reverseRangeByScoreWithScores(key, 0, max, offset, 2);

        // 没有更多数据
        if (typedTuples == null || typedTuples.isEmpty()) {
            return Result.ok();
        }

        List<Long> ids = new ArrayList<>(typedTuples.size());

        // 最小时间戳
        long minTime = 0;

        // 与最小时间戳相同记录数量
        int os = 1;

        for (ZSetOperations.TypedTuple<String> tuple : typedTuples) {
            // 添加博客 ID
            ids.add(Long.valueOf(tuple.getValue()));

            // 获取当前博客的推送时间
            long time = tuple.getScore().longValue();

            if (time == minTime) {
                // 与上一条时间戳相同，偏移量加 1
                os++;
            } else {
                // 时间戳不同，重置最小时间和偏移量
                minTime = time;
                os = 1;
            }
        }

        // 将博客 ID 拼接成 SQL 查询顺序
        String idStr = StrUtil.join(",", ids);

        // 根据 ID 查询博客，并保持 ZSet 中的顺序
        List<Blog> blogs = query()
                .in("id", ids)
                .last("ORDER BY FIELD(id," + idStr + ")")
                .list();

        // 补充发布者信息和当前用户的点赞状态
        for (Blog blog : blogs) {
            queryBlogUser(blog);
            isBlogLiked(blog);
        }

        // 封装滚动分页返回结果
        ScrollResult result = new ScrollResult();
        result.setList(blogs);
        result.setMinTime(minTime);
        result.setOffset(os);

        return Result.ok(result);
    }
}


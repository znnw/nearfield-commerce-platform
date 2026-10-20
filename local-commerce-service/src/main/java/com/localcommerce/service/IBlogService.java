package com.localcommerce.service;

import com.localcommerce.dto.Result;
import com.localcommerce.entity.Blog;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 */
public interface IBlogService extends IService<Blog> {

    Result queryBlogById(Long id);

    Result queryHotBlog(Integer current);

    Result likeBlog(Long id);

    // 查询点赞排行榜
    Result queryBlogLikes(Long id);

    Result saveBlog(Blog blog);

    // 滚动分页查询收件箱
    Result queryBlogOfFollow(Long max, Integer offset);
}

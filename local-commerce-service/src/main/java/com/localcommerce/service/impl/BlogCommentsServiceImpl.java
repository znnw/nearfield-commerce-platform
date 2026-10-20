package com.localcommerce.service.impl;

import com.localcommerce.entity.BlogComments;
import com.localcommerce.mapper.BlogCommentsMapper;
import com.localcommerce.service.IBlogCommentsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 */
@Service
public class BlogCommentsServiceImpl extends ServiceImpl<BlogCommentsMapper, BlogComments> implements IBlogCommentsService {

}

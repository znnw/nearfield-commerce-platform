/**
 * <p>
 *  服务类
 * </p>
 */
package com.localcommerce.service;

import com.localcommerce.dto.Result;
import com.localcommerce.entity.Follow;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IFollowService extends IService<Follow> {

    // 关注或取关
    Result follow(Long followUserId, Boolean isFollow);

    // 判断是否关注
    Result isFollow(Long followUserId);

    // 查询共同关注
    Result followCommons(Long id);
}
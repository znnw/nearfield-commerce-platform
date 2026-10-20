/**
 * <p>
 *  前端控制器
 * </p>
 */
package com.localcommerce.controller;

import com.localcommerce.dto.Result;
import com.localcommerce.service.IFollowService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/follow")
public class FollowController {

    @Resource
    private IFollowService followService;

    // 关注或取关
    // isFollow 为 true：关注
    // isFollow 为 false：取关
    @PutMapping("/{id}/{isFollow}")
    public Result follow(@PathVariable("id") Long followUserId,
                         @PathVariable("isFollow") Boolean isFollow) {
        return followService.follow(followUserId, isFollow);
    }

    // 判断当前用户是否关注了指定用户
    @GetMapping("/or/not/{id}")
    public Result isFollow(@PathVariable("id") Long followUserId) {
        return followService.isFollow(followUserId);
    }

    @GetMapping("/common/{id}")
    public Result followCommons(@PathVariable("id") Long id) {
        // 查询当前登录用户和目标用户的共同关注
        return followService.followCommons(id);
    }
}
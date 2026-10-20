package com.localcommerce.service.impl;

import com.localcommerce.entity.UserInfo;
import com.localcommerce.mapper.UserInfoMapper;
import com.localcommerce.service.IUserInfoService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 */
@Service
public class UserInfoServiceImpl extends ServiceImpl<UserInfoMapper, UserInfo> implements IUserInfoService {

}

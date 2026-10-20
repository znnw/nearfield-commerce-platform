package com.localcommerce.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.localcommerce.dto.LoginFormDTO;
import com.localcommerce.dto.Result;
import com.localcommerce.entity.User;

import javax.servlet.http.HttpSession;

/**
 * <p>
 *  服务类
 * </p>
 */
public interface IUserService extends IService<User> {

    Result sendCode(String phone, HttpSession session);

    Result login(LoginFormDTO loginForm, HttpSession session);

    Result sign();

    Result signCount();
}

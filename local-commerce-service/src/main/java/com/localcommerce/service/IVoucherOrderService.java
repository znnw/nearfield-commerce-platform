package com.localcommerce.service;

/**
 * <p>
 *  服务类
 * </p>
 */


import com.baomidou.mybatisplus.extension.service.IService;
import com.localcommerce.dto.Result;
import com.localcommerce.entity.VoucherOrder;

public interface IVoucherOrderService extends IService<VoucherOrder> {

    Result seckillVoucher(Long voucherId);

    void createVoucherOrder(VoucherOrder voucherOrder);
}
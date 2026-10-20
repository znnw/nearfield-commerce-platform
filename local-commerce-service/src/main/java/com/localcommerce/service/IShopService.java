package com.localcommerce.service;

import com.localcommerce.dto.Result;
import com.localcommerce.entity.Shop;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 */
public interface IShopService extends IService<Shop> {

    Result queryById(Long id);

    Result update(Shop shop);

    // 根据类型和坐标查询附近商铺
    Result queryShopByType(Integer typeId, Integer current, Double x, Double y);
}

package com.localcommerce.utils;

public interface ILock {

    boolean tryLock(long timeoutSec);


    void unlock();
}

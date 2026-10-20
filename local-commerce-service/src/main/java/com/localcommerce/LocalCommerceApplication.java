package com.localcommerce;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;


@EnableAspectJAutoProxy(exposeProxy = true)
@MapperScan("com.localcommerce.mapper")
@SpringBootApplication
public class LocalCommerceApplication {

    public static void main(String[] args) {
        SpringApplication.run(LocalCommerceApplication.class, args);
    }

}

package com.ecommerce.orderservice.domain.event;

import lombok.Getter;

import java.math.BigDecimal;

@Getter
public class OrderCreatedEvent {
    private final String orderId;
    private final String userEmail;
    private final BigDecimal total;

    public OrderCreatedEvent(String orderId, String userEmail, BigDecimal total) {
        this.orderId = orderId;
        this.userEmail = userEmail;
        this.total = total;
    }
}
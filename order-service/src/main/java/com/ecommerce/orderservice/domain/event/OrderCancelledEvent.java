package com.ecommerce.orderservice.domain.event;

import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class OrderCancelledEvent {
    private final String orderId;
    private final LocalDateTime cancelledAt;

    public OrderCancelledEvent(String orderId, LocalDateTime cancelledAt) {
        this.orderId = orderId;
        this.cancelledAt = cancelledAt;
    }
}
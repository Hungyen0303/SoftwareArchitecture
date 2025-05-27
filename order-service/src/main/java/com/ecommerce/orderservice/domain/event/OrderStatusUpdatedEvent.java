package com.ecommerce.orderservice.domain.event;


import com.ecommerce.orderservice.domain.model.Order;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class OrderStatusUpdatedEvent {
    private final String orderId;
    private final Order.OrderStatus status;
    private final LocalDateTime updatedAt;

    public OrderStatusUpdatedEvent(String orderId, Order.OrderStatus status, LocalDateTime updatedAt) {
        this.orderId = orderId;
        this.status = status;
        this.updatedAt = updatedAt;
    }
}
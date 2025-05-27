package com.ecommerce.orderservice.domain.event;

import com.ecommerce.orderservice.domain.model.Order.PaymentStatus;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class OrderPaymentStatusUpdatedEvent {
    private final String orderId;
    private final PaymentStatus paymentStatus;
    private final LocalDateTime updatedAt;

    public OrderPaymentStatusUpdatedEvent(String orderId, PaymentStatus paymentStatus, LocalDateTime updatedAt) {
        this.orderId = orderId;
        this.paymentStatus = paymentStatus;
        this.updatedAt = updatedAt;
    }
}
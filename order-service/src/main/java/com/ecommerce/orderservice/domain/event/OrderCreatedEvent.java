package com.ecommerce.orderservice.domain.event;

import com.ecommerce.orderservice.domain.model.Order.OrderStatus;
import com.ecommerce.orderservice.domain.model.Order.PaymentStatus;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@AllArgsConstructor
@Getter

public class OrderCreatedEvent {
    private final String orderId;
    private final String userEmail;
    private final List<OrderItemData> items;
    private final BigDecimal totalAmount;
    private final OrderStatus status;
    private final String shippingAddress;
    private final String paymentMethod;
    private final PaymentStatus paymentStatus;
    private final LocalDateTime createdAt;


    @Getter
    @AllArgsConstructor
    public static class OrderItemData {
        private final Long productId;
        private final String productName;
        private final Integer quantity;
        private final BigDecimal unitPrice;
        private final BigDecimal subtotal;

    }
}
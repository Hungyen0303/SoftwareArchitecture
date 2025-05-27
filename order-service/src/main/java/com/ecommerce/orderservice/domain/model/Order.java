package com.ecommerce.orderservice.domain.model;

import com.ecommerce.orderservice.domain.event.OrderCancelledEvent;
import com.ecommerce.orderservice.domain.event.OrderCreatedEvent;
import com.ecommerce.orderservice.domain.event.OrderPaymentStatusUpdatedEvent;
import com.ecommerce.orderservice.domain.event.OrderStatusUpdatedEvent;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Getter
public class Order {
    private Long id;
    private String userEmail;
    private List<OrderItem> items = new ArrayList<>();
    private BigDecimal totalAmount;
    private OrderStatus status = OrderStatus.PENDING;
    private String shippingAddress;
    private String paymentMethod;
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum OrderStatus {
        PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED
    }

    public enum PaymentStatus {
        PENDING, PAID, FAILED, REFUNDED
    }

    // Áp dụng sự kiện để tái tạo trạng thái
    public void apply(OrderCreatedEvent event) {
        this.id = Long.valueOf(event.getOrderId());
        this.userEmail = event.getUserEmail();
        this.items = event.getItems().stream()
                .map(item -> new OrderItem(item.getProductId(), item.getProductName(), item.getQuantity(), item.getUnitPrice()))
                .collect(Collectors.toList());
        this.totalAmount = event.getTotalAmount();
        this.status = event.getStatus();
        this.shippingAddress = event.getShippingAddress();
        this.paymentMethod = event.getPaymentMethod();
        this.paymentStatus = event.getPaymentStatus();
        this.createdAt = event.getCreatedAt();
        this.updatedAt = event.getCreatedAt();
    }

    public void apply(OrderStatusUpdatedEvent event) {
        this.status = event.getStatus();
        this.updatedAt = event.getUpdatedAt();
    }

    public void apply(OrderPaymentStatusUpdatedEvent event) {
        this.paymentStatus = event.getPaymentStatus();
        this.updatedAt = event.getUpdatedAt();
    }

    public void apply(OrderCancelledEvent event) {
        this.status = OrderStatus.CANCELLED;
        this.updatedAt = event.getCancelledAt();
    }

    // Domain logic
    public void updateStatus(OrderStatus newStatus) {
        if (!isValidStatusTransition(this.status, newStatus)) {
            throw new IllegalStateException("Invalid status transition from " + this.status + " to " + newStatus);
        }
        this.status = newStatus;
        this.updatedAt = LocalDateTime.now();
    }

    public void updatePaymentStatus(PaymentStatus newStatus) {
        this.paymentStatus = newStatus;
        this.updatedAt = LocalDateTime.now();
    }

    public void cancel() {
        if (this.status == OrderStatus.DELIVERED || this.status == OrderStatus.CANCELLED) {
            throw new IllegalStateException("Cannot cancel a delivered or already cancelled order");
        }
        this.status = OrderStatus.CANCELLED;
        this.updatedAt = LocalDateTime.now();
    }

    private boolean isValidStatusTransition(OrderStatus current, OrderStatus next) {
        switch (current) {
            case PENDING:
                return next == OrderStatus.PROCESSING || next == OrderStatus.CANCELLED;
            case PROCESSING:
                return next == OrderStatus.SHIPPED || next == OrderStatus.CANCELLED;
            case SHIPPED:
                return next == OrderStatus.DELIVERED;
            case DELIVERED:
            case CANCELLED:
                return false;
            default:
                return false;
        }
    }
}
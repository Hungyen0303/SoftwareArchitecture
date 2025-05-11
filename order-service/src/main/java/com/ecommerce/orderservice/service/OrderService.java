package com.ecommerce.orderservice.service;

import com.ecommerce.orderservice.model.Order;
import java.util.List;
import java.util.Optional;

public interface OrderService {
    List<Order> getAllOrders();

    Optional<Order> getOrderById(Long id);

    List<Order> getOrdersByUserEmail(String userEmail);

    List<Order> getOrdersByStatus(Order.OrderStatus status);

    Order createOrder(Order order);

    Order updateOrderStatus(Long id, Order.OrderStatus status);

    Order updatePaymentStatus(Long id, Order.PaymentStatus status);

    void cancelOrder(Long id);
}
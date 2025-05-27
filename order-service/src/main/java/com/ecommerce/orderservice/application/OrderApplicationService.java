package com.ecommerce.orderservice.application;


import com.ecommerce.orderservice.domain.event.OrderCreatedEvent;
import com.ecommerce.orderservice.domain.model.Order;
import com.ecommerce.orderservice.domain.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OrderApplicationService {
    private final OrderService orderService;
    private final RabbitTemplate rabbitTemplate;

    public List<Order> getAllOrders() {
        return orderService.getAllOrders();
    }

    public Optional<Order> getOrderById(Long id) {
        return orderService.getOrderById(id);
    }

    public List<Order> getOrdersByUserEmail(String userEmail) {
        return orderService.getOrdersByUserEmail(userEmail);
    }

    public List<Order> getOrdersByStatus(Order.OrderStatus status) {
        return orderService.getOrdersByStatus(status);
    }

    public Order createOrder(Order order) {
        Order createdOrder = orderService.createOrder(order);
        // Publish domain event
        OrderCreatedEvent event = new OrderCreatedEvent(
                String.valueOf(createdOrder.getId()),
                createdOrder.getUserEmail(),
                createdOrder.getTotalAmount()
        );
        rabbitTemplate.convertAndSend("order.events", "", event);
        return createdOrder;
    }

    public Order updateOrderStatus(Long id, Order.OrderStatus status) {
        return orderService.updateOrderStatus(id, status);
    }

    public Order updatePaymentStatus(Long id, Order.PaymentStatus status) {
        return orderService.updatePaymentStatus(id, status);
    }

    public void cancelOrder(Long id) {
        orderService.cancelOrder(id);
    }
}
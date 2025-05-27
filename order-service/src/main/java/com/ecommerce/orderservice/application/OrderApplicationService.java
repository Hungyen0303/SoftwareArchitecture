package com.ecommerce.orderservice.application;

import com.ecommerce.orderservice.domain.dto.OrderDTO;
import com.ecommerce.orderservice.domain.dto.OrderItemDTO;
import com.ecommerce.orderservice.domain.event.OrderCreatedEvent;
import com.ecommerce.orderservice.domain.model.Order;
import com.ecommerce.orderservice.domain.model.OrderItem;
import com.ecommerce.orderservice.domain.service.OrderService;
import com.ecommerce.orderservice.infrastructure.messaging.EventPublisher;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderApplicationService {
    private final OrderService orderService;
    private final EventPublisher eventPublisher;

    public List<OrderDTO> getAllOrders() {
        return orderService.getAllOrders().stream()
                .map(this::toOrderDTO)
                .collect(Collectors.toList());
    }

    public Optional<OrderDTO> getOrderById(Long id) {
        return orderService.getOrderById(id)
                .map(this::toOrderDTO);
    }

    public List<OrderDTO> getOrdersByUserEmail(String userEmail) {
        return orderService.getOrdersByUserEmail(userEmail).stream()
                .map(this::toOrderDTO)
                .collect(Collectors.toList());
    }

    public List<OrderDTO> getOrdersByStatus(Order.OrderStatus status) {
        return orderService.getOrdersByStatus(status).stream()
                .map(this::toOrderDTO)
                .collect(Collectors.toList());
    }

    public Order createOrder(Order order) {
        Order createdOrder = orderService.createOrder(order);
        OrderCreatedEvent event = new OrderCreatedEvent(
                String.valueOf(createdOrder.getId()),
                createdOrder.getUserEmail(),
                createdOrder.getItems().stream()
                        .map(item -> new OrderCreatedEvent.OrderItemData(
                                item.getProductId(),
                                item.getProductName(),
                                item.getQuantity(),
                                item.getUnitPrice(),
                                item.getSubtotal()
                        ))
                        .collect(Collectors.toList()),
                createdOrder.getTotalAmount(),
                createdOrder.getStatus(),
                createdOrder.getShippingAddress(),
                createdOrder.getPaymentMethod(),
                createdOrder.getPaymentStatus(),
                createdOrder.getCreatedAt()

        );
        eventPublisher.publishOrderCreatedEvent(event);
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

    private OrderDTO toOrderDTO(Order order) {
        OrderDTO dto = new OrderDTO();
        dto.setId(order.getId());
        dto.setUserEmail(order.getUserEmail());
        dto.setItems(order.getItems().stream()
                .map(this::toOrderItemDTO)
                .collect(Collectors.toList()));
        dto.setTotalAmount(order.getTotalAmount());
        dto.setStatus(order.getStatus());
        dto.setShippingAddress(order.getShippingAddress());
        dto.setPaymentMethod(order.getPaymentMethod());
        dto.setPaymentStatus(order.getPaymentStatus());
        dto.setCreatedAt(order.getCreatedAt());
        dto.setUpdatedAt(order.getUpdatedAt());
        return dto;
    }

    private OrderItemDTO toOrderItemDTO(OrderItem item) {
        OrderItemDTO dto = new OrderItemDTO();
        dto.setId(item.getId());
        dto.setProductId(item.getProductId());
        dto.setProductName(item.getProductName());
        dto.setQuantity(item.getQuantity());
        dto.setUnitPrice(item.getUnitPrice());
        dto.setSubtotal(item.getSubtotal());
        return dto;
    }
}
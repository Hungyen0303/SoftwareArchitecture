package com.ecommerce.orderservice.domain.repositories;

import com.ecommerce.orderservice.domain.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUserEmail(String userEmail);
    List<Order> findByStatus(Order.OrderStatus status);
}
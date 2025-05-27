package com.ecommerce.orderservice.domain.repositories;

import com.ecommerce.orderservice.domain.model.Order;
import com.ecommerce.orderservice.domain.model.OrderState;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderStateRepo extends JpaRepository<OrderState, Long> {
        List<OrderState> findByUserEmail(String userEmail);
    List<OrderState> findByStatus(Order.OrderStatus status);
}

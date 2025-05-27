package com.ecommerce.orderservice.domain.repositories;

import com.ecommerce.orderservice.domain.model.OrderState;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderStateRepo extends JpaRepository<OrderState, Long> {
}

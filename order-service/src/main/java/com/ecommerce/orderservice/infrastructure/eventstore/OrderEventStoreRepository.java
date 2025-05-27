package com.ecommerce.orderservice.infrastructure.eventstore;


import com.ecommerce.orderservice.domain.event.OrderCancelledEvent;
import com.ecommerce.orderservice.domain.event.OrderCreatedEvent;
import com.ecommerce.orderservice.domain.event.OrderPaymentStatusUpdatedEvent;
import com.ecommerce.orderservice.domain.event.OrderStatusUpdatedEvent;
import com.ecommerce.orderservice.domain.model.Order;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.ExecutionException;

@Component
public class OrderEventStoreRepository {
    private final EventStoreRepository eventStoreRepository;

    public OrderEventStoreRepository(EventStoreRepository eventStoreRepository) {
        this.eventStoreRepository = eventStoreRepository;
    }

    public void save(Order order, List<Object> events) throws ExecutionException, InterruptedException {
        eventStoreRepository.saveEvents("order-" + order.getId(), events);
    }

    public Order load(Long orderId) throws ExecutionException, InterruptedException {
        List<Object> events = eventStoreRepository.loadEvents("order-" + orderId);
        Order order = new Order();
        for (Object event : events) {
            if (event instanceof OrderCreatedEvent) {
                order.apply((OrderCreatedEvent) event);
            } else if (event instanceof OrderStatusUpdatedEvent) {
                order.apply((OrderStatusUpdatedEvent) event);
            } else if (event instanceof OrderPaymentStatusUpdatedEvent) {
                order.apply((OrderPaymentStatusUpdatedEvent) event);
            } else if (event instanceof OrderCancelledEvent) {
                order.apply((OrderCancelledEvent) event);
            }
        }
        return order;
    }
}
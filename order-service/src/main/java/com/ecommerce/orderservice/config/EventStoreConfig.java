package com.ecommerce.orderservice.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EventStoreConfig {

    @Bean
    public EventStoreDBClient eventStoreDBClient() {
        EventStoreDBClientSettings settings = ConnectionString.parseOrThrow("esdb://localhost:2113?tls=false");
        return EventStoreDBClient.create(settings);
    }
}
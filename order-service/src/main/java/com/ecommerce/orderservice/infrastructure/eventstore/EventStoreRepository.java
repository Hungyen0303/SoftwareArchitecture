package com.ecommerce.orderservice.infrastructure.eventstore;

import com.eventstore.dbclient.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Component
public class EventStoreRepository {
    private final EventStoreDBClient client;
    private final ObjectMapper objectMapper;

    public EventStoreRepository(EventStoreDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    public void saveEvents(String streamId, List<Object> events) throws ExecutionException, InterruptedException {
        List<EventData> eventDataList = events.stream()
                .map(event -> {
                    try {
                        return EventData.builderAsJson(UUID.randomUUID(), event.getClass().getSimpleName(), objectMapper.writeValueAsBytes(event)).build();
                    } catch (Exception e) {
                        throw new RuntimeException("Failed to serialize event", e);
                    }
                })
                .collect(Collectors.toList());
        client.appendToStream(streamId, eventDataList).get();
    }

    public List<Object> loadEvents(String streamId) throws ExecutionException, InterruptedException {
        ReadResult result = client.readStream(streamId, ReadStreamOptions.get()).get();
        return result.getEvents().stream()
                .map(event -> {
                    try {
                        String eventType = event.getEvent().getEventType();
                        Class<?> eventClass = Class.forName("com.example.order.domain.event." + eventType);
                        return objectMapper.readValue(event.getEvent().getEventData(), eventClass);
                    } catch (Exception e) {
                        throw new RuntimeException("Failed to deserialize event", e);
                    }
                })
                .collect(Collectors.toList());
    }
}
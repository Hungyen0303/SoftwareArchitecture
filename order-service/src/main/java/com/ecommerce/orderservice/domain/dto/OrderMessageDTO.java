package com.ecommerce.orderservice.domain.dto;

import java.math.BigDecimal;

public class OrderMessageDTO {
    private String orderId;
    private String userEmail;
    private BigDecimal total;

    // Constructors
    public OrderMessageDTO() {}

    public OrderMessageDTO(String orderId, String userEmail, BigDecimal total) {
        this.orderId = orderId;
        this.userEmail = userEmail;
        this.total = total;
    }

    // Getters và setters
    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }
}

package com.example.notiservice.notification;

// DTO class
public class OrderMessageDTO {
    private String orderId;
    private String userEmail;
    private Double total;

    // Getters và setters
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    public Double getTotal() { return total; }
    public void setTotal(Double total) { this.total = total; }
}

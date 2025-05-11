//package com.ecommerce.orderservice.model;
//
//import jakarta.persistence.*;
//import jakarta.validation.constraints.Min;
//import jakarta.validation.constraints.NotNull;
//import lombok.Data;
//
//import java.math.BigDecimal;
//
//@Data
//@Entity
//@Table(name = "order_items")
//public class OrderItem {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "order_id", nullable = false)
//    private Order order;
//
//    @NotNull
//    @Column(name = "product_id", nullable = false)
//    private Long productId;
//
//    @NotNull
//    @Column(name = "product_name", nullable = false)
//    private String productName;
//
//    @NotNull
//    @Min(1)
//    @Column(name = "quantity", nullable = false)
//    private Integer quantity;
//
//    @NotNull
//    @Column(name = "unit_price", nullable = false)
//    private BigDecimal unitPrice;
//
//    @NotNull
//    @Column(name = "subtotal", nullable = false)
//    private BigDecimal subtotal;
//
//}
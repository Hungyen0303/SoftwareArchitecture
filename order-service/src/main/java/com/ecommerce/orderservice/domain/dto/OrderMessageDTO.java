package com.ecommerce.orderservice.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class OrderMessageDTO {
    private String orderId;
    private String userEmail;
    private BigDecimal total;

}

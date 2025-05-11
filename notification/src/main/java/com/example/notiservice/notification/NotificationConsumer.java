package com.example.notiservice.notification;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class NotificationConsumer {
    private static final Logger log = LoggerFactory.getLogger(NotificationConsumer.class);

    private final JavaMailSender mailSender;

    public NotificationConsumer(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @RabbitListener(queues = "${rabbitmq.queue:notification.queue}")
    public void receiveOrderMessage(OrderMessageDTO message) {
        log.info("Received message: orderId={}, userEmail={}, total={}",
                message.getOrderId(), message.getUserEmail(), message.getTotal());

        // Tạo email
        SimpleMailMessage mailMessage = new SimpleMailMessage();
        mailMessage.setTo(message.getUserEmail());
        mailMessage.setSubject("Order Confirmation");
        mailMessage.setText("Dear Customer,\n\nYour order " + message.getOrderId() +
                " with total $" + message.getTotal() +
                " has been placed successfully.\n\nThank you for shopping with us!");
        mailMessage.setFrom("nguyenhungyen0000@gmail.com"); // Thay bằng email của bạn

        // Gửi email
        try {
            mailSender.send(mailMessage);
            log.info("Email sent to {}", message.getUserEmail());
        } catch (Exception e) {
            log.error("Failed to send email to {}: {}", message.getUserEmail(), e.getMessage());
        }
    }
}
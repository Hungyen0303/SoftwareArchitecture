import 'cart.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String userEmail;
  final List<CartItem> items;
  final double total;
  final String shippingAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Order({
    required this.id,
    required this.userEmail,
    required this.items,
    required this.total,
    required this.shippingAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      userEmail: json["userEmail"] as String,
      items: [],
      total: json["totalAmount"]  ,
      shippingAddress: json['shippingAddress'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: OrderStatus.values.firstWhere(
            (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userEmail,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
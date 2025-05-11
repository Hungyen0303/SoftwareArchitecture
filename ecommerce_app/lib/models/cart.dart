import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  // Copy with method
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  // Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}

class Cart {
  final String userId;
  final List<CartItem> items;
  final double total;

  const Cart({
    required this.userId,
    this.items = const [],
    this.total = 0.0,
  });

  // Copy with method
  Cart copyWith({
    String? userId,
    List<CartItem>? items,
    double? total,
  }) {
    return Cart(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      total: total ?? this.total,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }

  // Create from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cart &&
        other.userId == userId &&
        _listEquals(other.items, items) &&
        other.total == total;
  }

  @override
  int get hashCode => userId.hashCode ^ items.hashCode ^ total.hashCode;
}

// Helper function for list equality
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
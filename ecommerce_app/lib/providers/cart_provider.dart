import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  Cart _cart = Cart(userId: '');

  Cart get cart => _cart;

  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      final updatedItems = List<CartItem>.from(_cart.items);
      updatedItems[existingItemIndex] = CartItem(
        product: product,
        quantity: updatedItems[existingItemIndex].quantity + quantity,
      );
      _cart = Cart(
        userId: _cart.userId,
        items: updatedItems,
        total: _calculateTotal(updatedItems),
      );
    } else {
      final updatedItems = List<CartItem>.from(_cart.items)
        ..add(CartItem(product: product, quantity: quantity));
      _cart = Cart(
        userId: _cart.userId,
        items: updatedItems,
        total: _calculateTotal(updatedItems),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    final updatedItems = _cart.items.where((item) => item.product.id != productId).toList();
    _cart = Cart(
      userId: _cart.userId,
      items: updatedItems,
      total: _calculateTotal(updatedItems),
    );
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final updatedItems = _cart.items.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: quantity);
      }
      return item;
    }).toList();

    _cart = Cart(
      userId: _cart.userId,
      items: updatedItems,
      total: _calculateTotal(updatedItems),
    );
    notifyListeners();
  }

  void clearCart() {
    _cart = Cart(userId: _cart.userId);
    notifyListeners();
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(
      0.0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }
} 
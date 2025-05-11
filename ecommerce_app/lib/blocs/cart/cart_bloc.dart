import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCart(this.product, this.quantity);

  @override
  List<Object> get props => [product, quantity];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);

  @override
  List<Object> get props => [cart];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiService _apiService;
  final String userId;

  CartBloc({required ApiService apiService, required this.userId})
    : _apiService = apiService,
      super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final currentCart = await _apiService.getCart(userId);

      final updatedItems = List<CartItem>.from(currentCart.items);
      final existingItemIndex = updatedItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (existingItemIndex >= 0) {
        updatedItems[existingItemIndex] = CartItem(
          product: event.product,
          quantity: updatedItems[existingItemIndex].quantity + event.quantity,
        );
      } else {
        updatedItems.add(
          CartItem(product: event.product, quantity: event.quantity),
        );
      }

      final updatedCart = Cart(
        userId: userId,
        items: updatedItems,
        total: _calculateTotal(updatedItems),
      );

      await _apiService.updateCart(updatedCart);
      emit(CartLoaded(updatedCart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());
      final currentCart = await _apiService.getCart(userId);

      final updatedItems =
          currentCart.items
              .where((item) => item.product.id != event.productId)
              .toList();

      final updatedCart = Cart(
        userId: userId,
        items: updatedItems,
        total: _calculateTotal(updatedItems),
      );

      await _apiService.updateCart(updatedCart);
      emit(CartLoaded(updatedCart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());
      final currentCart = await _apiService.getCart(userId);

      final updatedItems =
          currentCart.items.map((item) {
            if (item.product.id == event.productId) {
              return CartItem(product: item.product, quantity: event.quantity);
            }
            return item;
          }).toList();

      final updatedCart = Cart(
        userId: userId,
        items: updatedItems,
        total: _calculateTotal(updatedItems),
      );

      await _apiService.updateCart(updatedCart);
      emit(CartLoaded(updatedCart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final emptyCart = Cart(userId: userId);
      await _apiService.updateCart(emptyCart);
      emit(CartLoaded(emptyCart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(
      0.0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }
}

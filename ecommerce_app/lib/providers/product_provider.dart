import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/models/product.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  ProductProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _apiService.getProducts();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<Product> fetchProduct(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final product = await _apiService.getProduct(id);
      _selectedProduct = product;

      _isLoading = false;
      notifyListeners();
      return product;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }
}

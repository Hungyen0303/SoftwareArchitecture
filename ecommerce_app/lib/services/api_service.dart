import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/cart.dart';

class ApiService {
  late final Dio _dio;
  final String _baseUrl = 'http://192.168.1.96:8080/api/v1/';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) {
          print('Dio Error: ${e.response?.statusCode} - ${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }

  // Lưu token sau khi đăng nhập
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Xóa token khi đăng xuất
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Product endpoints
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('products');
      return (response.data as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> getProduct(String id) async {
    try {
      final response = await _dio.get('products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  // Auth endpoints
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'users/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data['token'] as String?;
      if (token != null) {
        await saveToken(token);
      }
      return User.fromJson(response.data['user']);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User> register(
      String email,
      String password,
      String firstName,
      String lastName,
      ) async {
    try {
      final response = await _dio.post(
        'users/register',
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Cart endpoints
  Future<Cart> getCart(String userId) async {
    try {
      final response = await _dio.get('cart/$userId');
      return Cart.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  Future<void> updateCart(Cart cart) async {
    try {
      await _dio.put('cart/${cart.userId}', data: cart.toJson());
    } catch (e) {
      throw Exception('Failed to update cart: $e');
    }
  }

  // Order endpoints
  Future<Order> createOrder(Order  order, String email ) async {

    final dataSent = {
      "userEmail"  : email ,
      'items' : order.items.map((e) => e.product.id).toList() ,
      "totalAmount": order.total,
      "shippingAddress": order.shippingAddress,
      "paymentMethod": order.paymentMethod,
      };
    print(dataSent);
    try {
      final response = await _dio.post('orders', data: dataSent);
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final response = await _dio.get('orders/user/$userId');
      return (response.data as List).map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
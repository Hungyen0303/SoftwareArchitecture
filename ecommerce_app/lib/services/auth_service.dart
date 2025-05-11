import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;
  User? _currentUser;

  AuthService(this._apiService) : _secureStorage = const FlutterSecureStorage();

  User? get currentUser => _currentUser;

  Future<User> login(String email, String password) async {
    try {
      final user = await _apiService.login(email, password);
      await _saveUserData(user);
      _currentUser = user;
      return user;
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
      final user = await _apiService.register(
        email,
        password,
        firstName,
        lastName,
      );
      await _saveUserData(user);
      _currentUser = user;
      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
    await SharedPreferences.getInstance().then((prefs) => prefs.clear());
    _currentUser = null;
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) return false;

      final userData = await _secureStorage.read(key: 'user_data');
      if (userData == null) return false;

      _currentUser = User.fromJson(userData as Map<String, dynamic>);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveUserData(User user) async {
    await _secureStorage.write(
      key: 'user_data',
      value: user.toJson().toString(),
    );
  }

  Future<void> updateUserProfile(User user) async {
    try {
      await _saveUserData(user);
      _currentUser = user;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<Order> createOrder(Order order  , String email ) async {
    try {
      return await _apiService.createOrder(order , email);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final List<String> orderHistory;
  final bool isAdmin;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.orderHistory = const [],
    this.isAdmin = false,
  });

  // Copy with method
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    List<String>? orderHistory,
    bool? isAdmin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      orderHistory: orderHistory ?? this.orderHistory,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'orderHistory': orderHistory,
      'isAdmin': isAdmin,
    };
  }

  // Create from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? '', // Gán rỗng nếu không có
      email: json['email'] as String? ?? '', // Gán rỗng nếu không có
      name: json['name'] as String? ?? '', // Gán rỗng nếu không có
      phoneNumber: json['phoneNumber'] as String?, // Giữ nullable, không gán rỗng
      orderHistory: (json['orderHistory'] as List<dynamic>?)?.cast<String>() ?? const [],
      isAdmin: json['isAdmin'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        _listEquals(other.orderHistory, orderHistory) &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      orderHistory.hashCode ^
      isAdmin.hashCode;
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
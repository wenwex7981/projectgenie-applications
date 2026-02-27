import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import '../models/models.dart';
import '../data/mock_data.dart';

class ApiService {
  static String get baseUrl {
    return 'https://projectgenie-api.onrender.com';
  }

  // ─── Connection Config ────────────────────────────────────────────
  static const Duration _timeout = Duration(seconds: 8);

  // ─── Stored JWT Token ──────────────────────────────────────────────
  static String? _token;
  static String? _userId;
  static Map<String, dynamic>? _cachedUser;
  static String? get token => _token;
  static String? get userId => _userId;
  static Map<String, dynamic>? get cachedUser => _cachedUser;
  static void setToken(String? t) => _token = t;
  static void setUserId(String? id) => _userId = id;
  static void setCachedUser(Map<String, dynamic>? u) => _cachedUser = u;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  /// Unwrap the enterprise response envelope { success, data, timestamp }
  /// Falls back to raw body if not wrapped (backward compatibility)
  static dynamic _unwrap(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map && decoded.containsKey('success') && decoded.containsKey('data')) {
        return decoded['data'];
      }
      return decoded;
    } catch (_) {
      return body;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  VENDORS (for buyer's agency listing)
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getVendors() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vendors'),
        headers: _headers,
      ).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = _unwrap(response.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('API Error (getVendors): $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getVendorProfile(String vendorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId'),
        headers: _headers,
      ).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = _unwrap(response.body);
        if (data is Map) return Map<String, dynamic>.from(data);
      }
    } catch (e) {
      print('API Error (getVendorProfile): $e');
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  AUTH
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> register({
    required String email, required String password, required String name,
    String? phone, String? college, String? branch,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/buyer/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email, 'password': password, 'name': name,
          'phone': phone, 'college': college, 'branch': branch,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      final err = json.decode(response.body);
      throw Exception(err['message'] ?? 'Registration failed');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/buyer/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          _token = data['token'];
          _userId = data['user']?['id'];
        }
        return data;
      }
      final err = json.decode(response.body);
      throw Exception(err['message'] ?? 'Login failed');
    } catch (e) {
      if (e is Exception) rethrow;
      print('API Error: $e. Simulating success for demo.');
      if (email.isNotEmpty && password.length >= 6) {
        return {'token': 'mock-jwt-token', 'user': {'id': 'user-001', 'name': 'Demo User'}};
      }
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String email, String code, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': code, 'role': role}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          _token = data['token'];
          _userId = data['user']?['id'];
        }
        return data;
      }
      final err = json.decode(response.body);
      throw Exception(err['message'] ?? 'OTP verification failed');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyLoginOtp(String email, String code, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-login-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': code, 'role': role}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          _token = data['token'];
          _userId = data['user']?['id'];
        }
        return data;
      }
      final err = json.decode(response.body);
      throw Exception(err['message'] ?? 'OTP verification failed');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> resendOtp(String email, String role, {String type = 'login'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'role': role, 'type': type}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      throw Exception('Failed to resend OTP');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': token}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      throw Exception('Invalid token');
    } catch (e) {
      throw Exception('Token verification failed');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CATEGORIES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    return AppCategories.main.map((cat) => {
      'id': cat.id,
      'title': cat.title,
      'subtitle': cat.subtitle,
      'count': cat.count,
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SERVICES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<ServiceModel>> getFeaturedServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services/featured'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
           return data.map((json) => ServiceModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    return MockData.trendingServices;
  }

  static Future<List<ServiceModel>> getTrendingServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services/trending'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data.map((json) => ServiceModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    return MockData.trendingServices;
  }

  static Future<List<ServiceModel>> getMiniProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services?category=Mini+Project'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data.map((json) => ServiceModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    return MockData.generalProjects;
  }

  static Future<List<ServiceModel>> getServices({String? category}) async {
    try {
      String url = '$baseUrl/services';
      if (category != null) {
        url += '?category=${Uri.encodeComponent(category)}';
      }
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = _unwrap(response.body);
        if (data is List) {
          return data.map((json) => ServiceModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    
    List<ServiceModel> all = [...MockData.trendingServices, ...MockData.generalProjects, ...MockData.resumeTemplates];
    if (category == null) return all;
    return all.where((s) => s.category.contains(category) || category.contains(s.category)).toList();
  }

  static Future<Map<String, dynamic>?> getServiceById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  PROJECTS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getProjects({String? domain, bool? featured}) async {
    try {
      String url = '$baseUrl/projects';
      List<String> params = [];
      if (domain != null) params.add('domain=${Uri.encodeComponent(domain)}');
      if (featured == true) params.add('featured=true');
      if (params.isNotEmpty) url += '?${params.join('&')}';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getFeaturedProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects/featured'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  BUNDLES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getBundles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bundles'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    return [
      {'title': 'Final Year Complete Bundle', 'items': 'Project + Report + PPT + Video', 'price': '9,999', 'original_price': '15,999'},
    ];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<OrderModel>> getOrders({String? userId}) async {
    try {
      final uid = userId ?? _userId ?? 'user-001';
      final response = await http.get(
        Uri.parse('$baseUrl/users/$uid/orders'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.map((json) => OrderModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    return MockData.orders;
  }

  static Future<Map<String, dynamic>> createOrder(String serviceId, double totalPrice) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
        body: json.encode({
          'serviceId': serviceId,
          'userId': _userId ?? 'user-001',
          'totalPrice': totalPrice,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
       print('API Error: $e. Simulating success.');
       await Future.delayed(const Duration(seconds: 1));
       return {'id': 'ORDER-${DateTime.now().millisecondsSinceEpoch}', 'status': 'success'};
    }
    throw Exception('Failed to create order');
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CUSTOM ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> createCustomOrder(Map<String, dynamic> data) async {
    try {
      data['userId'] = _userId ?? 'user-001';
      final response = await http.post(
        Uri.parse('$baseUrl/custom-orders'),
        headers: _headers,
        body: json.encode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to create custom order');
  }

  static Future<List<Map<String, dynamic>>> getCustomOrders({String? userId}) async {
    try {
      final uid = userId ?? _userId ?? 'user-001';
      final response = await http.get(
        Uri.parse('$baseUrl/users/$uid/custom-orders'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  USER PROFILE
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>?> getUserProfile({String? userId}) async {
    try {
      final uid = userId ?? _userId ?? 'user-001';
      final response = await http.get(
        Uri.parse('$baseUrl/users/$uid'),
        headers: _headers,
      ).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = _unwrap(response.body);
        if (data is Map) {
          _cachedUser = Map<String, dynamic>.from(data);
          return _cachedUser;
        }
      }
    } catch (e) {
      print('API Error: $e');
    }
    return _cachedUser;
  }

  static Future<Map<String, dynamic>?> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final uid = _userId ?? 'user-001';
      final response = await http.put(
        Uri.parse('$baseUrl/users/$uid'),
        headers: _headers,
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  WALLET
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>?> getWallet() async {
    try {
      final uid = _userId ?? 'user-001';
      final response = await http.get(
        Uri.parse('$baseUrl/users/$uid/wallet'),
        headers: _headers,
      ).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = _unwrap(response.body);
        if (data is Map) return Map<String, dynamic>.from(data);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return {'balance': 0};
  }

  static Future<Map<String, dynamic>?> topupWallet(double amount) async {
    try {
      final uid = _userId ?? 'user-001';
      final response = await http.put(
        Uri.parse('$baseUrl/users/$uid/wallet/topup'),
        headers: _headers,
        body: json.encode({'amount': amount}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SEARCH
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> search(String query, {String? type}) async {
    try {
      String url = '$baseUrl/search?q=${Uri.encodeComponent(query)}';
      if (type != null) url += '&type=$type';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return {'services': [], 'projects': []};
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CHAT
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getChatThreads() async {
    try {
      final uid = _userId ?? 'user-001';
      final response = await http.get(Uri.parse('$baseUrl/chats/threads/user/$uid')).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = _unwrap(response.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getChatMessages(String vendorId) async {
    try {
      final uid = _userId ?? 'user-001';
      final response = await http.get(
        Uri.parse('$baseUrl/chats?userId=$uid&vendorId=$vendorId'),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> sendMessage(String vendorId, String text) async {
    try {
      final uid = _userId ?? 'user-001';
      final response = await http.post(
        Uri.parse('$baseUrl/chats'),
        headers: _headers,
        body: json.encode({
          'userId': uid,
          'vendorId': vendorId,
          'text': text,
          'isSender': true,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final uid = _userId ?? 'user-001';
      final response = await http.get(Uri.parse('$baseUrl/notifications?targetId=$uid')).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = _unwrap(response.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  REVIEWS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getReviews(String serviceId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reviews/service/$serviceId'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> createReview({
    required String serviceId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: _headers,
        body: json.encode({
          'serviceId': serviceId,
          'userId': _userId,
          'userName': userName,
          'rating': rating,
          'comment': comment,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('API Error: $e');
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HEALTH CHECK
  // ═══════════════════════════════════════════════════════════════════

  static Future<bool> isServerReachable() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health')).timeout(
        const Duration(seconds: 3),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

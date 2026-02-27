import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class ApiService {
  static String get baseUrl {
    return 'https://projectgenie-api.onrender.com';
  }

  // ─── Stored JWT Token & Vendor ID ──────────────────────────────────
  static String? _token;
  static String? _vendorId;
  static String? get token => _token;
  static String? get vendorId => _vendorId;
  static void setToken(String? t) => _token = t;
  static void setVendorId(String? id) => _vendorId = id;

  static Map<String, String> get _authHeaders => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ═══════════════════════════════════════════════════════════════════
  //  AUTH
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> vendorLogin(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/vendor/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        if (data['token'] != null) {
          _token = data['token'];
          _vendorId = data['vendor']?['id'];
        }
        return data;
      }
      final err = jsonDecode(res.body);
      throw Exception(err['message'] ?? 'Login failed');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> vendorRegister({
    required String email, required String password,
    required String name, required String businessName,
    String? phone, String? bio,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/vendor/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email, 'password': password,
          'name': name, 'businessName': businessName,
          'phone': phone, 'bio': bio,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        if (data['token'] != null) {
          _token = data['token'];
          _vendorId = data['vendor']?['id'];
        }
        return data;
      }
      final err = jsonDecode(res.body);
      throw Exception(err['message'] ?? 'Registration failed');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String email, String code) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code, 'role': 'vendor'}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        if (data['token'] != null) {
          _token = data['token'];
          _vendorId = data['vendor']?['id'];
        }
        return data;
      }
      final err = jsonDecode(res.body);
      throw Exception(err['message'] ?? 'OTP verification failed');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyLoginOtp(String email, String code) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/verify-login-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code, 'role': 'vendor'}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        if (data['token'] != null) {
          _token = data['token'];
          _vendorId = data['vendor']?['id'];
        }
        return data;
      }
      final err = jsonDecode(res.body);
      throw Exception(err['message'] ?? 'OTP verification failed');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> resendOtp(String email, {String type = 'login'}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'role': 'vendor', 'type': type}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
      throw Exception('Failed to resend OTP');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
      throw Exception('Invalid token');
    } catch (e) {
      throw Exception('Token verification failed');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  VENDOR DASHBOARD
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getDashboard(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId/dashboard'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    // Fallback mock
    return {
      'stats': {
        'totalOrders': 0, 'activeOrders': 0, 'completedOrders': 0,
        'totalServices': 0, 'totalProjects': 0, 'pendingCustomOrders': 0,
        'totalEarnings': 0,
      },
      'recentOrders': [],
      'recentTransactions': [],
    };
  }

  static Future<Map<String, dynamic>> getProfile(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to load profile');
  }

  static Future<Map<String, dynamic>> updateProfile(String vendorId, Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/vendors/$vendorId'),
        headers: _authHeaders,
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to update profile');
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SERVICES CRUD
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorServices(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId/services'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> createService(Map<String, dynamic> data) async {
    try {
      if (_vendorId == null) throw Exception('Vendor Session Expired. Please login again.');
      data['vendorId'] = _vendorId;
      final res = await http.post(
        Uri.parse('$baseUrl/services'),
        headers: _authHeaders,
        body: jsonEncode(data),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print('API Error (createService): ${e.toString()}');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateService(String id, Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/services/$id'),
        headers: _authHeaders,
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to update service');
  }

  static Future<void> deleteService(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/services/$id'),
        headers: _authHeaders,
      );
      if (res.statusCode != 200) throw Exception('Failed to delete service');
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  PROJECTS CRUD
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorProjects(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId/projects'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> createProject(Map<String, dynamic> data) async {
    try {
      if (_vendorId == null) throw Exception('Vendor Session Expired. Please login again.');
      data['vendorId'] = _vendorId;
      final res = await http.post(
        Uri.parse('$baseUrl/projects'),
        headers: _authHeaders,
        body: jsonEncode(data),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      print('API Error (createProject): ${e.toString()}');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateProject(String id, Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/projects/$id'),
        headers: _authHeaders,
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to update project');
  }

  static Future<void> deleteProject(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/projects/$id'),
        headers: _authHeaders,
      );
      if (res.statusCode != 200) throw Exception('Failed to delete project');
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorOrders(String vendorId, {String? status}) async {
    try {
      var url = '$baseUrl/vendors/$vendorId/orders';
      if (status != null) url += '?status=$status';
      final res = await http.get(
        Uri.parse(url),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/status'),
        headers: _authHeaders,
        body: jsonEncode({'status': status}),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to update order status');
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CUSTOM ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorCustomOrders(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId/custom-orders'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> acceptCustomOrder(String orderId, {String? notes, double? price}) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/custom-orders/$orderId/accept'),
        headers: _authHeaders,
        body: jsonEncode({'vendorNotes': notes, 'quotedPrice': price}),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to accept custom order');
  }

  static Future<Map<String, dynamic>> rejectCustomOrder(String orderId, {String? notes}) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/custom-orders/$orderId/reject'),
        headers: _authHeaders,
        body: jsonEncode({'vendorNotes': notes}),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    throw Exception('Failed to reject custom order');
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EARNINGS
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getEarnings(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId/earnings'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    return {'totalEarnings': 0, 'pendingEarnings': 0, 'thisMonthEarnings': 0};
  }

  static Future<List<dynamic>> getTransactions(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/vendors/$vendorId/transactions'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CATEGORIES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getCategories() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/categories'));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CHAT
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getChatThreads(String vendorId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/chats/threads/vendor/$vendorId'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(res.body));
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getChatMessages(String userId) async {
    try {
      final vid = _vendorId ?? '';
      final res = await http.get(
        Uri.parse('$baseUrl/chats?userId=$userId&vendorId=$vid'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(res.body));
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> sendMessage(String userId, String text) async {
    try {
      final vid = _vendorId ?? '';
      final res = await http.post(
        Uri.parse('$baseUrl/chats'),
        headers: _authHeaders,
        body: jsonEncode({
          'userId': userId,
          'vendorId': vid,
          'text': text,
          'isSender': false,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
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
      final vid = _vendorId ?? '';
      final res = await http.get(
        Uri.parse('$baseUrl/notifications?targetId=$vid'),
        headers: _authHeaders,
      );
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(res.body));
      }
    } catch (e) {
      print('API Error: $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HEALTH CHECK
  // ═══════════════════════════════════════════════════════════════════

  static Future<bool> isServerReachable() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/health')).timeout(
        const Duration(seconds: 3),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

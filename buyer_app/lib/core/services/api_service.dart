import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

/// Buyer API Service — Now connects directly to Supabase
/// All CRUD operations go through Supabase client, not HTTP backend
class ApiService {
  static SupabaseClient get _client => Supabase.instance.client;

  // ─── Stored JWT Token & User ID ─────────────────────────────────
  static String? _token;
  static String? _userId;
  static Map<String, dynamic>? _cachedUser;
  static String? get token => _token;
  static String? get userId => _userId;
  static Map<String, dynamic>? get cachedUser => _cachedUser;
  static void setToken(String? t) => _token = t;
  static void setUserId(String? id) => _userId = id;
  static void setCachedUser(Map<String, dynamic>? u) => _cachedUser = u;

  // ═══════════════════════════════════════════════════════════════════
  //  VENDORS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getVendors() async {
    try {
      final response = await _client.from('Vendor').select().eq('status', 'active').order('rating', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error (getVendors): $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getVendorProfile(String vendorId) async {
    try {
      return await _client.from('Vendor').select().eq('id', vendorId).maybeSingle();
    } catch (e) {
      print('API Error (getVendorProfile): $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CATEGORIES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _client.from('Category').select().order('sortOrder', ascending: true);
      if (response is List && response.isNotEmpty) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('API Error (getCategories): $e');
    }
    return AppCategories.main.map((cat) => {
      'id': cat.id, 'title': cat.title, 'subtitle': cat.subtitle, 'count': cat.count,
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SERVICES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<ServiceModel>> getFeaturedServices() async {
    try {
      final response = await _client.from('Service').select()
          .eq('isFeatured', true).eq('isActive', true).order('createdAt', ascending: false);
      if (response is List && response.isNotEmpty) {
        return response.map((json) => ServiceModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('API Error (getFeaturedServices): $e');
    }
    return MockData.trendingServices;
  }

  static Future<List<ServiceModel>> getTrendingServices() async {
    try {
      final response = await _client.from('Service').select()
          .eq('isTrending', true).eq('isActive', true).order('createdAt', ascending: false);
      if (response is List && response.isNotEmpty) {
        return response.map((json) => ServiceModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('API Error (getTrendingServices): $e');
    }
    return MockData.trendingServices;
  }

  static Future<List<ServiceModel>> getMiniProjects() async {
    try {
      final response = await _client.from('Service').select()
          .ilike('categoryId', '%mini%').eq('isActive', true);
      if (response is List && response.isNotEmpty) {
        return response.map((json) => ServiceModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('API Error (getMiniProjects): $e');
    }
    return MockData.generalProjects;
  }

  static Future<List<ServiceModel>> getServices({String? category}) async {
    try {
      var query = _client.from('Service').select().eq('isActive', true);
      if (category != null && category.isNotEmpty) {
        query = query.ilike('categoryId', '%$category%');
      }
      final response = await query.order('createdAt', ascending: false);
      if (response is List && response.isNotEmpty) {
        return response.map((json) => ServiceModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('API Error (getServices): $e');
    }
    // Fallback
    List<ServiceModel> all = [...MockData.trendingServices, ...MockData.generalProjects, ...MockData.resumeTemplates];
    if (category == null) return all;
    return all.where((s) => s.category.contains(category) || category.contains(s.category)).toList();
  }

  static Future<Map<String, dynamic>?> getServiceById(String id) async {
    try {
      return await _client.from('Service').select().eq('id', id).maybeSingle();
    } catch (e) {
      print('API Error (getServiceById): $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  PROJECTS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getProjects({String? domain, bool? featured}) async {
    try {
      var query = _client.from('Project').select().eq('isActive', true);
      if (domain != null && domain.isNotEmpty) {
        query = query.ilike('domain', '%$domain%');
      }
      if (featured == true) {
        query = query.eq('isFeatured', true);
      }
      final response = await query.order('createdAt', ascending: false);
      if (response is List) return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error (getProjects): $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getFeaturedProjects() async {
    try {
      final response = await _client.from('Project').select()
          .eq('isFeatured', true).eq('isActive', true).order('createdAt', ascending: false);
      if (response is List) return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error (getFeaturedProjects): $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getProjectById(String id) async {
    try {
      return await _client.from('Project').select().eq('id', id).maybeSingle();
    } catch (e) {
      print('API Error (getProjectById): $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HACKATHONS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getHackathons() async {
    try {
      final response = await _client.from('Hackathon').select()
          .eq('isActive', true).order('createdAt', ascending: false);
      if (response is List) return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error (getHackathons): $e');
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getFeaturedHackathons() async {
    return getHackathons(); // All active hackathons
  }

  static Future<Map<String, dynamic>?> getHackathonById(String id) async {
    try {
      return await _client.from('Hackathon').select().eq('id', id).maybeSingle();
    } catch (e) {
      print('API Error (getHackathonById): $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  BUNDLES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getBundles() async {
    try {
      final response = await _client.from('Bundle').select();
      if (response is List && response.isNotEmpty) return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error (getBundles): $e');
    }
    return [{'title': 'Final Year Complete Bundle', 'items': 'Project + Report + PPT + Video', 'price': '9,999', 'original_price': '15,999'}];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<OrderModel>> getOrders({String? userId}) async {
    try {
      final uid = userId ?? _userId;
      if (uid == null) return MockData.orders;
      final response = await _client.from('Order').select('*, service:Service(title, imageUrl)')
          .eq('userId', uid).order('date', ascending: false);
      if (response is List && response.isNotEmpty) {
        return response.map((json) => OrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('API Error (getOrders): $e');
    }
    return MockData.orders;
  }

  static Future<Map<String, dynamic>> createOrder(String serviceId, double totalPrice) async {
    final uid = _userId ?? _client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');
    final response = await _client.from('Order').insert({
      'serviceId': serviceId,
      'userId': uid,
      'totalPrice': totalPrice,
      'orderNumber': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
    }).select().single();
    return response;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CUSTOM ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> createCustomOrder(Map<String, dynamic> data) async {
    final uid = _userId ?? _client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');
    data['userId'] = uid;
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('CustomOrder').insert(data).select().single();
    return response;
  }

  static Future<List<Map<String, dynamic>>> getCustomOrders({String? userId}) async {
    try {
      final uid = userId ?? _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return [];
      final response = await _client.from('CustomOrder').select()
          .eq('userId', uid).order('createdAt', ascending: false);
      if (response is List) return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error (getCustomOrders): $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  //  USER PROFILE
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>?> getUserProfile({String? userId}) async {
    try {
      final uid = userId ?? _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return _cachedUser;
      final response = await _client.from('User').select().eq('id', uid).maybeSingle();
      if (response != null) {
        _cachedUser = response;
        return response;
      }
    } catch (e) {
      print('API Error (getUserProfile): $e');
    }
    return _cachedUser;
  }

  static Future<Map<String, dynamic>?> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return null;
      data['updatedAt'] = DateTime.now().toIso8601String();
      final response = await _client.from('User').update(data).eq('id', uid).select().single();
      _cachedUser = response;
      return response;
    } catch (e) {
      print('API Error (updateUserProfile): $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  WALLET
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>?> getWallet() async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return {'balance': 0};
      final user = await _client.from('User').select('walletBalance').eq('id', uid).single();
      return {'balance': user['walletBalance'] ?? 0};
    } catch (e) {
      return {'balance': 0};
    }
  }

  static Future<Map<String, dynamic>?> topupWallet(double amount) async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return null;
      final user = await _client.from('User').select('walletBalance').eq('id', uid).single();
      final newBalance = (user['walletBalance'] ?? 0) + amount;
      await _client.from('User').update({'walletBalance': newBalance, 'updatedAt': DateTime.now().toIso8601String()}).eq('id', uid);
      return {'balance': newBalance};
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SEARCH
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> search(String query, {String? type}) async {
    try {
      final projects = await _client.from('Project').select()
          .or('title.ilike.%$query%,description.ilike.%$query%,domain.ilike.%$query%').limit(20);
      final services = await _client.from('Service').select()
          .or('title.ilike.%$query%,description.ilike.%$query%').limit(20);
      return {'services': services, 'projects': projects};
    } catch (e) {
      return {'services': [], 'projects': []};
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CHAT
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getChatThreads() async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return [];
      final response = await _client.from('ChatMessage').select('vendorId, vendor:Vendor(name, businessName)')
          .eq('userId', uid).order('time', ascending: false);
      // Deduplicate by vendorId
      final Map<String, Map<String, dynamic>> threads = {};
      for (final msg in response) {
        final vid = msg['vendorId'] as String;
        if (!threads.containsKey(vid)) threads[vid] = msg;
      }
      return threads.values.toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getChatMessages(String vendorId) async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return [];
      final response = await _client.from('ChatMessage').select()
          .eq('userId', uid).eq('vendorId', vendorId).order('time', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> sendMessage(String vendorId, String text) async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return null;
      final response = await _client.from('ChatMessage').insert({
        'userId': uid, 'vendorId': vendorId, 'text': text, 'isSender': true,
      }).select().single();
      return response;
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return [];
      final response = await _client.from('Notification').select()
          .eq('targetId', uid).order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  static Future<void> markNotificationRead(String notifId) async {
    try {
      await _client.from('Notification').update({'isRead': true}).eq('id', notifId);
    } catch (e) {
      print('API Error (markNotificationRead): $e');
    }
  }

  static Future<void> markAllNotificationsRead() async {
    try {
      final uid = _userId ?? _client.auth.currentUser?.id;
      if (uid == null) return;
      await _client.from('Notification').update({'isRead': true}).eq('targetId', uid);
    } catch (e) {
      print('API Error (markAllNotificationsRead): $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  REVIEWS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getReviews(String serviceId) async {
    try {
      final response = await _client.from('Review').select()
          .eq('serviceId', serviceId).order('date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> createReview({
    required String serviceId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await _client.from('Review').insert({
        'serviceId': serviceId,
        'userId': _userId ?? _client.auth.currentUser?.id,
        'userName': userName,
        'rating': rating,
        'comment': comment,
        'date': DateTime.now().toIso8601String(),
      }).select().single();
      return response;
    } catch (e) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  FILE UPLOAD (Supabase Storage)
  // ═══════════════════════════════════════════════════════════════════

  static Future<String?> uploadFile({
    required String bucket,
    required String path,
    required Uint8List fileBytes,
    String contentType = 'image/jpeg',
  }) async {
    try {
      await _client.storage.from(bucket).uploadBinary(path, fileBytes,
        fileOptions: FileOptions(contentType: contentType, upsert: true));
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HEALTH CHECK
  // ═══════════════════════════════════════════════════════════════════

  static Future<bool> isServerReachable() async {
    try {
      await _client.from('Category').select('id').limit(1);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  LOGOUT
  // ═══════════════════════════════════════════════════════════════════

  static Future<void> logout() async {
    await _client.auth.signOut();
    _token = null;
    _userId = null;
    _cachedUser = null;
  }
}

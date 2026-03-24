import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as dart_math;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Vendor API Service — now connects directly to Supabase
/// All CRUD operations go through Supabase client, not HTTP backend
class ApiService {
  static SupabaseClient get _client => Supabase.instance.client;

  // ─── Stored JWT Token & Vendor ID ──────────────────────────────────
  static String? _token;
  static String? _vendorId;
  static String? get token => _token;
  static String? get vendorId => _vendorId;
  static void setToken(String? t) => _token = t;
  static void setVendorId(String? id) => _vendorId = id;

  // ═══════════════════════════════════════════════════════════════════
  //  VENDOR DASHBOARD (Direct Supabase)
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getDashboard(String vendorId) async {
    try {
      final vendor = await _client.from('Vendor').select().eq('id', vendorId).maybeSingle();
      final services = await _client.from('Service').select('id').eq('vendorId', vendorId);
      final projects = await _client.from('Project').select('id').eq('vendorId', vendorId);
      final orders = await _client.from('Order').select('id, status').eq('vendorId', vendorId);
      final customOrders = await _client.from('CustomOrder').select('id, status').eq('vendorId', vendorId);
      final recentOrders = await _client
          .from('Order')
          .select('*, service:Service(title), user:User(name)')
          .eq('vendorId', vendorId)
          .order('date', ascending: false)
          .limit(5);
      final recentTxns = await _client
          .from('Transaction')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false)
          .limit(5);

      final orderList = orders as List;
      final customList = customOrders as List;
      final activeOrders = orderList.where((o) => o['status'] == 'Active' || o['status'] == 'Pending').length;
      final completedOrders = orderList.where((o) => o['status'] == 'Completed').length;
      final pendingCustom = customList.where((o) => o['status'] == 'Pending Review').length;

      return {
        'stats': {
          'totalOrders': orderList.length,
          'activeOrders': activeOrders,
          'completedOrders': completedOrders,
          'totalServices': (services as List).length,
          'totalProjects': (projects as List).length,
          'pendingCustomOrders': pendingCustom,
          'totalEarnings': vendor?['totalEarnings'] ?? 0,
        },
        'recentOrders': recentOrders,
        'recentTransactions': recentTxns,
      };
    } catch (e) {
      print('Dashboard Error: $e');
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
  }

  static Future<Map<String, dynamic>> getProfile(String vendorId) async {
    final response = await _client.from('Vendor').select().eq('id', vendorId).single();
    return response;
  }

  static Future<Map<String, dynamic>> updateProfile(String vendorId, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Vendor').update(data).eq('id', vendorId).select().single();
    return response;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SERVICES CRUD (Direct Supabase)
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorServices(String vendorId) async {
    try {
      final response = await _client
          .from('Service')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  static String _generateUuid() {
    final random = dart_math.Random();
    return '${random.nextInt(0xffffffff).toRadixString(16).padLeft(8, '0')}-'
        '${random.nextInt(0xffff).toRadixString(16).padLeft(4, '0')}-'
        '4${random.nextInt(0x0fff).toRadixString(16).padLeft(3, '0')}-'
        '8${random.nextInt(0x0fff).toRadixString(16).padLeft(3, '0')}-'
        '${random.nextInt(0xffffffff).toRadixString(16).padLeft(8, '0')}${random.nextInt(0xffff).toRadixString(16).padLeft(4, '0')}';
  }

  static Future<Map<String, dynamic>> createService(Map<String, dynamic> data) async {
    if (_vendorId == null) throw Exception('Vendor Session Expired. Please login again.');
    data['id'] = _generateUuid();
    data['vendorId'] = _vendorId;
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Service').insert(data).select().single();
    return response;
  }

  static Future<Map<String, dynamic>> updateService(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Service').update(data).eq('id', id).select().single();
    return response;
  }

  static Future<void> deleteService(String id) async {
    await _client.from('Service').delete().eq('id', id);
  }

  // ═══════════════════════════════════════════════════════════════════
  //  PROJECTS CRUD (Direct Supabase)
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorProjects(String vendorId) async {
    try {
      final response = await _client
          .from('Project')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> createProject(Map<String, dynamic> data) async {
    if (_vendorId == null) throw Exception('Vendor Session Expired. Please login again.');
    data['id'] = _generateUuid();
    data['vendorId'] = _vendorId;
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Project').insert(data).select().single();
    return response;
  }

  static Future<Map<String, dynamic>> updateProject(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Project').update(data).eq('id', id).select().single();
    return response;
  }

  static Future<void> deleteProject(String id) async {
    await _client.from('Project').delete().eq('id', id);
  }

  // ═══════════════════════════════════════════════════════════════════
  //  HACKATHONS CRUD (Direct Supabase)
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorHackathons(String vendorId) async {
    try {
      final response = await _client
          .from('Hackathon')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> createHackathon(Map<String, dynamic> data) async {
    if (_vendorId == null) throw Exception('Vendor Session Expired. Please login again.');
    data['id'] = _generateUuid();
    data['vendorId'] = _vendorId;
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Hackathon').insert(data).select().single();
    return response;
  }

  static Future<Map<String, dynamic>> updateHackathon(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Hackathon').update(data).eq('id', id).select().single();
    return response;
  }

  static Future<void> deleteHackathon(String id) async {
    await _client.from('Hackathon').delete().eq('id', id);
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorOrders(String vendorId, {String? status}) async {
    try {
      var query = _client
          .from('Order')
          .select('*, user:User(name, email), service:Service(title)')
          .eq('vendorId', vendorId);
      if (status != null) query = query.eq('status', status);
      final response = await query.order('date', ascending: false);
      return response;
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    final response = await _client.from('Order').update({'status': status}).eq('id', orderId).select().single();
    return response;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CUSTOM ORDERS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getVendorCustomOrders(String vendorId) async {
    try {
      final response = await _client
          .from('CustomOrder')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> acceptCustomOrder(String orderId, {String? notes, double? price}) async {
    final update = <String, dynamic>{
      'status': 'Accepted',
      'updatedAt': DateTime.now().toIso8601String(),
    };
    if (notes != null) update['vendorNotes'] = notes;
    if (price != null) update['quotedPrice'] = price;
    final response = await _client.from('CustomOrder').update(update).eq('id', orderId).select().single();
    return response;
  }

  static Future<Map<String, dynamic>> rejectCustomOrder(String orderId, {String? notes}) async {
    final response = await _client.from('CustomOrder').update({
      'status': 'Rejected',
      'vendorNotes': notes,
      'updatedAt': DateTime.now().toIso8601String(),
    }).eq('id', orderId).select().single();
    return response;
  }

  // ═══════════════════════════════════════════════════════════════════
  //  EARNINGS
  // ═══════════════════════════════════════════════════════════════════

  static Future<Map<String, dynamic>> getEarnings(String vendorId) async {
    try {
      final vendor = await _client.from('Vendor').select('totalEarnings').eq('id', vendorId).single();
      return {
        'totalEarnings': vendor['totalEarnings'] ?? 0,
        'pendingEarnings': 0,
        'thisMonthEarnings': 0,
      };
    } catch (e) {
      return {'totalEarnings': 0, 'pendingEarnings': 0, 'thisMonthEarnings': 0};
    }
  }

  static Future<List<dynamic>> getTransactions(String vendorId) async {
    try {
      final response = await _client
          .from('Transaction')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return response;
    } catch (e) {
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CATEGORIES
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await _client.from('Category').select().order('sortOrder', ascending: true);
      return response;
    } catch (e) {
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  CHAT (Direct Supabase)
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getChatThreads(String vendorId) async {
    try {
      // Get distinct users who have chatted with this vendor
      final response = await _client
          .from('ChatMessage')
          .select('userId, user:User(name, email)')
          .eq('vendorId', vendorId)
          .order('time', ascending: false);

      // Deduplicate by userId
      final Map<String, Map<String, dynamic>> threads = {};
      for (final msg in response) {
        final uid = msg['userId'] as String;
        if (!threads.containsKey(uid)) {
          threads[uid] = msg;
        }
      }
      return threads.values.toList();
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getChatMessages(String userId) async {
    try {
      final vid = _vendorId ?? '';
      final response = await _client
          .from('ChatMessage')
          .select()
          .eq('userId', userId)
          .eq('vendorId', vid)
          .order('time', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> sendMessage(String userId, String text) async {
    try {
      final vid = _vendorId ?? '';
      final response = await _client.from('ChatMessage').insert({
        'userId': userId,
        'vendorId': vid,
        'text': text,
        'isSender': false,
      }).select().single();
      return response;
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final vid = _vendorId ?? '';
      final response = await _client
          .from('Notification')
          .select()
          .eq('targetId', vid)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  //  BANNERS CRUD (Admin)
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getBanners() async {
    try {
      final response = await _client
          .from('Banner')
          .select()
          .order('sortOrder', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> createBanner(Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Banner').insert(data).select().single();
    return response;
  }

  static Future<Map<String, dynamic>> updateBanner(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Banner').update(data).eq('id', id).select().single();
    return response;
  }

  static Future<void> deleteBanner(String id) async {
    await _client.from('Banner').delete().eq('id', id);
  }

  // ═══════════════════════════════════════════════════════════════════
  //  ADVERTISEMENTS CRUD
  // ═══════════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>> getAdvertisements() async {
    try {
      final vid = _vendorId ?? '';
      final response = await _client
          .from('Advertisement')
          .select()
          .eq('vendorId', vid)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> createAdvertisement(Map<String, dynamic> data) async {
    data['vendorId'] = _vendorId;
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Advertisement').insert(data).select().single();
    return response;
  }

  static Future<Map<String, dynamic>> updateAdvertisement(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Advertisement').update(data).eq('id', id).select().single();
    return response;
  }

  static Future<void> deleteAdvertisement(String id) async {
    await _client.from('Advertisement').delete().eq('id', id);
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
      await _client.storage.from(bucket).uploadBinary(
        path,
        fileBytes,
        fileOptions: FileOptions(contentType: contentType, upsert: true),
      );
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }

  static Future<void> deleteFile(String bucket, String path) async {
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (e) {
      print('Delete file error: $e');
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
  //  LOGOUT (Clear session)
  // ═══════════════════════════════════════════════════════════════════

  static Future<void> logout() async {
    await _client.auth.signOut();
    _token = null;
    _vendorId = null;
  }
}

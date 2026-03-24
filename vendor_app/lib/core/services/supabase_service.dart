import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class SupabaseService {
  static const String supabaseUrl = 'https://pweuldjxqksffmaednjc.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3ZXVsZGp4cWtzZmZtYWVkbmpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzEzNDQxOTEsImV4cCI6MjA4NjkyMDE5MX0.XfbOsCjE1F_kepW3PISSVI5PhCkjB_JyOs3VNI3ry8c';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}

// ─── Vendor Repository Layer ──────────────────────────────────────

class VendorProjectRepository {
  final SupabaseClient _client;
  VendorProjectRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchProjects(String vendorId) async {
    try {
      final response = await _client
          .from('Project')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('VendorProjectRepository.fetchProjects error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createProject(Map<String, dynamic> data) async {
    final response = await _client.from('Project').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateProject(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Project').update(data).eq('id', id).select().single();
    return response;
  }

  Future<void> deleteProject(String id) async {
    await _client.from('Project').delete().eq('id', id);
  }
}

class VendorServiceRepository {
  final SupabaseClient _client;
  VendorServiceRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchServices(String vendorId) async {
    try {
      final response = await _client
          .from('Service')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('VendorServiceRepository.fetchServices error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createService(Map<String, dynamic> data) async {
    final response = await _client.from('Service').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateService(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Service').update(data).eq('id', id).select().single();
    return response;
  }

  Future<void> deleteService(String id) async {
    await _client.from('Service').delete().eq('id', id);
  }
}

class VendorHackathonRepository {
  final SupabaseClient _client;
  VendorHackathonRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchHackathons(String vendorId) async {
    try {
      final response = await _client
          .from('Hackathon')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('VendorHackathonRepository.fetchHackathons error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createHackathon(Map<String, dynamic> data) async {
    final response = await _client.from('Hackathon').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateHackathon(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Hackathon').update(data).eq('id', id).select().single();
    return response;
  }

  Future<void> deleteHackathon(String id) async {
    await _client.from('Hackathon').delete().eq('id', id);
  }
}

class VendorOrderRepository {
  final SupabaseClient _client;
  VendorOrderRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchOrders(String vendorId, {String? status}) async {
    try {
      var query = _client
          .from('Order')
          .select('*, user:User(name, email), service:Service(title)')
          .eq('vendorId', vendorId);
      if (status != null) query = query.eq('status', status);
      final response = await query.order('date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('VendorOrderRepository.fetchOrders error: $e');
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _client.from('Order').update({'status': status}).eq('id', orderId);
  }
}

class VendorCustomOrderRepository {
  final SupabaseClient _client;
  VendorCustomOrderRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchCustomOrders(String vendorId) async {
    try {
      final response = await _client
          .from('CustomOrder')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('VendorCustomOrderRepository.fetchCustomOrders error: $e');
      return [];
    }
  }

  Future<void> acceptOrder(String orderId, {String? notes, double? price}) async {
    final update = <String, dynamic>{
      'status': 'Accepted',
      'updatedAt': DateTime.now().toIso8601String(),
    };
    if (notes != null) update['vendorNotes'] = notes;
    if (price != null) update['quotedPrice'] = price;
    await _client.from('CustomOrder').update(update).eq('id', orderId);
  }

  Future<void> rejectOrder(String orderId, {String? notes}) async {
    await _client.from('CustomOrder').update({
      'status': 'Rejected',
      'vendorNotes': notes,
      'updatedAt': DateTime.now().toIso8601String(),
    }).eq('id', orderId);
  }
}

class VendorBannerRepository {
  final SupabaseClient _client;
  VendorBannerRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchBanners() async {
    try {
      final response = await _client
          .from('Banner')
          .select()
          .order('sortOrder', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('VendorBannerRepository.fetchBanners error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createBanner(Map<String, dynamic> data) async {
    final response = await _client.from('Banner').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateBanner(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Banner').update(data).eq('id', id).select().single();
    return response;
  }

  Future<void> deleteBanner(String id) async {
    await _client.from('Banner').delete().eq('id', id);
  }
}

class VendorAdvertisementRepository {
  final SupabaseClient _client;
  VendorAdvertisementRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchAds(String vendorId) async {
    try {
      final response = await _client
          .from('Advertisement')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('VendorAdvertisementRepository.fetchAds error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createAd(Map<String, dynamic> data) async {
    final response = await _client.from('Advertisement').insert(data).select().single();
    return response;
  }

  Future<Map<String, dynamic>> updateAd(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().toIso8601String();
    final response = await _client.from('Advertisement').update(data).eq('id', id).select().single();
    return response;
  }

  Future<void> deleteAd(String id) async {
    await _client.from('Advertisement').delete().eq('id', id);
  }
}

class VendorEarningsRepository {
  final SupabaseClient _client;
  VendorEarningsRepository(this._client);

  Future<Map<String, dynamic>> fetchEarnings(String vendorId) async {
    try {
      final vendor = await _client.from('Vendor').select('totalEarnings, totalOrders').eq('id', vendorId).single();
      final transactions = await _client
          .from('Transaction')
          .select()
          .eq('vendorId', vendorId)
          .order('createdAt', ascending: false)
          .limit(20);
      return {
        'totalEarnings': vendor['totalEarnings'] ?? 0,
        'totalOrders': vendor['totalOrders'] ?? 0,
        'transactions': transactions,
      };
    } catch (e) {
      debugPrint('VendorEarningsRepository.fetchEarnings error: $e');
      return {'totalEarnings': 0, 'totalOrders': 0, 'transactions': []};
    }
  }
}

class VendorDashboardRepository {
  final SupabaseClient _client;
  VendorDashboardRepository(this._client);

  Future<Map<String, dynamic>> fetchDashboard(String vendorId) async {
    try {
      final vendor = await _client.from('Vendor').select().eq('id', vendorId).single();
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

      final activeOrders = (orders as List).where((o) => o['status'] == 'Active' || o['status'] == 'Pending').length;
      final completedOrders = (orders).where((o) => o['status'] == 'Completed').length;
      final pendingCustom = (customOrders as List).where((o) => o['status'] == 'Pending Review').length;

      return {
        'stats': {
          'totalOrders': orders.length,
          'activeOrders': activeOrders,
          'completedOrders': completedOrders,
          'totalServices': (services as List).length,
          'totalProjects': (projects as List).length,
          'pendingCustomOrders': pendingCustom,
          'totalEarnings': vendor['totalEarnings'] ?? 0,
        },
        'recentOrders': recentOrders,
        'recentTransactions': recentTxns,
      };
    } catch (e) {
      debugPrint('VendorDashboardRepository.fetchDashboard error: $e');
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
}

// ─── Upload Helper ──────────────────────────────────────────────────

class StorageService {
  final SupabaseClient _client;
  StorageService(this._client);

  /// Upload a file to Supabase Storage and return the public URL
  Future<String?> uploadFile({
    required String bucket,
    required String path,
    required List<int> fileBytes,
    String? contentType,
  }) async {
    try {
      await _client.storage.from(bucket).uploadBinary(
        path,
        fileBytes as dynamic,
        fileOptions: FileOptions(contentType: contentType ?? 'image/jpeg', upsert: true),
      );
      final url = _client.storage.from(bucket).getPublicUrl(path);
      return url;
    } catch (e) {
      debugPrint('StorageService.uploadFile error: $e');
      return null;
    }
  }

  /// Delete a file from Supabase Storage
  Future<void> deleteFile(String bucket, String path) async {
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (e) {
      debugPrint('StorageService.deleteFile error: $e');
    }
  }
}

// ─── Riverpod Providers ────────────────────────────────────────────

final vendorProjectRepoProvider = Provider<VendorProjectRepository>((ref) {
  return VendorProjectRepository(ref.read(supabaseProvider));
});

final vendorServiceRepoProvider = Provider<VendorServiceRepository>((ref) {
  return VendorServiceRepository(ref.read(supabaseProvider));
});

final vendorHackathonRepoProvider = Provider<VendorHackathonRepository>((ref) {
  return VendorHackathonRepository(ref.read(supabaseProvider));
});

final vendorOrderRepoProvider = Provider<VendorOrderRepository>((ref) {
  return VendorOrderRepository(ref.read(supabaseProvider));
});

final vendorCustomOrderRepoProvider = Provider<VendorCustomOrderRepository>((ref) {
  return VendorCustomOrderRepository(ref.read(supabaseProvider));
});

final vendorBannerRepoProvider = Provider<VendorBannerRepository>((ref) {
  return VendorBannerRepository(ref.read(supabaseProvider));
});

final vendorAdRepoProvider = Provider<VendorAdvertisementRepository>((ref) {
  return VendorAdvertisementRepository(ref.read(supabaseProvider));
});

final vendorEarningsRepoProvider = Provider<VendorEarningsRepository>((ref) {
  return VendorEarningsRepository(ref.read(supabaseProvider));
});

final vendorDashboardRepoProvider = Provider<VendorDashboardRepository>((ref) {
  return VendorDashboardRepository(ref.read(supabaseProvider));
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.read(supabaseProvider));
});

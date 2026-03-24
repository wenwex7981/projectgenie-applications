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

// ─── Repository Layer ──────────────────────────────────────────────

class ProjectRepository {
  final SupabaseClient _client;
  ProjectRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchProjects({String? domain}) async {
    try {
      var query = _client.from('Project').select();
      if (domain != null && domain.isNotEmpty && domain != 'All') {
        query = query.ilike('domain', '%$domain%');
      }
      final response = await query.order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ProjectRepository.fetchProjects error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchProjectById(String id) async {
    try {
      final response = await _client
          .from('Project')
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      debugPrint('ProjectRepository.fetchProjectById error: $e');
      return null;
    }
  }
}

class ServiceRepository {
  final SupabaseClient _client;
  ServiceRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchServices({String? category}) async {
    try {
      var query = _client.from('Service').select();
      if (category != null && category.isNotEmpty) {
        query = query.eq('categoryId', category);
      }
      final response = await query.order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ServiceRepository.fetchServices error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchTrendingServices() async {
    try {
      final response = await _client
          .from('Service')
          .select()
          .eq('isTrending', true)
          .eq('isActive', true)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ServiceRepository.fetchTrendingServices error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchFeaturedServices() async {
    try {
      final response = await _client
          .from('Service')
          .select()
          .eq('isFeatured', true)
          .eq('isActive', true)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ServiceRepository.fetchFeaturedServices error: $e');
      return [];
    }
  }
}

class CategoryRepository {
  final SupabaseClient _client;
  CategoryRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await _client
          .from('Category')
          .select()
          .order('sortOrder', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('CategoryRepository.fetchCategories error: $e');
      return [];
    }
  }
}

class BannerRepository {
  final SupabaseClient _client;
  BannerRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchBanners() async {
    try {
      final response = await _client
          .from('Banner')
          .select()
          .eq('isActive', true)
          .order('sortOrder', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('BannerRepository.fetchBanners error: $e');
      return [];
    }
  }
}

class AdvertisementRepository {
  final SupabaseClient _client;
  AdvertisementRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchAds({String placement = 'home'}) async {
    try {
      final response = await _client
          .from('Advertisement')
          .select()
          .eq('isActive', true)
          .eq('placement', placement)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('AdvertisementRepository.fetchAds error: $e');
      return [];
    }
  }
}

class HackathonRepository {
  final SupabaseClient _client;
  HackathonRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchHackathons() async {
    try {
      final response = await _client
          .from('Hackathon')
          .select()
          .eq('isActive', true)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('HackathonRepository.fetchHackathons error: $e');
      return [];
    }
  }
}

class InternshipRepository {
  final SupabaseClient _client;
  InternshipRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchInternships() async {
    try {
      final response = await _client
          .from('Internship')
          .select()
          .eq('isActive', true)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('InternshipRepository.fetchInternships error: $e');
      return [];
    }
  }
}

class OrderRepository {
  final SupabaseClient _client;
  OrderRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
    try {
      final response = await _client
          .from('Order')
          .select('*, service:Service(*), vendor:Vendor(name, businessName)')
          .eq('userId', userId)
          .order('date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('OrderRepository.fetchOrders error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await _client.from('Order').insert(data).select().single();
      return response;
    } catch (e) {
      debugPrint('OrderRepository.createOrder error: $e');
      return null;
    }
  }
}

class CustomOrderRepository {
  final SupabaseClient _client;
  CustomOrderRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchCustomOrders(String userId) async {
    try {
      final response = await _client
          .from('CustomOrder')
          .select()
          .eq('userId', userId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('CustomOrderRepository.fetchCustomOrders error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createCustomOrder(Map<String, dynamic> data) async {
    try {
      final response = await _client.from('CustomOrder').insert(data).select().single();
      return response;
    } catch (e) {
      debugPrint('CustomOrderRepository.createCustomOrder error: $e');
      return null;
    }
  }
}

class ChatRepository {
  final SupabaseClient _client;
  ChatRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchMessages(String userId, String vendorId) async {
    try {
      final response = await _client
          .from('ChatMessage')
          .select()
          .eq('userId', userId)
          .eq('vendorId', vendorId)
          .order('time', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ChatRepository.fetchMessages error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> sendMessage(Map<String, dynamic> data) async {
    try {
      final response = await _client.from('ChatMessage').insert(data).select().single();
      return response;
    } catch (e) {
      debugPrint('ChatRepository.sendMessage error: $e');
      return null;
    }
  }
}

class NotificationRepository {
  final SupabaseClient _client;
  NotificationRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchNotifications(String targetId) async {
    try {
      final response = await _client
          .from('Notification')
          .select()
          .eq('targetId', targetId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('NotificationRepository.fetchNotifications error: $e');
      return [];
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _client.from('Notification').update({'isRead': true}).eq('id', id);
    } catch (e) {
      debugPrint('NotificationRepository.markAsRead error: $e');
    }
  }
}

class CartRepository {
  final SupabaseClient _client;
  CartRepository(this._client);

  Future<List<Map<String, dynamic>>> fetchCartItems(String userId) async {
    try {
      final response = await _client
          .from('CartItem')
          .select('*, service:Service(*), project:Project(*)')
          .eq('userId', userId)
          .order('createdAt', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('CartRepository.fetchCartItems error: $e');
      return [];
    }
  }

  Future<void> addToCart(Map<String, dynamic> data) async {
    try {
      await _client.from('CartItem').insert(data);
    } catch (e) {
      debugPrint('CartRepository.addToCart error: $e');
    }
  }

  Future<void> removeFromCart(String id) async {
    try {
      await _client.from('CartItem').delete().eq('id', id);
    } catch (e) {
      debugPrint('CartRepository.removeFromCart error: $e');
    }
  }
}

// ─── Search Repository ──────────────────────────────────────────────

class SearchRepository {
  final SupabaseClient _client;
  SearchRepository(this._client);

  Future<Map<String, List<Map<String, dynamic>>>> search(String query) async {
    try {
      final projects = await _client
          .from('Project')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%,domain.ilike.%$query%')
          .limit(20);
      final services = await _client
          .from('Service')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .limit(20);
      return {
        'projects': List<Map<String, dynamic>>.from(projects),
        'services': List<Map<String, dynamic>>.from(services),
      };
    } catch (e) {
      debugPrint('SearchRepository.search error: $e');
      return {'projects': [], 'services': []};
    }
  }
}

// ─── Riverpod Providers for Repositories ───────────────────────────

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(ref.read(supabaseProvider));
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(ref.read(supabaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.read(supabaseProvider));
});

final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  return BannerRepository(ref.read(supabaseProvider));
});

final advertisementRepositoryProvider = Provider<AdvertisementRepository>((ref) {
  return AdvertisementRepository(ref.read(supabaseProvider));
});

final hackathonRepositoryProvider = Provider<HackathonRepository>((ref) {
  return HackathonRepository(ref.read(supabaseProvider));
});

final internshipRepositoryProvider = Provider<InternshipRepository>((ref) {
  return InternshipRepository(ref.read(supabaseProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.read(supabaseProvider));
});

final customOrderRepositoryProvider = Provider<CustomOrderRepository>((ref) {
  return CustomOrderRepository(ref.read(supabaseProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.read(supabaseProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.read(supabaseProvider));
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.read(supabaseProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.read(supabaseProvider));
});

// ─── Data Providers (FutureProviders) ──────────────────────────────

final bannersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(bannerRepositoryProvider).fetchBanners();
});

final advertisementsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, placement) async {
  return ref.read(advertisementRepositoryProvider).fetchAds(placement: placement);
});

final hackathonsDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(hackathonRepositoryProvider).fetchHackathons();
});

final internshipsDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(internshipRepositoryProvider).fetchInternships();
});

final categoriesDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(categoryRepositoryProvider).fetchCategories();
});

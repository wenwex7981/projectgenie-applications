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

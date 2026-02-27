import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/models/models.dart';

// ─── Selected Domain Filter ────────────────────────────────────────
final selectedDomainProvider = StateProvider<String>((ref) => 'All');

// ─── Search Query ──────────────────────────────────────────────────
final projectSearchQueryProvider = StateProvider<String>((ref) => '');

// ─── Projects Provider (Supabase + Fallback) ───────────────────────
final projectsProvider = FutureProvider.family<List<ProjectModel>, String>((ref, domain) async {
  final supabase = ref.read(supabaseProvider);
  try {
    var query = supabase.from('Project').select();
    
    if (domain.isNotEmpty && domain != 'All') {
      query = query.ilike('domain', '%$domain%');
    }
    
    final response = await query.order('createdAt', ascending: false);
    
    if ((response as List).isNotEmpty) {
      return response.map((data) => ProjectModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('Supabase projects fetch error: $e');
  }
  
  // Fallback to local data
  if (domain.isEmpty || domain == 'All') {
    return MockData.finalYearProjects;
  }
  return MockData.finalYearProjects
      .where((p) => p.domain.toUpperCase().contains(domain.toUpperCase()))
      .toList();
});

// ─── All Projects (no filter) ──────────────────────────────────────
final allProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  try {
    final response = await supabase
        .from('Project')
        .select()
        .order('createdAt', ascending: false);
    
    if ((response as List).isNotEmpty) {
      return response.map((data) => ProjectModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('Supabase all projects fetch error: $e');
  }
  return MockData.finalYearProjects;
});

// ─── Featured Projects ─────────────────────────────────────────────
final featuredProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  try {
    final response = await supabase
        .from('Project')
        .select()
        .eq('isFeatured', true)
        .order('rating', ascending: false)
        .limit(5);
    
    if ((response as List).isNotEmpty) {
      return response.map((data) => ProjectModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('Supabase featured projects error: $e');
  }
  return MockData.finalYearProjects.where((p) => p.isFeatured).toList();
});

// ─── Services Provider ─────────────────────────────────────────────
final servicesProvider = FutureProvider.family<List<ServiceModel>, String>((ref, category) async {
  final supabase = ref.read(supabaseProvider);
  try {
    var query = supabase.from('Service').select();
    if (category.isNotEmpty) {
      query = query.eq('categoryId', category); // category relation usually requires ID directly from DB if un-joined
    }
    final response = await query.order('createdAt', ascending: false);
    
    if ((response as List).isNotEmpty) {
      return response.map((data) => ServiceModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('Supabase services fetch error: $e');
  }
  
  // Fallback based on category
  switch (category) {
    case 'Resume':
      return MockData.resumeTemplates;
    case 'Resume Writing':
      return MockData.resumeWritingServices;
    case 'Research Paper':
      return MockData.researchPaperServices;
    case 'Projects':
      return MockData.generalProjects;
    default:
      return [...MockData.trendingServices, ...MockData.generalProjects];
  }
});

// ─── Trending Services ─────────────────────────────────────────────
final trendingServicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  try {
    final response = await supabase
        .from('Service')
        .select()
        .eq('isTrending', true)
        .order('rating', ascending: false)
        .limit(5);
    
    if ((response as List).isNotEmpty) {
      return response.map((data) => ServiceModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('Supabase trending services error: $e');
  }
  return MockData.trendingServices;
});

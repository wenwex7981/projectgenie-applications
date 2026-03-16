import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/models/models.dart';

// ─── Selected Domain Filter ────────────────────────────────────────
final selectedDomainProvider = StateProvider<String>((ref) => 'All');

// ─── Search Query ──────────────────────────────────────────────────
final projectSearchQueryProvider = StateProvider<String>((ref) => '');

// ─── Projects Provider (REST API + Fallback) ───────────────────────
final projectsProvider = FutureProvider.family<List<ProjectModel>, String>((ref, domain) async {
  try {
    final response = await ApiService.getProjects(domain: domain.isNotEmpty && domain != 'All' ? domain : null);
    if (response.isNotEmpty) {
      return response.map((data) => ProjectModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('API projects fetch error: $e');
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
  try {
    final response = await ApiService.getProjects();
    if (response.isNotEmpty) {
      return response.map((data) => ProjectModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('API all projects fetch error: $e');
  }
  return MockData.finalYearProjects;
});

// ─── Featured Projects ─────────────────────────────────────────────
final featuredProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  try {
    final response = await ApiService.getFeaturedProjects();
    if (response.isNotEmpty) {
      return response.map((data) => ProjectModel.fromJson(data)).toList();
    }
  } catch (e) {
    debugPrint('API featured projects error: $e');
  }
  return MockData.finalYearProjects.where((p) => p.isFeatured).toList();
});

// ─── Services Provider ─────────────────────────────────────────────
final servicesProvider = FutureProvider.family<List<ServiceModel>, String>((ref, category) async {
  try {
    final services = await ApiService.getServices(category: category.isNotEmpty ? category : null);
    if (services.isNotEmpty) {
      return services;
    }
  } catch (e) {
    debugPrint('API services fetch error: $e');
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
  try {
    final services = await ApiService.getTrendingServices();
    if (services.isNotEmpty) {
      return services;
    }
  } catch (e) {
    debugPrint('API trending services error: $e');
  }
  return MockData.trendingServices;
});

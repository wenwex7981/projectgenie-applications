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
    // Try to get featured projects explicitly
    List<ProjectModel> response = [];
    final jsonResponse = await ApiService.getFeaturedProjects();
    if (jsonResponse.isNotEmpty) {
      response = jsonResponse.map((data) => ProjectModel.fromJson(data)).toList();
    }
    
    // If no featured projects, just get the latest projects from API
    if (response.isEmpty) {
      final allResponse = await ApiService.getProjects();
      if (allResponse.isNotEmpty) {
        response = allResponse.map((data) => ProjectModel.fromJson(data)).toList();
      }
    }
    
    if (response.isNotEmpty) return response;
  } catch (e) {
    debugPrint('API featured projects error: $e');
  }
  return MockData.finalYearProjects.where((p) => p.isFeatured).toList();
});

// ─── Services Provider ─────────────────────────────────────────────
final servicesProvider = FutureProvider.family<List<ServiceModel>, String>((ref, category) async {
  try {
    final services = await ApiService.getServices(category: category.isNotEmpty && category != 'All' ? category : null);
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
    // Try to get trending services explicitly
    List<ServiceModel> services = await ApiService.getTrendingServices();
    
    // If no trending services, just get the latest services from API
    if (services.isEmpty) {
       services = await ApiService.getServices();
    }
    
    if (services.isNotEmpty) return services;
  } catch (e) {
    debugPrint('API trending services error: $e');
  }
  return MockData.trendingServices;
});

// ─── Hackathons Provider ───────────────────────────────────────────
final hackathonsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final response = await ApiService.getHackathons();
    if (response.isNotEmpty) return response;
  } catch (e) {
    debugPrint('API hackathons error: $e');
  }
  return [];
});



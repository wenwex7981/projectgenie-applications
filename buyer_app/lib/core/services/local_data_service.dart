import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../services/api_service.dart';

// ─── LOCAL DATA SERVICE ─────────────────────────────────────────────
// Enterprise-grade data service with complete offline support.
// All data is served locally — no external image URLs, no Supabase.

class LocalDataService {
  // ─── Projects ─────────────────────────────────────────────────────
  List<ProjectModel> getAllProjects() => MockData.finalYearProjects;
  List<ProjectModel> getFeaturedProjects() =>
      MockData.finalYearProjects.where((p) => p.isFeatured).toList();
  List<ProjectModel> getProjectsByDomain(String domain) =>
      domain == 'all' || domain.isEmpty
          ? MockData.finalYearProjects
          : MockData.finalYearProjects
              .where((p) => p.domain.toLowerCase().contains(domain.toLowerCase()))
              .toList();

  // ─── Services ─────────────────────────────────────────────────────
  List<ServiceModel> getTrendingServices() => MockData.trendingServices;
  List<ServiceModel> getResumeTemplates() => MockData.resumeTemplates;
  List<ServiceModel> getResumeWritingServices() => MockData.resumeWritingServices;
  List<ServiceModel> getResearchPaperServices() => MockData.researchPaperServices;
  List<ServiceModel> getGeneralProjects() => MockData.generalProjects;
  List<ServiceModel> getAllServices() => [
        ...MockData.trendingServices,
        ...MockData.resumeTemplates,
        ...MockData.resumeWritingServices,
        ...MockData.researchPaperServices,
        ...MockData.generalProjects,
      ];

  // ─── Orders ───────────────────────────────────────────────────────
  List<OrderModel> getOrders() => MockData.orders;

  // ─── Chat ─────────────────────────────────────────────────────────
  List<ChatThread> getChatThreads() => MockData.chatThreads;
  List<ChatMessage> getChatMessages() => MockData.chatMessages;

  // ─── Custom Project Orders ────────────────────────────────────────
  static final List<CustomProjectOrder> _customOrders = [];

  List<CustomProjectOrder> getCustomOrders() => List.unmodifiable(_customOrders);

  void submitCustomOrder(CustomProjectOrder order) {
    _customOrders.add(order);
  }
}

// ─── Custom Project Order Model ─────────────────────────────────────
class CustomProjectOrder {
  final String id;
  final String title;
  final String studentName;
  final String collegeName;
  final String branch;
  final String semester;
  final String domain;
  final String abstractText;
  final String requirements;
  final String budget;
  final String deadline;
  final String contactEmail;
  final String contactPhone;
  final List<String> documentPaths;
  final List<String> pptPaths;
  final String status;
  final DateTime createdAt;

  const CustomProjectOrder({
    required this.id,
    required this.title,
    required this.studentName,
    required this.collegeName,
    required this.branch,
    required this.semester,
    required this.domain,
    required this.abstractText,
    required this.requirements,
    required this.budget,
    required this.deadline,
    required this.contactEmail,
    required this.contactPhone,
    this.documentPaths = const [],
    this.pptPaths = const [],
    this.status = 'Pending Review',
    required this.createdAt,
  });
}

// ─── Providers ──────────────────────────────────────────────────────
final localDataServiceProvider = Provider<LocalDataService>((ref) => LocalDataService());

final allProjectsProvider = Provider<List<ProjectModel>>((ref) {
  return ref.read(localDataServiceProvider).getAllProjects();
});

final featuredProjectsProvider = Provider<List<ProjectModel>>((ref) {
  return ref.read(localDataServiceProvider).getFeaturedProjects();
});

final trendingServicesProvider = Provider<List<ServiceModel>>((ref) {
  return ref.read(localDataServiceProvider).getTrendingServices();
});

final allServicesProvider = Provider<List<ServiceModel>>((ref) {
  return ref.read(localDataServiceProvider).getAllServices();
});

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  try {
    final apiOrders = await ApiService.getOrders();
    if (apiOrders.isNotEmpty) return apiOrders;
  } catch (_) {}
  return ref.read(localDataServiceProvider).getOrders();
});

final customOrdersProvider = StateNotifierProvider<CustomOrdersNotifier, List<CustomProjectOrder>>((ref) {
  return CustomOrdersNotifier(ref.read(localDataServiceProvider));
});

class CustomOrdersNotifier extends StateNotifier<List<CustomProjectOrder>> {
  final LocalDataService _service;
  CustomOrdersNotifier(this._service) : super(_service.getCustomOrders());

  void submit(CustomProjectOrder order) {
    _service.submitCustomOrder(order);
    state = _service.getCustomOrders();
  }
}

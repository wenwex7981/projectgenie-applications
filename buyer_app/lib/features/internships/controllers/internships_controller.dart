import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';

class InternshipModel {
  final String id;
  final String role;
  final String company;
  final String duration;
  final String stipend;
  final String type;
  final String location;
  final String logo;
  final List<String> tags;

  const InternshipModel({
    required this.id,
    required this.role,
    required this.company,
    required this.duration,
    required this.stipend,
    required this.type,
    required this.location,
    required this.logo,
    this.tags = const [],
  });
}

final internshipsProvider = FutureProvider<List<InternshipModel>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  try {
    final response = await supabase
        .from('internships')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((data) => InternshipModel(
      id: data['id'].toString(),
      role: data['role'] ?? '',
      company: data['company'] ?? '',
      duration: data['duration'] ?? '',
      stipend: data['stipend'] ?? '',
      type: data['type'] ?? '',
      location: data['location'] ?? '',
      logo: data['logo_url'] ?? 'https://via.placeholder.com/50',
      tags: List<String>.from(data['tags'] ?? []),
    )).toList();
  } catch (e) {
    debugPrint('Error fetching internships: $e');
    return [
      const InternshipModel(id: 'i1', role: 'Flutter Developer Intern', company: 'TechCorp', duration: '3 months', stipend: '₹15,000/mo', type: 'Remote', location: 'Bangalore', logo: '', tags: ['Flutter', 'Dart', 'Firebase']),
      const InternshipModel(id: 'i2', role: 'ML Research Intern', company: 'AI Labs', duration: '6 months', stipend: '₹20,000/mo', type: 'Hybrid', location: 'Hyderabad', logo: '', tags: ['Python', 'TensorFlow', 'NLP']),
      const InternshipModel(id: 'i3', role: 'Backend Engineer Intern', company: 'StartupXYZ', duration: '3 months', stipend: '₹12,000/mo', type: 'Remote', location: 'Mumbai', logo: '', tags: ['Node.js', 'MongoDB', 'REST API']),
    ];
  }
});

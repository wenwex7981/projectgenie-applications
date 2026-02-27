import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/models/models.dart';

// Home Screen Services (Grid)
final homeServicesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  try {
    final response = await supabase
        .from('Service')
        .select()
        .order('createdAt', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    debugPrint('Error fetching home services: $e');
    return [
      {
        'title': 'Record Writing',
        'desc': 'Professional lab manuals & reports',
        'icon': 'edit_note_rounded',
      },
      {
        'title': 'Resume Writing',
        'desc': 'ATS optimized academic CVs',
        'icon': 'description_rounded',
      },
      {
        'title': 'Lab Manuals',
        'desc': 'Custom solutions for all branches',
        'icon': 'science_rounded',
      },
      {
        'title': 'Tech Mentorship',
        'desc': '1-on-1 expert project support',
        'icon': 'psychology_rounded',
      },
    ];
  }
});

// Career Services (List) — now returns ServiceModel
final careerServicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final supabase = ref.read(supabaseProvider);
  try {
    final response = await supabase
        .from('Service')
        .select()
        .order('createdAt', ascending: false);
    
    return (response as List).map((data) => ServiceModel.fromJson(data)).toList();
  } catch (e) {
    debugPrint('Error fetching career services: $e');
    return MockData.resumeWritingServices;
  }
});

IconData getIconData(String iconName) {
  switch (iconName) {
    case 'edit_note_rounded':
      return Icons.edit_note_rounded;
    case 'description_rounded':
      return Icons.description_rounded;
    case 'science_rounded':
      return Icons.science_rounded;
    case 'psychology_rounded':
      return Icons.psychology_rounded;
    case 'video_call_rounded':
      return Icons.video_call_rounded;
    case 'person_search_rounded':
      return Icons.person_search_rounded;
    default:
      return Icons.category_rounded;
  }
}

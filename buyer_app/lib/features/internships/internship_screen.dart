import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/models/models.dart';
import '../../core/services/api_service.dart';
import '../../core/widgets/service_card.dart';
import '../services/service_detail_screen.dart';

class InternshipScreen extends StatefulWidget {
  const InternshipScreen({super.key});

  @override
  State<InternshipScreen> createState() => _InternshipScreenState();
}

class _InternshipScreenState extends State<InternshipScreen> {
  bool _isLoading = true;
  List<ServiceModel> _internships = [];

  @override
  void initState() {
    super.initState();
    _loadInternships();
  }

  Future<void> _loadInternships() async {
    try {
      final services = await ApiService.getServices(category: 'Internships');
      if (mounted) {
        setState(() {
          _internships = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading internships: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Internships 🎓', style: AppTypography.headingMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _internships.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_rounded, size: 64, color: AppColors.textTertiary),
                      const SizedBox(height: 16),
                      Text('No internships available yet.', style: AppTypography.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _internships.length,
                  itemBuilder: (context, index) {
                    final internship = _internships[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ServiceCard(
                        service: internship,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailScreen(service: internship),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

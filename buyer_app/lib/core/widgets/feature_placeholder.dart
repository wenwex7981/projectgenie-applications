import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FeaturePlaceholder extends StatelessWidget {
  final String title;
  
  const FeaturePlaceholder({super.key, required this.title});

  static void show(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.construction_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text('$featureName is coming soon!', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: AppColors.primary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              '$title\nComing Soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: AppColors.textSecondary
              ),
            ),
          ],
        ),
      ),
    );
  }
}

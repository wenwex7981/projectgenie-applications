import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DegreeFilterChips extends StatefulWidget {
  const DegreeFilterChips({super.key});

  @override
  State<DegreeFilterChips> createState() => _DegreeFilterChipsState();
}

class _DegreeFilterChipsState extends State<DegreeFilterChips> {
  final List<String> _degrees = ['BTech', 'MTech', 'BCA', 'MCA', 'Degree'];
  String _selectedDegree = 'BTech';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _degrees.length,
        itemBuilder: (context, index) {
          final degree = _degrees[index];
          final isSelected = _selectedDegree == degree;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedDegree = degree),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: isSelected ? Colors.transparent : AppColors.border),
                  boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  degree,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

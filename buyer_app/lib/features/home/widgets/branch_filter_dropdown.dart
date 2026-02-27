import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class BranchFilterDropdown extends StatefulWidget {
  const BranchFilterDropdown({super.key});

  @override
  State<BranchFilterDropdown> createState() => _BranchFilterDropdownState();
}

class _BranchFilterDropdownState extends State<BranchFilterDropdown> {
  String _selectedBranch = 'CSE';
  final List<String> _branches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'IT', 'AI/ML'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBranch,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
          hint: const Text("Select Branch"),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) setState(() => _selectedBranch = newValue);
          },
          items: _branches.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../auth/buyer_login_screen.dart';

/// Project Requirement Form — Users can fill in detailed requirements
/// for custom project needs. This inserts into CustomOrder table.
class ProjectRequirementFormScreen extends StatefulWidget {
  const ProjectRequirementFormScreen({super.key});

  @override
  State<ProjectRequirementFormScreen> createState() => _ProjectRequirementFormScreenState();
}

class _ProjectRequirementFormScreenState extends State<ProjectRequirementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _submitted = false;

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _deadlineCtrl = TextEditingController();
  final _contactEmailCtrl = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();
  final _requirementsCtrl = TextEditingController();
  final _techStackCtrl = TextEditingController();
  final _studentNameCtrl = TextEditingController();
  final _collegeCtrl = TextEditingController();

  String _selectedDomain = 'AI/ML';
  String _selectedBranch = 'Computer Science';
  String _selectedSemester = '7th';
  String _selectedProjectType = 'Final Year Project';
  String _selectedUrgency = 'Normal';

  final domains = ['AI/ML', 'CSE', 'IoT', 'Data Science', 'Cyber Security', 'EEE', 'ECE', 'Mechanical', 'Blockchain', 'Web Development', 'Mobile App', 'Other'];
  final branches = ['Computer Science', 'AI & Data Science', 'Electronics & Communication', 'Electrical Engineering', 'Mechanical Engineering', 'Information Technology', 'Other'];
  final semesters = ['3rd', '4th', '5th', '6th', '7th', '8th'];
  final projectTypes = ['Final Year Project', 'Mini Project', 'Research Paper', 'Internship Project', 'Hackathon Project', 'Assignment', 'Other'];
  final urgencies = ['Normal', 'Urgent', 'Very Urgent'];

  @override
  void initState() {
    super.initState();
    final user = BuyerLoginScreen.loggedInUser;
    if (user != null) {
      _studentNameCtrl.text = user['name'] ?? '';
      _contactEmailCtrl.text = user['email'] ?? '';
      _contactPhoneCtrl.text = user['phone'] ?? '';
      _collegeCtrl.text = user['college'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Project Requirement', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: _submitted ? _buildSuccessState() : _buildForm(),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.check_circle_rounded, size: 48, color: AppColors.success),
            ),
            const SizedBox(height: 24),
            Text('Requirement Submitted!', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('Our vendors will review your request and get back to you within 24 hours.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Back to Home', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📋 Tell Us What You Need', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Fill in your project requirements and our expert vendors will help you.',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Project Details Section
            _sectionTitle('Project Details'),
            const SizedBox(height: 12),

            _buildTextFormField('Project Title *', _titleCtrl, 'e.g., AI-Based Attendance System', Icons.title_rounded, required: true),
            const SizedBox(height: 14),

            Row(children: [
              Expanded(child: _buildDropdown('Domain *', _selectedDomain, domains, (v) => setState(() => _selectedDomain = v!))),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('Project Type', _selectedProjectType, projectTypes, (v) => setState(() => _selectedProjectType = v!))),
            ]),
            const SizedBox(height: 14),

            _buildTextFormField('Description & Requirements *', _descriptionCtrl,
              'Describe your project in detail — what it should do, features needed, etc.',
              Icons.description_rounded, maxLines: 5, required: true),
            const SizedBox(height: 14),

            _buildTextFormField('Preferred Tech Stack', _techStackCtrl,
              'e.g., Python, TensorFlow, React, Node.js',
              Icons.code_rounded),
            const SizedBox(height: 14),

            _buildTextFormField('Additional Requirements', _requirementsCtrl,
              'Any specific modules, features, or things to include',
              Icons.list_alt_rounded, maxLines: 3),
            const SizedBox(height: 24),

            // Student Info Section
            _sectionTitle('Your Information'),
            const SizedBox(height: 12),

            _buildTextFormField('Student Name *', _studentNameCtrl, 'Your full name', Icons.person_rounded, required: true),
            const SizedBox(height: 14),

            Row(children: [
              Expanded(child: _buildTextFormField('College', _collegeCtrl, 'JNTU, VIT, etc.', Icons.school_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('Branch', _selectedBranch, branches, (v) => setState(() => _selectedBranch = v!))),
            ]),
            const SizedBox(height: 14),

            Row(children: [
              Expanded(child: _buildDropdown('Semester', _selectedSemester, semesters, (v) => setState(() => _selectedSemester = v!))),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('Urgency', _selectedUrgency, urgencies, (v) => setState(() => _selectedUrgency = v!))),
            ]),
            const SizedBox(height: 24),

            // Contact & Budget Section
            _sectionTitle('Contact & Budget'),
            const SizedBox(height: 12),

            _buildTextFormField('Email *', _contactEmailCtrl, 'your@email.com', Icons.email_rounded, required: true, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 14),

            _buildTextFormField('Phone *', _contactPhoneCtrl, '+91 98765 43210', Icons.phone_rounded, required: true, keyboardType: TextInputType.phone),
            const SizedBox(height: 14),

            Row(children: [
              Expanded(child: _buildTextFormField('Budget (₹)', _budgetCtrl, 'e.g., 5000', Icons.currency_rupee_rounded, keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextFormField('Deadline', _deadlineCtrl, 'e.g., 15 Apr 2026', Icons.calendar_today_rounded)),
            ]),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                    : Text('Submit Requirement', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 0.5));
  }

  Widget _buildTextFormField(String label, TextEditingController ctrl, String hint, IconData icon,
    {bool required = false, int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 14),
          validator: required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary),
            prefixIcon: maxLines == 1 ? Icon(icon, size: 18, color: AppColors.textTertiary) : null,
            filled: true, fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              border: InputBorder.none,
            ),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter(fontSize: 13)))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = BuyerLoginScreen.loggedInUser?['id'];
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    setState(() => _loading = true);

    try {
      await Supabase.instance.client.from('CustomOrder').insert({
        'title': _titleCtrl.text,
        'studentName': _studentNameCtrl.text,
        'collegeName': _collegeCtrl.text,
        'branch': _selectedBranch,
        'semester': _selectedSemester,
        'domain': _selectedDomain,
        'abstractText': _descriptionCtrl.text,
        'requirements': _requirementsCtrl.text,
        'budget': _budgetCtrl.text,
        'deadline': _deadlineCtrl.text,
        'contactEmail': _contactEmailCtrl.text,
        'contactPhone': _contactPhoneCtrl.text,
        'projectType': _selectedProjectType,
        'preferredTechStack': _techStackCtrl.text,
        'urgency': _selectedUrgency,
        'userId': userId,
        'status': 'Pending Review',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Create notification for vendors
      await Supabase.instance.client.from('Notification').insert({
        'title': '📋 New Project Requirement',
        'message': '${_studentNameCtrl.text} submitted a ${_selectedProjectType} requirement: ${_titleCtrl.text}',
        'type': 'custom_order',
        'targetId': 'all_vendors', // Vendors can query for this
      });

      setState(() { _submitted = true; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

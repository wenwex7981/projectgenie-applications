import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/local_data_service.dart';

class CustomProjectOrderScreen extends ConsumerStatefulWidget {
  const CustomProjectOrderScreen({super.key});

  @override
  ConsumerState<CustomProjectOrderScreen> createState() => _CustomProjectOrderScreenState();
}

class _CustomProjectOrderScreenState extends ConsumerState<CustomProjectOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Form Controllers
  final _titleController = TextEditingController();
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _branchController = TextEditingController();
  final _semesterController = TextEditingController();
  final _abstractController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedDomain = 'AI/ML';
  final List<String> _uploadedDocs = [];
  final List<String> _uploadedPpts = [];
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  final _domains = [
    'AI/ML', 'Computer Science', 'IoT', 'Data Science',
    'Electrical Engineering', 'Electronics & Comm.', 'Cyber Security',
    'Mechanical / Robotics', 'Blockchain', 'Web Development', 'Mobile App', 'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _collegeController.dispose();
    _branchController.dispose();
    _semesterController.dispose();
    _abstractController.dispose();
    _requirementsController.dispose();
    _budgetController.dispose();
    _deadlineController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) return _buildSuccessScreen();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Custom Project Order', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Text('Step ${_currentStep + 1} of 4', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Step Indicator
            _buildStepIndicator(),
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: _buildCurrentStep(),
              ),
            ),
            // Bottom Buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Project Info', 'Student Details', 'Documents', 'Review'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i <= _currentStep;
          final isCurrent = i == _currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: AppColors.primary, width: 2) : null,
                    boxShadow: isCurrent ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8)] : null,
                  ),
                  child: Center(
                    child: isActive && !isCurrent
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text('${i + 1}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: isActive ? Colors.white : AppColors.textTertiary)),
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(height: 2, color: isActive ? AppColors.primary : AppColors.border),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildProjectInfoStep();
      case 1: return _buildStudentDetailsStep();
      case 2: return _buildDocumentsStep();
      case 3: return _buildReviewStep();
      default: return const SizedBox();
    }
  }

  // ─── Step 1: Project Information ──────────────────────────────────
  Widget _buildProjectInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Project Information', 'Tell us about the project you need built.', Icons.lightbulb_rounded),
        const SizedBox(height: 24),
        _buildTextField('Project Title *', 'e.g. AI-Powered Plant Disease Detection System', _titleController, validator: _requiredValidator, maxLines: 1),
        const SizedBox(height: 20),
        _buildDomainSelector(),
        const SizedBox(height: 20),
        _buildTextField('Project Abstract *', 'Describe your project in detail — objectives, methodology, expected outcomes...', _abstractController, validator: _requiredValidator, maxLines: 6),
        const SizedBox(height: 20),
        _buildTextField('Specific Requirements', 'Any specific tech stack, features, or deliverables you need', _requirementsController, maxLines: 4),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTextField('Budget (₹)', 'e.g. 5000', _budgetController, keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Deadline', 'e.g. 15 Mar 2026', _deadlineController)),
          ],
        ),
      ],
    );
  }

  // ─── Step 2: Student Details ──────────────────────────────────────
  Widget _buildStudentDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Student Details', 'Your academic information for project customization.', Icons.school_rounded),
        const SizedBox(height: 24),
        _buildTextField('Full Name *', 'Enter your full name', _nameController, validator: _requiredValidator),
        const SizedBox(height: 20),
        _buildTextField('College / University Name *', 'e.g. JNTU Hyderabad', _collegeController, validator: _requiredValidator),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTextField('Branch *', 'e.g. CSE, ECE', _branchController, validator: _requiredValidator)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Semester', 'e.g. 7th', _semesterController)),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField('Email *', 'student@university.edu', _emailController, validator: _emailValidator, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildTextField('Phone Number *', '+91 9876543210', _phoneController, validator: _phoneValidator, keyboardType: TextInputType.phone),
      ],
    );
  }

  // ─── Step 3: Documents ────────────────────────────────────────────
  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Documents & Files', 'Upload supporting documents for your project.', Icons.upload_file_rounded),
        const SizedBox(height: 24),

        // Document Upload
        _buildUploadSection(
          title: 'Project Documents',
          subtitle: 'Upload synopsis, reference papers, or any supporting documents (PDF, DOC, DOCX)',
          icon: Icons.description_rounded,
          color: const Color(0xFF3B82F6),
          files: _uploadedDocs,
          onUpload: () => _simulateUpload(_uploadedDocs, 'Document'),
        ),
        const SizedBox(height: 24),

        // PPT Upload
        _buildUploadSection(
          title: 'Presentation (PPT)',
          subtitle: 'Upload any existing presentation slides (PPT, PPTX)',
          icon: Icons.slideshow_rounded,
          color: const Color(0xFF8B5CF6),
          files: _uploadedPpts,
          onUpload: () => _simulateUpload(_uploadedPpts, 'Presentation'),
        ),
        const SizedBox(height: 24),

        // Info Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_rounded, color: Color(0xFFD97706), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Note', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFD97706))),
                    const SizedBox(height: 4),
                    Text(
                      'Documents are optional but help our experts understand your requirements better. You can upload more documents later via chat.',
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF92400E), height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Step 4: Review ───────────────────────────────────────────────
  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Review & Submit', 'Review your order details before submitting.', Icons.fact_check_rounded),
        const SizedBox(height: 24),

        // Project Summary Card
        _buildReviewCard('Project Details', Icons.rocket_launch_rounded, [
          _buildReviewRow('Title', _titleController.text.isNotEmpty ? _titleController.text : 'Not specified'),
          _buildReviewRow('Domain', _selectedDomain),
          _buildReviewRow('Budget', _budgetController.text.isNotEmpty ? '₹${_budgetController.text}' : 'Not specified'),
          _buildReviewRow('Deadline', _deadlineController.text.isNotEmpty ? _deadlineController.text : 'Flexible'),
        ]),
        const SizedBox(height: 16),

        // Student Card
        _buildReviewCard('Student Information', Icons.person_rounded, [
          _buildReviewRow('Name', _nameController.text.isNotEmpty ? _nameController.text : 'Not specified'),
          _buildReviewRow('College', _collegeController.text.isNotEmpty ? _collegeController.text : 'Not specified'),
          _buildReviewRow('Branch', _branchController.text.isNotEmpty ? _branchController.text : 'Not specified'),
          _buildReviewRow('Email', _emailController.text.isNotEmpty ? _emailController.text : 'Not specified'),
          _buildReviewRow('Phone', _phoneController.text.isNotEmpty ? _phoneController.text : 'Not specified'),
        ]),
        const SizedBox(height: 16),

        // Documents Card
        _buildReviewCard('Uploaded Documents', Icons.folder_rounded, [
          _buildReviewRow('Documents', '${_uploadedDocs.length} file(s)'),
          _buildReviewRow('Presentations', '${_uploadedPpts.length} file(s)'),
        ]),
        const SizedBox(height: 16),

        // Abstract Preview
        if (_abstractController.text.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Project Abstract', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Text(_abstractController.text, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
              ],
            ),
          ),
        const SizedBox(height: 24),

        // Terms
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your project details are secure and will only be shared with verified expert developers.',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Helper Widgets ───────────────────────────────────────────────

  Widget _buildStepHeader(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.02)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textTertiary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Widget _buildDomainSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Project Domain *', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _domains.map((domain) {
            final isSelected = _selectedDomain == domain;
            return GestureDetector(
              onTap: () => setState(() => _selectedDomain = domain),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                  boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8)] : null,
                ),
                child: Text(
                  domain,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUploadSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<String> files,
    required VoidCallback onUpload,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Upload Area
          GestureDetector(
            onTap: onUpload,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.2), style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_rounded, color: color, size: 36),
                  const SizedBox(height: 8),
                  Text('Tap to upload files', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
                  Text('Max 10MB per file', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            ),
          ),

          // Uploaded Files
          if (files.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...files.map((f) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
                  GestureDetector(
                    onTap: () => setState(() => files.remove(f)),
                    child: const Icon(Icons.close_rounded, size: 16, color: AppColors.textTertiary),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(String title, IconData icon, List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary, fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Previous', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentStep == 3 ? const Color(0xFF22C55E) : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(
                      _currentStep == 3 ? 'Submit Order 🚀' : 'Continue',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Logic ────────────────────────────────────────────────────────

  void _onNext() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submitOrder();
    }
  }

  void _simulateUpload(List<String> files, String type) {
    final count = files.length + 1;
    setState(() {
      files.add('${type}_$count.${type == 'Presentation' ? 'pptx' : 'pdf'}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type uploaded successfully!'),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _submitOrder() async {
    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final order = CustomProjectOrder(
      id: 'CPO-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      studentName: _nameController.text,
      collegeName: _collegeController.text,
      branch: _branchController.text,
      semester: _semesterController.text,
      domain: _selectedDomain,
      abstractText: _abstractController.text,
      requirements: _requirementsController.text,
      budget: _budgetController.text,
      deadline: _deadlineController.text,
      contactEmail: _emailController.text,
      contactPhone: _phoneController.text,
      documentPaths: _uploadedDocs,
      pptPaths: _uploadedPpts,
      createdAt: DateTime.now(),
    );

    ref.read(customOrdersProvider.notifier).submit(order);

    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 56),
                ),
                const SizedBox(height: 28),
                Text('Order Submitted! 🎉', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Text(
                  'Your custom project order has been submitted successfully. Our expert team will review it and get back to you within 24 hours.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary, height: 1.6),
                ),
                const SizedBox(height: 12),
                Text(
                  'Order ID: CPO-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Back to Home', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Track Order →', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? v) => (v == null || v.isEmpty) ? 'This field is required' : null;
  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!v.contains('@')) return 'Enter a valid email';
    return null;
  }
  String? _phoneValidator(String? v) {
    if (v == null || v.isEmpty) return 'Phone number is required';
    if (v.replaceAll(RegExp(r'[^0-9]'), '').length < 10) return 'Enter a valid phone number';
    return null;
  }
}

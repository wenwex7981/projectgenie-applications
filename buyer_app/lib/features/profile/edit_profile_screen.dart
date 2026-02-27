import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Alex Johnson');
  final TextEditingController _bioController = TextEditingController(text: 'Computer Science student passionate about UI/UX design and machine learning applications in education.');
  final TextEditingController _phoneController = TextEditingController(text: '+1 (555) 000-1234');
  
  String _selectedUniversity = 'Stanford University';
  String _selectedMajor = 'Computer Science';
  String _selectedGradYear = '2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F8).withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF334155)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Preview', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              _buildAvatarSection(),
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.person, 'Personal Info'),
              const SizedBox(height: 16),
              _buildInputField('Full Name', _nameController),
              const SizedBox(height: 16),
              _buildInputField('Bio', _bioController, isMultiline: true),
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.school, 'Academic Details'),
              const SizedBox(height: 16),
              _buildDropdownField('University', ['Stanford University', 'MIT', 'Harvard University', 'UC Berkeley', 'Oxford University'], _selectedUniversity, (val) => setState(() => _selectedUniversity = val!)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDropdownField('Major', ['Computer Science', 'Business Admin', 'Psychology', 'Biology'], _selectedMajor, (val) => setState(() => _selectedMajor = val!))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdownField('Grad Year', ['2024', '2025', '2026', '2027'], _selectedGradYear, (val) => setState(() => _selectedGradYear = val!))),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.contact_mail, 'Contact Information'),
              const SizedBox(height: 16),
              _buildInputField('Email Address', TextEditingController(text: 'alex.johnson@university.edu'), isReadOnly: true),
              const SizedBox(height: 16),
              _buildInputField('Phone Number', _phoneController),
              const SizedBox(height: 48),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                image: const DecorationImage(
                  image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuCWvtx8UiFFVNPBINpVcvyNtye28LlNVWRGtbtdai3NiZEcye_dKIkrJTjbSoT8EUTlBLjawi_0OyPzBc1sxVdzdIbkahqCERniIcB2lKIqe7jr3Ar7lKE0KiXbHjjOps8ZLI8BiORdwUbR7dix8PpmrNOqx4TalT_pY-7nJGA-m69CkgwA1sDJiQrSeKL8avyByecSgreHXq-MAW5p7eyw-wQkakJyTwMq6qIlOw-Pv1OYM3FzrAvKV_XDOnkJfsx6fwaCikU7vJc"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.photo_camera, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Change Profile Photo',
          style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.2),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isMultiline = false, bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
        ),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 4 : 1,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: isReadOnly ? const Color(0xFFF1F5F9) : Colors.white,
            suffixIcon: isReadOnly ? const Icon(Icons.lock, size: 18, color: Color(0xFF94A3B8)) : null,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
          ),
          style: TextStyle(color: isReadOnly ? const Color(0xFF64748B) : const Color(0xFF0F172A), fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Changes saved successfully')));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
            shadowColor: AppTheme.primaryColor.withOpacity(0.3),
          ),
          child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

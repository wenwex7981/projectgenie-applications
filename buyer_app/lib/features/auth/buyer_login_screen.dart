import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import 'otp_verify_screen.dart';

class BuyerLoginScreen extends StatefulWidget {
  const BuyerLoginScreen({super.key});

  static Map<String, dynamic>? loggedInUser;
  static String? jwtToken;

  @override
  State<BuyerLoginScreen> createState() => _BuyerLoginScreenState();
}

class _BuyerLoginScreenState extends State<BuyerLoginScreen> {
  static const String baseUrl = 'https://projectgenie-api.onrender.com';

  final _emailCtrl = TextEditingController(text: 'vardhan@university.edu');
  final _passwordCtrl = TextEditingController(text: 'password123');
  bool _loading = false;
  bool _obscure = true;
  bool _isRegister = false;
  String? _error;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _collegeCtrl = TextEditingController();
  final _branchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF141A29), // Very dark premium blue
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFF3F4F6), Color(0xFF9CA3AF), Color(0xFFD1D5DB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text('P', style: GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFDE047), Color(0xFFB45309), Color(0xFFFBBF24)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text('G', style: GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _isRegister ? 'Create Your\nAccount 🎓' : 'Welcome to\nProjectGenie 👋',
                style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.textPrimary, height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                _isRegister ? 'Join thousands of students finding their perfect projects' : 'Sign in to discover amazing academic projects',
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              if (_isRegister) ...[
                _label('Full Name'),
                _field(_nameCtrl, 'Vardhan Kumar', Icons.person_rounded),
                const SizedBox(height: 14),
                _label('Phone Number'),
                _field(_phoneCtrl, '+91 98765 43210', Icons.phone_rounded, keyboardType: TextInputType.phone),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('College'),
                    _field(_collegeCtrl, 'JNTU', Icons.school_rounded),
                  ])),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('Branch'),
                    _field(_branchCtrl, 'CSE', Icons.category_rounded),
                  ])),
                ]),
                const SizedBox(height: 14),
              ],

              _label('Email Address'),
              _field(_emailCtrl, 'student@university.edu', Icons.email_rounded, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),

              _label('Password'),
              TextField(
                controller: _passwordCtrl, obscureText: _obscure,
                style: GoogleFonts.inter(fontSize: 15),
                decoration: _deco('••••••••', Icons.lock_rounded).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textTertiary),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.error_rounded, size: 16, color: Color(0xFFEF4444)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFEF4444)))),
                  ]),
                ),
              ],
              const SizedBox(height: 16),

              // Email verification notice
              Container(
                width: double.infinity, padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.verified_user_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Email verification via OTP is required',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary))),
                ]),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : (_isRegister ? _register : _login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                      : Text(_isRegister ? 'Create Account & Verify' : 'Sign In & Verify', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_isRegister ? 'Already have an account? ' : "Don't have an account? ", style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => setState(() { _isRegister = !_isRegister; _error = null; }),
                  child: Text(_isRegister ? 'Sign In' : 'Register', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ]),
              const SizedBox(height: 24),

              if (!_isRegister) Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(14)),
                child: Column(children: [
                  Text('Demo Accounts (password: password123)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  _demoBtn('Vardhan Kumar', 'vardhan@university.edu'),
                  _demoBtn('Student User', 'student@college.edu'),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)));
  Widget _field(TextEditingController c, String h, IconData i, {TextInputType? keyboardType}) => TextField(controller: c, keyboardType: keyboardType, style: GoogleFonts.inter(fontSize: 15), decoration: _deco(h, i));
  Widget _demoBtn(String n, String e) => GestureDetector(
    onTap: () { _emailCtrl.text = e; _passwordCtrl.text = 'password123'; },
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
      const Icon(Icons.person_rounded, size: 14, color: AppColors.primary),
      const SizedBox(width: 6),
      Text('$n — $e', style: GoogleFonts.inter(fontSize: 11, color: AppColors.primary)),
    ])),
  );

  InputDecoration _deco(String h, IconData i) => InputDecoration(
    hintText: h, hintStyle: GoogleFonts.inter(color: AppColors.textTertiary),
    prefixIcon: Icon(i, color: AppColors.textTertiary, size: 20),
    filled: true, fillColor: const Color(0xFFF1F5F9),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
  );

  void _goOtp(String email, String type, String? name) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => BuyerOtpScreen(email: email, type: type, name: name, onVerified: (result) {
        BuyerLoginScreen.loggedInUser = result['user'];
        BuyerLoginScreen.jwtToken = result['token'];
        if (result['user']?['id'] != null) {
          NotificationService().listenToRealtimeNotifications(result['user']['id']);
        }
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashboardScreen()), (_) => false);
      }),
    ));
  }

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) { setState(() => _error = 'Enter email and password'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.post(Uri.parse('$baseUrl/auth/buyer/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailCtrl.text, 'password': _passwordCtrl.text}));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final raw = jsonDecode(res.body);
        final data = raw['data'] ?? raw;
        if (data['requiresVerification'] == true) _goOtp(_emailCtrl.text, 'login', data['userName']);
      } else {
        final body = jsonDecode(res.body);
        final msg = body['message'];
        setState(() => _error = (msg is List ? msg.join(', ') : msg?.toString()) ?? 'Invalid email or password');
      }
    } catch (e) { setState(() => _error = 'Connection error. Check if backend is running.'); }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _register() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) { setState(() => _error = 'Fill all required fields'); return; }
    if (_passwordCtrl.text.length < 6) { setState(() => _error = 'Password min 6 characters'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.post(Uri.parse('$baseUrl/auth/buyer/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailCtrl.text, 'password': _passwordCtrl.text, 'name': _nameCtrl.text,
          'phone': _phoneCtrl.text, 'college': _collegeCtrl.text, 'branch': _branchCtrl.text,
        }));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final raw = jsonDecode(res.body);
        final data = raw['data'] ?? raw;
        if (data['requiresVerification'] == true) _goOtp(_emailCtrl.text, 'register', _nameCtrl.text);
      } else {
        final body = jsonDecode(res.body);
        final msg = body['message'];
        setState(() => _error = (msg is List ? msg.join(', ') : msg?.toString()) ?? 'Registration failed');
      }
    } catch (e) { setState(() => _error = 'Connection error.'); }
    if (mounted) setState(() => _loading = false);
  }
}

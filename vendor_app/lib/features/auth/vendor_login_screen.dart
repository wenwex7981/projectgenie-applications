import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/api_service.dart';
import '../dashboard/vendor_main_navigation.dart';
import 'otp_verify_screen.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  static const String baseUrl = 'https://projectgenie-api.onrender.com';

  final _emailCtrl = TextEditingController(text: 'ailab@projectgenie.com');
  final _passwordCtrl = TextEditingController(text: 'password123');
  bool _loading = false;
  bool _obscure = true;
  bool _isRegister = false;
  String? _error;

  final _nameCtrl = TextEditingController();
  final _businessCtrl = TextEditingController();

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
                _isRegister ? 'Create Seller\nAccount 🚀' : 'Welcome Back,\nSeller 👋',
                style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w900, color: VC.text, height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                _isRegister ? 'Start selling your projects & services' : 'Sign in to manage your projects & services',
                style: GoogleFonts.inter(fontSize: 15, color: VC.textSec),
              ),
              const SizedBox(height: 32),

              if (_isRegister) ...[
                _label('Full Name'),
                _textField(_nameCtrl, 'Dr. Priya Sharma', Icons.person_rounded),
                const SizedBox(height: 16),
                _label('Business Name'),
                _textField(_businessCtrl, 'AI Research Lab', Icons.business_rounded),
                const SizedBox(height: 16),
              ],

              _label('Email'),
              _textField(_emailCtrl, 'seller@projectgenie.com', Icons.email_rounded, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),

              _label('Password'),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                style: GoogleFonts.inter(fontSize: 15),
                decoration: _inputDeco('••••••••', Icons.lock_rounded).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: VC.textTer),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: VC.errorBg, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.error_rounded, size: 16, color: VC.error),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: VC.error))),
                  ]),
                ),
              ],
              const SizedBox(height: 24),

              // Email verification notice
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: VC.accentLight, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.verified_user_rounded, size: 18, color: VC.accent),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'Email verification via OTP is required',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: VC.accent),
                  )),
                ]),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : (_isRegister ? _register : _login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VC.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                      : Text(_isRegister ? 'Create Account & Verify' : 'Sign In & Verify', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_isRegister ? 'Already have an account? ' : "Don't have an account? ", style: GoogleFonts.inter(fontSize: 13, color: VC.textSec)),
                GestureDetector(
                  onTap: () => setState(() { _isRegister = !_isRegister; _error = null; }),
                  child: Text(_isRegister ? 'Sign In' : 'Register', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.accent)),
                ),
              ]),
              const SizedBox(height: 24),

              if (!_isRegister) Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: VC.accentLight, borderRadius: BorderRadius.circular(14)),
                child: Column(children: [
                  Text('Demo Accounts (password: password123)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: VC.accent)),
                  const SizedBox(height: 8),
                  _demoBtn('AI Research Lab', 'ailab@projectgenie.com'),
                  _demoBtn('CodeMasters', 'codemasters@projectgenie.com'),
                  _demoBtn('PyWizards', 'pywizards@projectgenie.com'),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.text)));
  Widget _textField(TextEditingController c, String h, IconData i, {TextInputType? keyboardType}) => TextField(controller: c, keyboardType: keyboardType, style: GoogleFonts.inter(fontSize: 15), decoration: _inputDeco(h, i));
  Widget _demoBtn(String name, String email) => GestureDetector(
    onTap: () { _emailCtrl.text = email; _passwordCtrl.text = 'password123'; },
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
      const Icon(Icons.person_rounded, size: 14, color: VC.accent),
      const SizedBox(width: 6),
      Text('$name — $email', style: GoogleFonts.inter(fontSize: 11, color: VC.accent)),
    ])),
  );

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
    hintText: hint, hintStyle: GoogleFonts.inter(color: VC.textTer),
    prefixIcon: Icon(icon, color: VC.textTer, size: 20),
    filled: true, fillColor: VC.surfaceAlt,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: VC.accent, width: 2)),
  );

  void _navigateToOtp(String email, String type, String? name) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => OtpVerifyScreen(
        email: email, role: 'vendor', type: type, name: name,
        onVerified: (result) {
          ApiService.setToken(result['token']);
          ApiService.setVendorId(result['vendor']['id']); // Fix: Ensure vendorId is set globally
          
          if (result['vendor']?['id'] != null) {
            NotificationService().listenToRealtimeNotifications(result['vendor']['id']);
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => VendorMainNavigation(
              vendorId: result['vendor']['id'],
              vendorName: result['vendor']['name'],
            )),
            (_) => false,
          );
        },
      ),
    ));
  }

  Future<void> _login() async {
    // DEV BYPASS: Skip API and OTP, directly log in as Vendor-001
    setState(() { _loading = true; _error = null; });
    
    await Future.delayed(const Duration(milliseconds: 500)); // Fake loading
    
    final dummyVendorId = 'vendor-001';
    ApiService.setToken('mock_token_for_dev');
    ApiService.setVendorId(dummyVendorId);
    
    NotificationService().listenToRealtimeNotifications(dummyVendorId);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => VendorMainNavigation(
          vendorId: dummyVendorId,
          vendorName: 'Developer Mode Vendor',
        )),
        (_) => false,
      );
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _register() async {
    if (_nameCtrl.text.isEmpty || _businessCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) { setState(() => _error = 'Please fill all fields'); return; }
    if (_passwordCtrl.text.length < 6) { setState(() => _error = 'Password min 6 characters'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await http.post(Uri.parse('$baseUrl/auth/vendor/register'), headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailCtrl.text, 'password': _passwordCtrl.text, 'name': _nameCtrl.text, 'businessName': _businessCtrl.text}));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final raw = jsonDecode(res.body);
        final data = raw['data'] ?? raw;
        if (data['requiresVerification'] == true) {
          _navigateToOtp(_emailCtrl.text, 'register', _nameCtrl.text);
        }
      } else {
        final body = jsonDecode(res.body);
        final msg = body['message'];
        setState(() => _error = (msg is List ? msg.join(', ') : msg?.toString()) ?? 'Registration failed');
      }
    } catch (e) { setState(() => _error = 'Connection error.'); }
    if (mounted) setState(() => _loading = false);
  }
}

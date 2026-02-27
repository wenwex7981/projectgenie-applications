import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../core/theme/app_colors.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String role; // 'buyer' or 'vendor'
  final String type; // 'login' or 'register'
  final String? name;
  final Function(Map<String, dynamic> result) onVerified;

  const OtpVerifyScreen({
    super.key, required this.email, required this.role,
    required this.type, this.name, required this.onVerified,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  static const String baseUrl = 'http://localhost:3000';

  final List<TextEditingController> _ctrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focuses = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  String? _error;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _resendTimer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _ctrls) { c.dispose(); }
    for (var f in _focuses) { f.dispose(); }
    super.dispose();
  }

  String get _otpCode => _ctrls.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, surfaceTintColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 16),

          // Mail icon
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              gradient: VC.heroGrad,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 24),

          Text('Verify Your Email', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: VC.text)),
          const SizedBox(height: 8),
          Text(
            'We\'ve sent a 6-digit verification code to',
            style: GoogleFonts.inter(fontSize: 14, color: VC.textSec),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.email,
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: VC.accent),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // OTP fields
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) => Container(
              width: 48, height: 56,
              margin: EdgeInsets.only(right: i < 5 ? 8 : 0, left: i == 3 ? 8 : 0),
              child: TextField(
                controller: _ctrls[i],
                focusNode: _focuses[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: VC.text),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: VC.surfaceAlt,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: VC.accent, width: 2),
                  ),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && i < 5) {
                    _focuses[i + 1].requestFocus();
                  } else if (val.isEmpty && i > 0) {
                    _focuses[i - 1].requestFocus();
                  }
                  if (_otpCode.length == 6) _verifyOtp();
                },
              ),
            )),
          ),
          const SizedBox(height: 24),

          if (_error != null) Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: VC.errorBg, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.error_rounded, size: 16, color: VC.error),
              const SizedBox(width: 8),
              Expanded(child: Text(_error!, style: GoogleFonts.inter(fontSize: 13, color: VC.error))),
            ]),
          ),

          // Verify button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _loading || _otpCode.length != 6 ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: VC.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                disabledBackgroundColor: VC.primary.withValues(alpha: 0.4),
              ),
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Text('Verify Email', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),

          // Resend
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Didn't receive code? ", style: GoogleFonts.inter(fontSize: 13, color: VC.textSec)),
            _resendTimer > 0
                ? Text('Resend in ${_resendTimer}s', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.textTer))
                : GestureDetector(
                    onTap: _resendOtp,
                    child: Text('Resend OTP', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.accent)),
                  ),
          ]),
          const SizedBox(height: 32),

          // Info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: VC.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.info_rounded, size: 16, color: VC.textSec),
                const SizedBox(width: 8),
                Text('Check your email', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: VC.text)),
              ]),
              const SizedBox(height: 6),
              Text('• Check spam/junk folder if not in inbox\n• OTP expires in 10 minutes\n• Check the backend console for the OTP code', style: GoogleFonts.inter(fontSize: 12, color: VC.textSec, height: 1.5)),
            ]),
          ),
        ]),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final code = _otpCode;
    if (code.length != 6) return;
    setState(() { _loading = true; _error = null; });

    try {
      final endpoint = widget.type == 'register' ? 'verify-otp' : 'verify-login-otp';
      final res = await http.post(
        Uri.parse('$baseUrl/auth/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'code': code, 'role': widget.role}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        if (!mounted) return;
        widget.onVerified(data);
      } else {
        final body = jsonDecode(res.body);
        setState(() => _error = body['message'] ?? 'Invalid OTP. Please try again.');
        _clearOtp();
      }
    } catch (e) {
      setState(() => _error = 'Connection error. Please try again.');
      _clearOtp();
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _resendOtp() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email, 'role': widget.role, 'type': widget.type}),
      );
      _startTimer();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New OTP sent!'), backgroundColor: VC.success),
      );
    } catch (_) {}
  }

  void _clearOtp() {
    for (var c in _ctrls) { c.clear(); }
    _focuses[0].requestFocus();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/vendor_login_screen.dart';
import 'features/dashboard/vendor_main_navigation.dart';
import 'core/services/supabase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  await NotificationService().initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const ProviderScope(child: VendorApp()));
}

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProjectGenie — Seller Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _VendorAuthGate(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  VENDOR AUTH GATE — Persistent Session
//  The app will NOT logout when removed from recents or killed.
//  Supabase persists the session token in secure storage.
// ═══════════════════════════════════════════════════════════════════
class _VendorAuthGate extends StatefulWidget {
  const _VendorAuthGate();

  @override
  State<_VendorAuthGate> createState() => _VendorAuthGateState();
}

class _VendorAuthGateState extends State<_VendorAuthGate> {
  bool _isChecking = true;
  bool _isLoggedIn = false;
  String? _vendorId;
  String? _vendorName;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          // Fetch vendor profile from our Vendor table
          try {
            final profile = await Supabase.instance.client
                .from('Vendor')
                .select()
                .eq('id', user.id)
                .maybeSingle();

            if (profile != null) {
              _vendorId = profile['id'];
              _vendorName = profile['name'] ?? 'Vendor';
              ApiService.setToken(session.accessToken);
              ApiService.setVendorId(_vendorId);
              // Start notification listener
              NotificationService().listenToRealtimeNotifications(user.id);
              setState(() {
                _isLoggedIn = true;
                _isChecking = false;
              });
              return;
            }
          } catch (_) {
            // Profile fetch failed
          }
        }
      }
    } catch (e) {
      debugPrint('Session check error: $e');
    }
    setState(() {
      _isLoggedIn = false;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 48, height: 48,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              SizedBox(height: 16),
              Text('Loading Seller Portal...', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    if (_isLoggedIn && _vendorId != null) {
      return VendorMainNavigation(
        vendorId: _vendorId!,
        vendorName: _vendorName ?? 'Vendor',
      );
    }

    return const VendorLoginScreen();
  }
}

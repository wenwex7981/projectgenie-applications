import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/buyer_login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'core/services/supabase_service.dart';
import 'core/services/notification_service.dart';
import 'features/projects/controllers/projects_controller.dart';

// ═══════════════════════════════════════════════════════════════════
//  GLOBAL REALTIME SYNC SERVICE — lives at app level, never dies
// ═══════════════════════════════════════════════════════════════════
class RealtimeSyncService {
  static RealtimeChannel? _serviceChannel;
  static RealtimeChannel? _projectChannel;
  static RealtimeChannel? _hackathonChannel;
  static RealtimeChannel? _bannerChannel;
  static ProviderContainer? _container;

  static void initialize(ProviderContainer container) {
    _container = container;

    // Listen for Service table changes
    _serviceChannel = Supabase.instance.client
        .channel('global:Service')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Service',
          callback: (payload) {
            debugPrint('🔔 [Global] Service Update: ${payload.commitTimestamp}');
            _container?.invalidate(trendingServicesProvider);
            _container?.invalidate(servicesProvider);
            NotificationService().showNotification(
              title: '🆕 New Service Available!',
              body: 'A vendor just updated their services. Check it out!',
            );
          },
        )
        .subscribe();

    // Listen for Project table changes
    _projectChannel = Supabase.instance.client
        .channel('global:Project')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Project',
          callback: (payload) {
            debugPrint('🔔 [Global] Project Update: ${payload.commitTimestamp}');
            _container?.invalidate(featuredProjectsProvider);
            _container?.invalidate(allProjectsProvider);
            _container?.invalidate(projectsProvider);
            NotificationService().showNotification(
              title: '🆕 New Project Listed!',
              body: 'A vendor just published a new project!',
            );
          },
        )
        .subscribe();

    // Listen for Hackathon table changes
    _hackathonChannel = Supabase.instance.client
        .channel('global:Hackathon')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Hackathon',
          callback: (payload) {
            debugPrint('🔔 [Global] Hackathon Update: ${payload.commitTimestamp}');
            _container?.invalidate(hackathonsProvider);
            NotificationService().showNotification(
              title: '🏆 New Hackathon Posted!',
              body: 'Check out the latest hackathon opportunity!',
            );
          },
        )
        .subscribe();

    // Listen for Banner table changes (for editable carousels)
    _bannerChannel = Supabase.instance.client
        .channel('global:Banner')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Banner',
          callback: (payload) {
            debugPrint('🔔 [Global] Banner Update: ${payload.commitTimestamp}');
            _container?.invalidate(bannersProvider);
          },
        )
        .subscribe();

    debugPrint('🌐 Global Realtime Sync Service: ACTIVE on all tables');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase before running the app
  await SupabaseService.initialize();

  // Initialize Push Notifications
  await NotificationService().initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final container = ProviderContainer();

  // Start global realtime sync — stays alive for ENTIRE app lifecycle
  RealtimeSyncService.initialize(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ProjectGenieApp(),
    ),
  );
}

class ProjectGenieApp extends StatelessWidget {
  const ProjectGenieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProjectGenie — Enterprise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _AuthGate(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  AUTH GATE — Persistent Session: If logged in, go to Dashboard
//  The app will NOT logout when removed from recents or killed.
//  Supabase persists the session token in secure storage.
// ═══════════════════════════════════════════════════════════════════
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _isChecking = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        // Session exists — user is logged in
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          // Fetch user profile from our User table
          try {
            final profile = await Supabase.instance.client
                .from('User')
                .select()
                .eq('id', user.id)
                .maybeSingle();

            if (profile != null) {
              BuyerLoginScreen.loggedInUser = profile;
              BuyerLoginScreen.jwtToken = session.accessToken;
              // Start notification listener
              NotificationService().listenToRealtimeNotifications(user.id);
            }
          } catch (_) {
            // Profile fetch failed, still allow login
          }
          setState(() {
            _isLoggedIn = true;
            _isChecking = false;
          });
          return;
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
                width: 48,
                height: 48,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              SizedBox(height: 16),
              Text(
                'Loading ProjectGenie...',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoggedIn) {
      return const DashboardScreen();
    }

    return const BuyerLoginScreen();
  }
}

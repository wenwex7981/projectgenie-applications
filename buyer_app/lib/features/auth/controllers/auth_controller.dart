import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.read(supabaseProvider));
});

final userProvider = StreamProvider<User?>((ref) {
  return ref.read(supabaseProvider).auth.onAuthStateChange.map((event) => event.session?.user);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _supabase;

  AuthController(this._supabase) : super(const AsyncData(null));

  Future<void> signIn({required String email, required String password, required BuildContext context}) async {
    state = const AsyncLoading();
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
      if (context.mounted) {
        // Navigation is handled in the UI based on state or explicit success
      }
    } on AuthException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String university,
    required String phone,
    required BuildContext context,
  }) async {
    state = const AsyncLoading();
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'university': university,
          'phone': phone,
        },
      );
      state = const AsyncData(null);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please verify your email.')),
        );
        Navigator.pop(context); // Go back to login
      }
    } on AuthException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

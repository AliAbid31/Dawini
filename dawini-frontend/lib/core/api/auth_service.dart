import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final dio = ApiClient().dio;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> syncProfile({
    required String id,
    required String email,
    required String fullName,
    required String role,
    required String language,
  }) async {
    await dio.post(ApiEndpoints.syncProfile, data: {
      "id": id,
      "email": email,
      "full_name": fullName,
      "role": role,
      "preferred_language": language,
    });
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    return await _supabase.from('profiles').select().eq('id', user.id).maybeSingle();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
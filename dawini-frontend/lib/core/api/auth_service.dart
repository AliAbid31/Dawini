import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class AuthService {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
  final dio = ApiClient().dio;

  bool get isReady => _supabase != null;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final supabase = _supabase;
    if (supabase == null) {
      throw Exception('Supabase is not initialized.');
    }

    return await supabase.auth.signInWithPassword(
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
    String? phone,
  }) async {
    await dio.post(ApiEndpoints.syncProfile, data: {
      "id": id,
      "email": email,
      "full_name": fullName,
      "role": role,
      "preferred_language": language,
      if (phone != null && phone.trim().isNotEmpty) "phone": phone.trim(),
    });
  }

  Future<void> createPatientDetails({
    required String profileId,
    String? location,
    String? birthDate,
    String? gender,
  }) async {
    await dio.post(ApiEndpoints.createPatientDetails, data: {
      "profile_id": profileId,
      if (location != null && location.trim().isNotEmpty) "location": location.trim(),
      if (birthDate != null && birthDate.trim().isNotEmpty) "birth_date": birthDate.trim(),
      if (gender != null && gender.trim().isNotEmpty) "gender": gender.trim(),
    });
  }

  Future<void> createPharmacyDetails({
    required String ownerId,
    required String name,
    required String address,
    required String licenseNumber,
  }) async {
    await dio.post(ApiEndpoints.createPharmacyDetails, data: {
      "owner_id": ownerId,
      "name": name.trim(),
      "address": address.trim(),
      "license_number": licenseNumber.trim(),
    });
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final supabase = _supabase;
    final user = currentUser;
    if (user == null) return null;

    if (supabase == null) return null;

    return await supabase.from('profiles').select().eq('id', user.id).maybeSingle();
  }

  Future<void> signOut() async {
    final supabase = _supabase;
    if (supabase != null) {
      await supabase.auth.signOut();
    }
  }

  User? get currentUser => _supabase?.auth.currentUser;
}
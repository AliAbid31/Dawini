import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

class AuthService {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Stream<AuthState> get authStateListener => _supabase?.auth.onAuthStateChange ?? const Stream.empty();

  User? get currentUser => _supabase?.auth.currentUser;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final supabase = _supabase;
      if (supabase == null) {
        throw Exception('Supabase is not initialized.');
      }

      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e, stack) {
      debugPrint('SignIn Error: $e\n$stack');
      throw Exception('An unexpected error occurred during sign in: $e');
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    required String language,
  }) async {
    try {
      final supabase = _supabase;
      if (supabase == null) {
        throw Exception('Supabase is not initialized.');
      }

      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
          'preferred_language': language,
        },
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e, stack) {
      debugPrint('SignUp Error: $e\n$stack');
      throw Exception('An unexpected error occurred during sign up: $e');
    }
  }

  // Récupération des données du profil utilisateur depuis la table public.profiles
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final supabase = _supabase;
      final User? user = currentUser;
      if (user == null) return null;

      if (supabase == null) return null;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      return data;
    } catch (e) {
      return null;
    }
  }

  // Mise à jour de la langue préférée à la fois dans la base de données et dans l'application
  Future<void> updateLanguage(BuildContext context, String langCode) async {
    try {
      final supabase = _supabase;
      final User? user = currentUser;
      if (user != null && supabase != null) {
        await supabase
            .from('profiles')
            .update({'preferred_language': langCode})
            .eq('id', user.id);
      }
      if (context.mounted) {
        await context.setLocale(Locale(langCode));
      }
    } catch (e) {
      debugPrint('Failed to update language: $e');
    }
  }

  // Déconnexion complète et fermeture de session
  Future<void> signOut() async {
    try {
      final supabase = _supabase;
      if (supabase != null) {
        await supabase.auth.signOut();
      }
    } catch (e) {
      throw Exception('Failed to sign out.');
    }
  }

  Future<void> syncProfile({
    required String id,
    required String email,
    required String fullName,
    required String role,
    required String language,
    String? phone,
  }) async {
    try {
      await ApiClient.client.post(ApiEndpoints.syncProfile, data: {
        'id': id,
        'full_name': fullName,
        'email': email,
        'role': role,
        'preferred_language': language,
        if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      });
      return;
    } on DioException catch (e) {
      debugPrint('DioException in syncProfile: ${e.message}');
      try {
        await _fallbackSyncProfile(id, email, fullName, role, language, phone);
      } catch (fallbackError) {
        throw Exception('Failed to sync profile: $fallbackError');
      }
    } catch (e) {
      throw Exception('Unexpected error in syncProfile: $e');
    }
  }

  Future<void> createPatientDetails({
    required String profileId,
    String? location,
    String? birthDate,
    String? gender,
  }) async {
    try {
      await ApiClient.client.post(ApiEndpoints.createPatientDetails, data: {
        'profile_id': profileId,
        if (location != null && location.trim().isNotEmpty) 'location': location.trim(),
        if (birthDate != null && birthDate.trim().isNotEmpty) 'birth_date': birthDate.trim(),
        if (gender != null && gender.trim().isNotEmpty) 'gender': gender.trim(),
      });
      return;
    } on DioException catch (e) {
      debugPrint('DioException in createPatientDetails: ${e.message}');
      try {
        await _fallbackCreatePatient(profileId, location, birthDate, gender);
      } catch (fallbackError) {
        throw Exception('Failed to create patient details: $fallbackError');
      }
    } catch (e) {
      throw Exception('Unexpected error in createPatientDetails: $e');
    }
  }

  Future<void> createPharmacyDetails({
    required String ownerId,
    required String name,
    required String address,
    required String licenseNumber,
  }) async {
    try {
      await ApiClient.client.post(ApiEndpoints.createPharmacyDetails, data: {
        'owner_id': ownerId,
        'name': name.trim(),
        'address': address.trim(),
        'license_number': licenseNumber.trim(),
      });
      return;
    } on DioException catch (e) {
      debugPrint('DioException in createPharmacyDetails: ${e.message}');
      try {
        await _fallbackCreatePharmacy(ownerId, name, address, licenseNumber);
      } catch (fallbackError) {
        throw Exception('Failed to create pharmacy details: $fallbackError');
      }
    } catch (e) {
      throw Exception('Unexpected error in createPharmacyDetails: $e');
    }
  }

  Future<void> _fallbackSyncProfile(String id, String email, String fullName, String role, String language, String? phone) async {
    final supabase = _supabase;
    if (supabase == null) throw Exception('Supabase not available for profile sync.');
    await supabase.from('profiles').upsert({
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'phone': phone,
      'preferred_language': language,
    });
  }

  Future<void> _fallbackCreatePatient(String profileId, String? location, String? birthDate, String? gender) async {
    final supabase = _supabase;
    if (supabase == null) throw Exception('Supabase not available for patient details.');
    await supabase.from('patients').upsert({
      'profile_id': profileId,
      if (location != null && location.trim().isNotEmpty) 'location': location.trim(),
      if (birthDate != null && birthDate.trim().isNotEmpty) 'birth_date': birthDate.trim(),
      if (gender != null && gender.trim().isNotEmpty) 'gender': gender.trim(),
    });
  }

  Future<void> _fallbackCreatePharmacy(String ownerId, String name, String address, String licenseNumber) async {
    final supabase = _supabase;
    if (supabase == null) throw Exception('Supabase not available for pharmacy details.');
    await supabase.from('pharmacies').upsert({
      'owner_id': ownerId,
      'name': name.trim(),
      'address': address.trim(),
      'license_number': licenseNumber.trim(),
      'is_verified': false,
    });
  }
}

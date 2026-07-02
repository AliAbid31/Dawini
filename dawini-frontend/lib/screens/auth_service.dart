import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<AuthState> get authStateListener => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred during sign in.');
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
      final AuthResponse response = await _supabase.auth.signUp(
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
    } catch (e) {
      throw Exception('An unexpected error occurred during sign up.');
    }
  }

  // Récupération des données du profil utilisateur depuis la table public.profiles
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final User? user = currentUser;
      if (user == null) return null;

      final data = await _supabase
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
      final User? user = currentUser;
      if (user != null) {
        await _supabase
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
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out.');
    }
  }
}
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_colors.dart';
import 'admin_dashboard.dart';
import 'patient_shell.dart';
import 'pharmacy_shell.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    Timer(const Duration(seconds: 2), _checkUserSession);
  }

  Future<void> _checkUserSession() async {
    if (!mounted) return;

    final localization = EasyLocalization.of(context);
    final navigator = Navigator.of(context);
    final session = _authService.currentUser == null ? null : Supabase.instance.client.auth.currentSession;
    if (session == null) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      try {
        final profile = await _authService.getUserProfile();
        if (profile != null && mounted) {
          final String role = profile['role'] ?? 'patient';
          final String language = profile['preferred_language'] ?? 'fr';
          await localization?.setLocale(Locale(language));

          if (role == 'admin') {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
            return;
          }

          if (role == 'pharmacy') {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (context) => const PharmacyShell()),
            );
          } else {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (context) => const PatientShell()),
            );
          }
        } else {
          _navigateToLogin();
        }
      } catch (_) {
        _navigateToLogin();
      }
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE9F3FC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 24,
                              child: Container(
                                width: 28,
                                height: 12,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primary, width: 3),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              child: Container(
                                width: 50,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Dawini',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your Digital Health Companion',
                      style: TextStyle(fontSize: 14, color: AppColors.textLight, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 180,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.dividerLine,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'CLINICAL EXCELLENCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9EAEB8),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

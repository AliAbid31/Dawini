import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';
import 'patient_shell.dart';
import 'pharmacy_shell.dart';
import 'admin_dashboard.dart';
import '../core/api/auth_service.dart';
import 'role_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = res.user;

      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('login_failed'.tr())),
          );
        }
        return;
      }

      await _authService.syncProfile(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?["full_name"]?.toString() ?? '',
        role: user.userMetadata?["role"]?.toString() ?? 'patient',
        language: user.userMetadata?["preferred_language"]?.toString() ?? 'fr',
      );

      final profile = await _authService.getUserProfile();
      final role = profile?['role']?.toString() ?? 'patient';
      final language = profile?['preferred_language']?.toString() ?? 'fr';

      if (mounted) {
        await context.setLocale(Locale(language));
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            if (role == 'pharmacy') {
              return const PharmacyShell();
            }
            if (role == 'admin') {
              return const AdminDashboard();
            }
            return const PatientShell();
          },
        ),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_hospital, color: AppColors.primary, size: 24),
                    SizedBox(width: 8),
                    Text('app_title'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('welcome_back'.tr(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark), textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text('access_dashboard'.tr(), style: TextStyle(fontSize: 13, color: AppColors.textMuted), textAlign: TextAlign.center),
                      const SizedBox(height: 32),
                      Text('email_address'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || !value.contains('@') ? 'enter_valid_email'.tr() : null,
                        decoration: const InputDecoration(
                          hintText: 'name@example.com',
                          prefixIcon: Icon(Icons.mail_outline, color: AppColors.textLight, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('password'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          TextButton(
                            onPressed: () {},
                            child: Text('forgot_password'.tr(), style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) => value == null || value.length < 6 ? 'password_min_length'.tr() : null,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.textLight,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                          ),
                          onPressed: _handleLogin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('login'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("dont_have_account".tr(), style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                        );
                      },
                      child: Text(
                        'register_now'.tr(),
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                const Text(
                  '© 2024 Dawini Healthcare Systems',
                  style: TextStyle(fontSize: 11, color: AppColors.textLight),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

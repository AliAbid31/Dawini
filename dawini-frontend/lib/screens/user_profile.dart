import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';
import '../core/api/auth_service.dart';
import 'login_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _pushNotifications = true;
  final AuthService _authService = AuthService();

  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _authService.getUserProfile();
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Language / Langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: ctx.locale.languageCode == 'fr'
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              title: const Text('Français'),
              subtitle: const Text('French'),
              selected: ctx.locale.languageCode == 'fr',
              onTap: () {
                Navigator.pop(ctx);
                _safeUpdateLanguage(ctx, 'fr');
              },
            ),
            ListTile(
              leading: ctx.locale.languageCode == 'en'
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              title: const Text('English'),
              subtitle: const Text('Anglais'),
              selected: ctx.locale.languageCode == 'en',
              onTap: () {
                Navigator.pop(ctx);
                _safeUpdateLanguage(ctx, 'en');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _safeUpdateLanguage(BuildContext dialogContext, String langCode) async {
    try {
      await _authService.updateLanguage(dialogContext, langCode);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language update failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {},
        ),
        title: Text('app_name'.tr(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textLight),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = snapshot.data;
            final fullName = profile?['full_name'] ?? 'Unknown User';
            final role = profile?['role'] ?? '';
            final roleDisplay = role.toString().toUpperCase();
            final email = profile?['email'] ?? 'No email provided';
            final phone = profile?['phone'] ?? 'No phone provided';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: const Color(0xFFE5F1FB),
                          child: Text(
                            fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.edit, color: Colors.white, size: 16),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(roleDisplay, style: const TextStyle(fontSize: 12, color: AppColors.textLight), textAlign: TextAlign.center),
                  const SizedBox(height: 32),

                  // Section Infos Personnelles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('personal_information'.tr().toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                      GestureDetector(
                        onTap: () {},
                        child: Text('view_all'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      children: [
                        _buildInfoRow('Full Name', fullName),
                        const Divider(color: Color(0xFFF1F5F9)),
                        _buildInfoRow('Email Address', email),
                        const Divider(color: Color(0xFFF1F5F9)),
                        _buildInfoRow('Phone Number', phone),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

              // Section Paramètres
                  Text('account_settings'.tr().toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      children: [
                        _buildSettingRow(Icons.lock_outline, 'change_password'.tr(), const Icon(Icons.chevron_right, color: AppColors.textLight)),
                        const Divider(color: Color(0xFFF1F5F9)),
                        _buildSettingRow(
                          Icons.notifications_outlined,
                          'push_notifications'.tr(),
                          Switch(
                            value: _pushNotifications,
                            activeThumbColor: AppColors.primary,
                            onChanged: (val) => setState(() => _pushNotifications = val),
                          ),
                        ),
                        const Divider(color: Color(0xFFF1F5F9)),
                        GestureDetector(
                          onTap: _changeLanguage,
                          child: _buildSettingRow(
                            Icons.translate,
                            'language'.tr(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.locale.languageCode == 'fr' ? 'Français' : 'English',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right, color: AppColors.textLight, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Bouton Déconnexion
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFEE2E2)),
                        backgroundColor: const Color(0xFFFEF2F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () {
                        _authService.signOut();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Color(0xFFB91C1C), size: 18),
                          SizedBox(width: 8),
                          Text('logout', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight, size: 18)
        ],
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String label, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

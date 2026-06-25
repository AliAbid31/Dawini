import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'login_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _pushNotifications = true;

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
        title: const Text('Dawini', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textLight),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 54,
                      backgroundImage: NetworkImage('https://i.imgur.com/Cf69I1b.png'),
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
              const Text('Dr. Julian Thorne', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              const Text('Senior Cardiologist', style: TextStyle(fontSize: 12, color: AppColors.textLight), textAlign: TextAlign.center),
              const SizedBox(height: 32),

              // Section Infos Personnelles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('PERSONAL INFORMATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('Edit All', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  children: [
                    _buildInfoRow('Full Name', 'Julian Thorne'),
                    const Divider(color: Color(0xFFF1F5F9)),
                    _buildInfoRow('Email Address', 'j.thorne@clinic.com'),
                    const Divider(color: Color(0xFFF1F5F9)),
                    _buildInfoRow('Phone Number', '+1 (555) 012-3456'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Section Paramètres
              const Text('ACCOUNT SETTINGS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  children: [
                    _buildSettingRow(Icons.lock_outline, 'Change Password', const Icon(Icons.chevron_right, color: AppColors.textLight)),
                    const Divider(color: Color(0xFFF1F5F9)),
                    _buildSettingRow(
                      Icons.notifications_outlined,
                      'Push Notifications',
                      Switch(
                        value: _pushNotifications,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _pushNotifications = val),
                      ),
                    ),
                    const Divider(color: Color(0xFFF1F5F9)),
                    _buildSettingRow(
                      Icons.translate,
                      'Language',
                      const Row(
                        children: [
                          Text('English', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, color: AppColors.textLight, size: 16),
                        ],
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
                    // Reset et retour à la connexion
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Color(0xFFB91C1C), size: 18),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
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
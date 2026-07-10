import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';
import 'login_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: AppColors.textDark),
                  Text('app_title'.tr(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
                      const CircleAvatar(radius: 18, child: Text('AD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              Text('administrator_dashboard'.tr(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1)),
              const SizedBox(height: 4),
              Text('overview_metrics'.tr(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 20),

              // Statistiques Système
              _metricBlock(title: 'Total Users', val: '12,482', badge: '+12%', isPositive: true),
              const SizedBox(height: 12),
              _metricBlock(title: 'Active Pharmacies', val: '843', badge: 'Stable', isPositive: null),
              const SizedBox(height: 12),
              _metricBlock(title: 'Pending Validations', val: '24', badge: 'Urgent', isPositive: false, forceBlue: true),
              const SizedBox(height: 24),

              // Validations de Pharmacies en attente
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('pharmacy_validations'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  TextButton(onPressed: () {}, child: Text('view_all'.tr(), style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 8),
              _validationCard('HealthFirst Pharma', 'License: #PH-99201'),
              _validationCard('City Center Meds', 'License: #PH-44182'),
              _validationCard('Green Leaf Apothecary', 'License: #PH-88273'),
              const SizedBox(height: 24),

              // Activité Récente Système
              Text('recent_activity'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  children: [
                    _activityLog('Dr. Sarah Khalil confirmed a prescription for User #4402.', '2 minutes ago', const Color(0xFF3B82F6)),
                    const Divider(height: 24),
                    _activityLog('Central Pharmacy marked order #8829 as "Ready for Pickup".', '15 minutes ago', const Color(0xFF10B981)),
                    const Divider(height: 24),
                    _activityLog('Admin Panel initiated a system health check.', '42 minutes ago', const Color(0xFFF59E0B)),
                    const Divider(height: 24),
                    _activityLog('New pharmacy Elite Health submitted validation documents.', '1 hour ago', const Color(0xFF3B82F6)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {},
                child: Text('download_log'.tr(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ),
              const SizedBox(height: 24),

              // Croissance & Infrastructure
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('growth_infrastructure'.tr(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    Text('network_expanded'.tr(), style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _infrastructureSpec('99.9%', 'Uptime')),
                        const SizedBox(width: 12),
                        Expanded(child: _infrastructureSpec('1.2s', 'Latency')),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bouton Log out Admin
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFEE2E2)), backgroundColor: const Color(0xFFFEF2F2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                  },
                  child: Text('logout_admin_session'.tr(), style: TextStyle(color: Color(0xFFB91C1C), fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricBlock({
    required String title,
    required String val,
    required String badge,
    required bool? isPositive,
    bool forceBlue = false,
  }) {
    Color bg = Colors.white;
    Color border = const Color(0xFFE2E8F0);
    Color textCol = AppColors.textDark;

    if (forceBlue) {
      bg = const Color(0xFF0062A3);
      border = const Color(0xFF0062A3);
      textCol = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: border)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: forceBlue ? Colors.white70 : AppColors.textLight)),
              const SizedBox(height: 8),
              Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textCol)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive == true
                  ? const Color(0xFFDCFCE7)
                  : isPositive == false
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (isPositive == true) const Icon(Icons.trending_up, size: 12, color: Color(0xFF15803D)),
                if (isPositive == true) const SizedBox(width: 4),
                Text(badge, style: TextStyle(color: isPositive == true ? const Color(0xFF15803D) : isPositive == false ? const Color(0xFFB91C1C) : AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _validationCard(String name, String license) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.storefront_outlined, color: AppColors.primary, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(license, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.primary), onPressed: () {}),
              IconButton(icon: const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF15803D)), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _activityLog(String log, String time, Color bulletColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: BoxDecoration(color: bulletColor, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(log, style: const TextStyle(fontSize: 11, color: AppColors.textDark, height: 1.4)),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
            ],
          ),
        )
      ],
    );
  }

  Widget _infrastructureSpec(String val, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
        ],
      ),
    );
  }
}

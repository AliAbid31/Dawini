import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';

class PharmacyRequests extends StatefulWidget {
  const PharmacyRequests({super.key});

  @override
  State<PharmacyRequests> createState() => _PharmacyRequestsState();
}

class _PharmacyRequestsState extends State<PharmacyRequests> {
  int _selectedFilter = 0; // 0: All, 1: On Hold, 2: Confirmed, 3: Refused

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () {}),
        title: Text('app_name'.tr(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: AppColors.textLight), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('pharmacy_requests'.tr(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text('review_manage'.tr(), style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 24),

              // Métriques des demandes
              Row(
                children: [
                  Expanded(child: _metricHeaderBox('PENDING', '12', const Color(0xFF3B82F6), const Color(0xFFEFF6FF))),
                  const SizedBox(width: 16),
                  Expanded(child: _metricHeaderBox('TODAY', '48', const Color(0xFF10B981), const Color(0xFFECFDF5))),
                ],
              ),
              const SizedBox(height: 24),

              // Boutons de filtres
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(0, 'all_requests'.tr()),
                    const SizedBox(width: 8),
                    _filterChip(1, 'on_hold_filter'.tr()),
                    const SizedBox(width: 8),
                    _filterChip(2, 'confirmed'.tr()),
                    const SizedBox(width: 8),
                    _filterChip(3, 'refuse'.tr()),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Liste de demandes détaillées
              _buildDetailedRequest(
                name: 'Ahmed Mansour',
                time: '2 mins ago • #RQ-8821',
                medicine: 'Amoxicillin 500mg (24 Capsules)',
                state: 'on_hold'.tr(),
                avatarUrl: 'https://i.imgur.com/Cf69I1b.png',
                isActionable: true,
              ),
              _buildDetailedRequest(
                name: 'Sara Ibrahim',
                time: '15 mins ago • #RQ-8819',
                medicine: 'Lisinopril 10mg (30 Tablets)',
                state: 'confirmed'.tr(),
                avatarUrl: 'https://i.imgur.com/Cf69I1b.png',
                isActionable: false,
                isConfirmed: true,
              ),
              _buildDetailedRequest(
                name: 'Omar El-Sayed',
                time: '45 mins ago • #RQ-8815',
                medicine: 'Ventolin Inhaler (100mcg/dose)',
                state: 'on_hold'.tr(),
                avatarUrl: 'https://i.imgur.com/Cf69I1b.png',
                isActionable: true,
              ),
              _buildDetailedRequest(
                name: 'Youssef Ali',
                time: '1 hour ago • #RQ-8812',
                medicine: 'Xanax 0.5mg (Limited Item)',
                state: 'refuse'.tr(),
                avatarUrl: 'https://i.imgur.com/Cf69I1b.png',
                isActionable: false,
                isRefused: true,
                refusalReason: 'Out of stock / Controlled substance',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricHeaderBox(String title, String val, Color textCol, Color bgCol) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgCol, borderRadius: BorderRadius.circular(16), border: Border.all(color: textCol.withValues(alpha: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textCol)),
          const SizedBox(height: 8),
          Text(val, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textCol)),
        ],
      ),
    );
  }

  Widget _filterChip(int index, String label) {
    final bool active = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: TextStyle(color: active ? Colors.white : AppColors.textDark, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildDetailedRequest({
    required String name,
    required String time,
    required String medicine,
    required String state,
    required String avatarUrl,
    required bool isActionable,
    bool isConfirmed = false,
    bool isRefused = false,
    String? refusalReason,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatarUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: Text(state, style: const TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Medicine details block
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.link, size: 12, color: AppColors.textLight),
                    SizedBox(width: 4),
                    Text('Medicine Requested', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(medicine, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (isActionable) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                    onPressed: () {},
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check, size: 14, color: Colors.white), const SizedBox(width: 4), Text('confirm'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))]),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFB91C1C)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {},
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.close, size: 14, color: Color(0xFFB91C1C)), const SizedBox(width: 4), Text('out_of_stock'.tr(), style: const TextStyle(fontSize: 11, color: Color(0xFFB91C1C), fontWeight: FontWeight.bold))]),
                  ),
                ),
              ],
            )
          ] else if (isConfirmed) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF15803D)),
                  SizedBox(width: 6),
                  Text('Order sent to packaging unit', style: TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ] else if (isRefused && refusalReason != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Color(0xFFB91C1C)),
                  const SizedBox(width: 6),
                  Text('${'refuse'.tr()}: $refusalReason', style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}

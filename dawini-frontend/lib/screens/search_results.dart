import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';
import 'confirmation_request.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('app_title'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
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
              Text('results_for'.tr(), style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Panadol 500mg', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  // Segmented switch List / Map
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                           child: Row(
                            children: [
                              Icon(Icons.list, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('list'.tr(), style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                           child: Row(
                            children: [
                              Icon(Icons.map_outlined, color: AppColors.textLight, size: 14),
                              SizedBox(width: 4),
                              Text('map'.tr(), style: TextStyle(color: AppColors.textLight, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Jetons de filtres complémentaires
              Row(
                children: [
                  _quickBadge('Nearest First', true),
                  const SizedBox(width: 8),
                  _quickBadge('Stock: Most Available', false),
                  const SizedBox(width: 8),
                  _quickBadge('24/7 Only', false),
                ],
              ),
              const SizedBox(height: 24),

              // Pharmacies proposant l'item
              _buildPharmacyResult(
                context,
                name: 'El Ezaby Pharmacy',
                details: '0.8 km • Maadi, Cairo',
                status: 'In Stock',
                statusColor: const Color(0xFF15803D),
                statusBg: const Color(0xFFDCFCE7),
                actionText: 'Request Availability',
              ),
              _buildPharmacyResult(
                context,
                name: 'Misr Pharmacy',
                details: '1.2 km • Degla, Maadi',
                status: 'Weak Stock',
                statusColor: const Color(0xFFD97706),
                statusBg: const Color(0xFFFEF3C7),
                actionText: 'Request Availability',
              ),
              _buildPharmacyResult(
                context,
                name: 'Seif Pharmacies',
                details: '2.5 km • New Maadi',
                status: 'Unavailable',
                statusColor: const Color(0xFFB91C1C),
                statusBg: const Color(0xFFFEE2E2),
                actionText: 'Notify Me',
                isBtnDisabled: true,
              ),
              const SizedBox(height: 24),

              // Bannière promotionnelle (Plus)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0284C7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('need_faster_delivery'.tr(), style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('subscribe_plus'.tr(), style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text('get_started'.tr(), style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickBadge(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? AppColors.primary : const Color(0xFFE2E8F0)),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? AppColors.primary : AppColors.textLight)),
    );
  }

  Widget _buildPharmacyResult(
      BuildContext context, {
        required String name,
        required String details,
        required String status,
        required Color statusColor,
        required Color statusBg,
        required String actionText,
        bool isBtnDisabled = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.local_hospital_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(details, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isBtnDisabled ? 'Next restock expected in 2 days' : status,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isBtnDisabled ? AppColors.textLight : statusColor),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBtnDisabled ? const Color(0xFFE2E8F0) : AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmationRequest()));
                },
                child: Row(
                  children: [
                    Text(actionText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isBtnDisabled ? AppColors.textDark : Colors.white)),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 14, color: isBtnDisabled ? AppColors.textDark : Colors.white),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MedicineStockAlerts extends StatelessWidget {
  const MedicineStockAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () {}),
        title: const Text('Dawini', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
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
              const Text('Medicine Stock Alerts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('We\'ll notify you as soon as these medications are back in stock at your selected pharmacies.', style: TextStyle(fontSize: 12, color: AppColors.textLight, height: 1.4)),
              const SizedBox(height: 24),

              _alertCard(
                name: 'Insulin Glargine',
                description: 'Lantus Solostar • 100U/mL',
                pharmacy: 'CareFirst Pharmacy - Downtown',
                date: 'Set on Oct 12, 2023',
                isActive: true,
              ),
              _alertCard(
                name: 'Augmentin 625mg',
                description: 'Amoxicillin/Clavulanate',
                pharmacy: 'HealthPlus Medical Store',
                date: 'In Stock Now',
                isActive: false,
                isAvailable: true,
              ),
              _alertCard(
                name: 'Ventolin Inhaler',
                description: 'Salbutamol 100mcg',
                pharmacy: 'Any available pharmacy',
                date: 'Set on Sep 28, 2023',
                isActive: true,
              ),
              const SizedBox(height: 24),

              // Aide de traçabilité
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.notification_add_outlined, color: AppColors.textLight, size: 28),
                    const SizedBox(height: 12),
                    const Text('Need to track another medicine?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    const Text('Add a new alert from the search screen.', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () {}, child: const Text('Search Medicines', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold))),
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

  Widget _alertCard({
    required String name,
    required String description,
    required String pharmacy,
    required String date,
    required bool isActive,
    bool isAvailable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isAvailable ? const Color(0xFF2ECC71) : const Color(0xFFE2E8F0), width: isAvailable ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.notifications_active_outlined, color: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(description, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: isAvailable ? const Color(0xFFDCFCE7) : const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(6)),
                child: Text(isAvailable ? 'In Stock Now' : 'Alert Active', style: TextStyle(color: isAvailable ? const Color(0xFF15803D) : AppColors.primary, fontSize: 8, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.storefront, size: 12, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text(pharmacy, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
            ],
          ),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
          if (isAvailable) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                    onPressed: () {},
                    child: const Text('Request Availability', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {},
                    child: const Text('Get Directions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ),
                ),
              ],
            )
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.notifications_off_outlined, color: Color(0xFFB91C1C), size: 12),
                      SizedBox(width: 2),
                      Text('Cancel Alert', style: TextStyle(fontSize: 10, color: Color(0xFFB91C1C), fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            )
          ]
        ],
      ),
    );
  }
}
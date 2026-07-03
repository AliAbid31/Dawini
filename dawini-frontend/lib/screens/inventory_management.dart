import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'add_edit_stock.dart';

class InventoryManagement extends StatelessWidget {
  const InventoryManagement({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inventory Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Manage stock levels and medicine availability for your pharmacy.', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 24),

              // Barre de recherche
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search medicines, salts, or brands...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                ),
              ),
              const SizedBox(height: 24),

              // Métriques d'inventaire
              Row(
                children: [
                  Expanded(child: _metricBox('TOTAL ITEMS', '1,284', null)),
                  const SizedBox(width: 16),
                  Expanded(child: _metricBox('LOW STOCK', '12', Icons.warning_amber_rounded)),
                ],
              ),
              const SizedBox(height: 24),

              // Liste d'inventaire
              _inventoryRow(context, 'Amoxicillin 500mg', 'Capsule • 420 units', 'AVAILABLE', const Color(0xFF15803D), const Color(0xFFDCFCE7)),
              _inventoryRow(context, 'Paracetamol Syrup', 'Liquid • 18 units', 'WEAK STOCK', const Color(0xFFD97706), const Color(0xFFFEF3C7)),
              _inventoryRow(context, 'Metformin 850mg', 'Tablet • 0 units', 'UNAVAILABLE', const Color(0xFFB91C1C), const Color(0xFFFEE2E2)),
              _inventoryRow(context, 'Lisinopril 10mg', 'Tablet • 85 units', 'AVAILABLE', const Color(0xFF15803D), const Color(0xFFDCFCE7)),
              _inventoryRow(context, 'Inhaler Ventolin', 'Aerosol • 52 units', 'AVAILABLE', const Color(0xFF15803D), const Color(0xFFDCFCE7)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditStock()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _metricBox(String label, String value, IconData? alertIcon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              if (alertIcon != null) ...[
                const SizedBox(width: 6),
                Icon(alertIcon, color: const Color(0xFFB91C1C), size: 18),
              ]
            ],
          )
        ],
      ),
    );
  }

  Widget _inventoryRow(BuildContext context, String name, String details, String badge, Color color, Color bg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.medication, color: AppColors.primary, size: 22)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
                child: Text(badge, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditStock()));
                },
                child: const Row(
                  children: [
                    Text('Edit', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                    SizedBox(width: 2),
                    Icon(Icons.edit, size: 10, color: AppColors.primary),
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

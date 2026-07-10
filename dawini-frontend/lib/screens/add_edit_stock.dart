import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';

class AddEditStock extends StatefulWidget {
  const AddEditStock({super.key});

  @override
  State<AddEditStock> createState() => _AddEditStockState();
}

class _AddEditStockState extends State<AddEditStock> {
  int _selectedStatus = 0; // 0: Available, 1: Weak Stock, 2: Unavailable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: Text('edit_inventory_title'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
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
              // Header descriptif
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.library_books, color: AppColors.primary)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('medicine_details_title'.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text('medicine_details_desc'.tr(), style: const TextStyle(fontSize: 11, color: AppColors.textLight, height: 1.4)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Champ Nom
              _label('medicine_name'.tr()),
              TextField(
                decoration: InputDecoration(
                  hintText: 'medicine_name_hint'.tr(),
                  prefixIcon: const Icon(Icons.search, size: 20),
                ),
              ),
              const SizedBox(height: 16),

              // Sélecteur Catégorie
              _label('category'.tr()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: 'Analgesics',
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
                    items: <String>['Analgesics', 'Antibiotics', 'Antivirals', 'Cardiology'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textDark)));
                    }).toList(),
                    onChanged: (val) {},
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Statut d'inventaire
              _label('current_stock_status'.tr()),
              _statusOption(0, Icons.check_circle, 'available'.tr(), 'high_priority'.tr(), const Color(0xFF15803D), const Color(0xFFDCFCE7), const Color(0xFFE5F1FB)),
              _statusOption(1, Icons.warning, 'weak_stock'.tr(), 'reorder_soon'.tr(), const Color(0xFFD97706), const Color(0xFFFEF3C7), const Color(0xFFFFF7ED)),
              _statusOption(2, Icons.cancel, 'unavailable'.tr(), 'out_of_stock'.tr(), const Color(0xFFB91C1C), const Color(0xFFFEE2E2), const Color(0xFFFEF2F2)),
              const SizedBox(height: 16),

              // Notes complémentaires
              _label('additional_notes'.tr()),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'shelf_location_hint'.tr(),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton enregistrer
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_outlined, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('save_changes'.tr(), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Conseil d'intégrité
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('inventory_integrity'.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 8),
                    Text('inventory_integrity_desc'.tr(), style: const TextStyle(fontSize: 11, color: AppColors.textLight, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark)),
    );
  }

  Widget _statusOption(int index, IconData icon, String label, String tag, Color activeColor, Color tagBg, Color bg) {
    final bool isSelected = _selectedStatus == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? bg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? activeColor : const Color(0xFFE2E8F0), width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: activeColor, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(8)),
              child: Text(tag, style: TextStyle(color: activeColor, fontSize: 8, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

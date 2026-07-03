import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';
import 'confirmation_request.dart';

class PharmacyDetails extends StatelessWidget {
  const PharmacyDetails({super.key});

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
        title: Text('app_name'.tr(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textLight),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profil Header de la pharmacie
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(color: const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.local_pharmacy, color: AppColors.primary, size: 30),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('HealthCare Central Pharmacy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                SizedBox(height: 4),
                                Text('241 Nile Corniche, Maadi', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                              ],
                            ),
                          ),
                          const CircleAvatar(backgroundColor: AppColors.primary, radius: 14, child: Icon(Icons.verified, color: Colors.white, size: 14))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Horaires d'ouverture
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: AppColors.primary, size: 18),
                                  const SizedBox(width: 8),
                                  Text('opening_hours'.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                                child: Text('in_stock'.tr(), style: const TextStyle(color: Color(0xFF15803D), fontSize: 9, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          _timeRow('Mon - Sat', '09:00 AM - 11:00 PM'),
                          const SizedBox(height: 8),
                          _timeRow('Sunday', '10:00 AM - 08:00 PM'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Boutons de contact
                    Row(
                      children: [
                        Expanded(child: _actionButton(Icons.phone, 'call'.tr(), '+20 123 456 7890')),
                        const SizedBox(width: 16),
                        Expanded(child: _actionButton(Icons.star, 'reviews'.tr(), '120+ ratings')),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Liste de produits disponibles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('available_medicines'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const Text('3 items found', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _medicineItem('Amoxicillin 500mg', 'Capsules • 20 Units', 'IN STOCK', const Color(0xFF15803D), const Color(0xFFDCFCE7)),
                    _medicineItem('Panadol Extra', 'Tablets • 24 Units', 'IN STOCK', const Color(0xFF15803D), const Color(0xFFDCFCE7)),
                    _medicineItem('Betadine Ointment', 'Topical • 20g', 'OUT OF STOCK', const Color(0xFFB91C1C), const Color(0xFFFEE2E2)),
                  ],
                ),
              ),
            ),
            // Bouton permanent de bas de page
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmationRequest()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text('send_availability_request'.tr(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _timeRow(String day, String hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        Text(hours, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ],
    );
  }

  Widget _actionButton(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
        ],
      ),
    );
  }

  Widget _medicineItem(String name, String details, String stock, Color color, Color bg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.medication, color: AppColors.primary, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(details, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
            child: Text(stock, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

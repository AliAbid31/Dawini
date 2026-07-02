import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'patient_shell.dart';

class ConfirmationRequest extends StatelessWidget {
  const ConfirmationRequest({super.key});

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
              const Text('Confirmation Request', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 4),
              const Text('Secure Availability', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 24),

              // Carte de détails de demande
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Atorvastatin 20mg', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              SizedBox(height: 4),
                              Text('Quantity: 30 Tablets', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: Color(0xFFE2E8F0)),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.storefront, color: AppColors.primary, size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pharmacy', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                              SizedBox(height: 2),
                              Text('City Health Pharmacy Center', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Avertissement d'usage
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9))),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'By sending this request, the pharmacy will check their current stock and notify you of availability.',
                              style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bouton Envoi
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Redirection vers le gestionnaire d'onglets (My Requests)
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const PatientShell(initialTab: 2)),
                                (route) => false,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Request Availability', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(width: 8),
                            Icon(Icons.send_outlined, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.primary, fontSize: 12))),
                ],
              ),
              _recentItem('Amoxicillin 500mg', 'Metro Pharma', 'To be confirmed', const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
              _recentItem('Lisinopril 10mg', 'Green Cross Clinic', 'Confirmed', const Color(0xFF10B981), const Color(0xFFECFDF5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentItem(String name, String pharmacy, String state, Color color, Color bg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          const Icon(Icons.medication, color: AppColors.textLight),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(pharmacy, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Text(state, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
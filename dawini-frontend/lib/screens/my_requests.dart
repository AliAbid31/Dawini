import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  int _selectedFilter = 0; // 0: All, 1: Pending, 2: Completed

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Requests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Track your medication orders and pharmacy updates.', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 20),

              // Segmented Control de tri
              Row(
                children: [
                  _filterButton(0, 'All Requests'),
                  const SizedBox(width: 8),
                  _filterButton(1, 'Pending'),
                  const SizedBox(width: 8),
                  _filterButton(2, 'Completed'),
                ],
              ),
              const SizedBox(height: 24),

              // Liste verticale des demandes
              _buildDetailedRequest(
                medicine: 'Amoxicillin 500mg',
                pharmacy: 'CarePlus Pharmacy',
                status: 'Available',
                statusColor: const Color(0xFF15803D),
                statusBg: const Color(0xFFDCFCE7),
                answer: 'Ready for pickup at 4 PM today. Please bring your original prescription.',
                date: 'Oct 24, 2023',
                actionText: 'View Details',
              ),
              _buildDetailedRequest(
                medicine: 'Lisinopril 10mg',
                pharmacy: 'Green Cross Medical',
                status: 'On Hold',
                statusColor: const Color(0xFFD97706),
                statusBg: const Color(0xFFFEF3C7),
                answer: 'Waiting for insurance verification. Estimated update in 2 hours.',
                date: 'Oct 23, 2023',
                actionText: 'Inquire About Stock',
              ),
              _buildDetailedRequest(
                medicine: 'Atorvastatin 20mg',
                pharmacy: 'City Life Pharmacy',
                status: 'Unavailable',
                statusColor: const Color(0xFFB91C1C),
                statusBg: const Color(0xFFFEE2E2),
                answer: 'Out of stock. We can order this for you by Friday or suggest alternatives.',
                date: 'Oct 22, 2023',
                actionText: 'Check Other Pharmacies',
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text('End of recent history', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton(int index, String label) {
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
    required String medicine,
    required String pharmacy,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required String answer,
    required String date,
    required String actionText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFE5F1FB), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.healing, color: AppColors.primary, size: 18)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(medicine, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(pharmacy, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          // Section message de l'officine
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info, size: 14, color: statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PHARMACY ANSWER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor)),
                      const SizedBox(height: 4),
                      Text(answer, style: const TextStyle(fontSize: 11, color: AppColors.textDark, height: 1.4)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [const Icon(Icons.calendar_today, size: 12, color: AppColors.textLight), const SizedBox(width: 4), Text(date, style: const TextStyle(fontSize: 10, color: AppColors.textLight))]),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: Text(actionText, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
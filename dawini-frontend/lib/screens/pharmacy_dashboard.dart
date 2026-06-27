import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'medicine_stock_alerts.dart';
import 'pharmacy_shell.dart';

class PharmacyDashboard extends StatelessWidget {
  const PharmacyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: AppColors.textDark),
                  const Text('Dawini', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
                      const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.imgur.com/Cf69I1b.png')),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              const Text('Welcome back, Central Pharma', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text('Here is what\'s happening today at your branch.', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 24),

              // Cartes de synthèse d'activité
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'Pending Requests',
                      value: '12',
                      actionText: 'View all ->',
                      icon: Icons.assignment_outlined,
                      onTap: () {
                        final shellState = context.findAncestorStateOfType<PharmacyShellState>();
                        shellState?.switchTab(2);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: 'Inventory Health',
                      value: '94%',
                      statusText: 'OPTIMAL',
                      statusColor: const Color(0xFF15803D),
                      statusBg: const Color(0xFFDCFCE7),
                      icon: Icons.inventory_2_outlined,
                      onTap: () {
                        final shellState = context.findAncestorStateOfType<PharmacyShellState>();
                        shellState?.switchTab(1);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Graphe d'activité
              _buildChartCard(),
              const SizedBox(height: 24),

              // New Requests Quick List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('New Requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  TextButton(
                    onPressed: () {
                      final shellState = context.findAncestorStateOfType<PharmacyShellState>();
                      shellState?.switchTab(2);
                    },
                    child: const Text('Review All', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              _quickRequestRow('Amoxicillin 500mg', 'Order #9823 • 2m ago', Icons.medication_outlined),
              _quickRequestRow('Lisinopril 10mg', 'Order #9821 • 15m ago', Icons.healing_outlined),
              const SizedBox(height: 24),

              // Alertes d'inventaire
              const Text('Inventory Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 12),
              _buildInventoryAlertBox(context),
              const SizedBox(height: 24),

              // Section Activité Récente
              const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              _buildTimelineRow('Batch order #9810 fulfilled', '1 hour ago', true),
              _buildTimelineRow('Wholesale shipment received', '3 hours ago', false),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // Floating QR/Scanner
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    String? actionText,
    String? statusText,
    Color? statusColor,
    Color? statusBg,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            if (actionText != null)
              Text(actionText, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
            if (statusText != null && statusBg != null && statusColor != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold)),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TODAY\'S ACTIVITY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('45 Fulfilled', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text('+8% from yesterday', style: TextStyle(fontSize: 10, color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                ],
              ),
              // Mini histogramme simulé
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _chartBar(12, false),
                  _chartBar(18, false),
                  _chartBar(28, false),
                  _chartBar(22, false),
                  _chartBar(35, true),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chartBar(double height, bool active) {
    return Container(
      width: 8,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _quickRequestRow(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.primary, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight, size: 18)
        ],
      ),
    );
  }

  Widget _buildInventoryAlertBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFB91C1C), size: 18),
                  SizedBox(width: 8),
                  Text('3 items low in stock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C))),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicineStockAlerts()));
                },
                child: const Text('Restock', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Divider(height: 24, color: Color(0xFFE2E8F0)),
          _alertItem('Metformin 850mg', '5 units left'),
          const SizedBox(height: 8),
          _alertItem('Atorvastatin 20mg', '2 units left'),
        ],
      ),
    );
  }

  Widget _alertItem(String name, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C))),
      ],
    );
  }

  Widget _buildTimelineRow(String title, String subtitle, bool isFirst) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2),
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.check, size: 12, color: AppColors.primary),
            ),
            if (!isFirst)
              Container(width: 2, height: 30, color: const Color(0xFFE2E8F0)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
              const SizedBox(height: 12),
            ],
          ),
        )
      ],
    );
  }
}
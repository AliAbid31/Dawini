import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'pharmacy_dashboard.dart';
import 'inventory_management.dart';
import 'pharmacy_requests.dart';
import 'medicine_stock_alerts.dart';

class PharmacyShell extends StatefulWidget {
  final int initialTab;
  const PharmacyShell({super.key, this.initialTab = 0});

  @override
  State<PharmacyShell> createState() => PharmacyShellState();
}

class PharmacyShellState extends State<PharmacyShell> {
  late int _currentIndex;

  final List<Widget> _tabs = [
    const PharmacyDashboard(),
    const InventoryManagement(),
    const PharmacyRequests(),
    const MedicineStockAlerts(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
            _buildNavItem(1, Icons.inventory_2_outlined, Icons.inventory_2, 'Inventory'),
            _buildNavItem(2, Icons.assignment_outlined, Icons.assignment, 'Requests'),
            _buildNavItem(3, Icons.notifications_none, Icons.notifications, 'Alerts'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData solidIcon, String label) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => switchTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8EFF8E).withValues(alpha: 0.4) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              color: isSelected ? const Color(0xFF137C3F) : AppColors.textLight,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF137C3F) : AppColors.textLight,
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PharmacyDashboard extends StatefulWidget {
  const PharmacyDashboard({super.key});

  @override
  State<PharmacyDashboard> createState() => _PharmacyDashboardState();
}

class _PharmacyDashboardState extends State<PharmacyDashboard> {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
  bool _isLoading = true;
  int _pendingCount = 0;
  int _lowStockCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardMetrics();
  }

  void _fetchDashboardMetrics() async {
    final supabase = _supabase;
    final user = supabase?.auth.currentUser;
    if (user != null) {
      try {
        final pharmacyRes = await supabase!.from('pharmacies').select('id').eq('owner_id', user.id).single();
        final String pharmacyId = pharmacyRes['id'];

        final pendingRes = await supabase.from('requests').select('id').eq('pharmacy_id', pharmacyId).eq('status', 'PENDING');
        final lowStockRes = await supabase.from('inventory').select('id').eq('pharmacy_id', pharmacyId).eq('status', 'WEAK_STOCK');

        setState(() {
          _pendingCount = pendingRes.length;
          _lowStockCount = lowStockRes.length;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('welcome_pharma'.tr(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _metricCard('pending_requests'.tr(), _pendingCount.toString(), Icons.assignment_outlined)),
                  const SizedBox(width: 16),
                  Expanded(child: _metricCard('inventory_alerts'.tr(), _lowStockCount.toString(), Icons.warning_amber_rounded)),
                ],
              ),
              const SizedBox(height: 24),
              _activitySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0062A3), size: 24),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _activitySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('todays_activity'.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('completed_count'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Text('vs_yesterday'.tr(), style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}

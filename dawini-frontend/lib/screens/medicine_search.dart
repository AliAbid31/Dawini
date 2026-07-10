import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';
import 'medicine_details.dart';
import '../core/api/api_client.dart';
import 'pharmacy_map_view.dart';

class MedicineSearch extends StatefulWidget {
  const MedicineSearch({super.key});

  @override
  State<MedicineSearch> createState() => _MedicineSearchState();
}

class _MedicineSearchState extends State<MedicineSearch> {
  final TextEditingController _searchController = TextEditingController(text: 'Panadol');

  List medicines = [];
  bool isLoading = false;

  Future<void> searchMedicine(String query) async {
    setState(() => isLoading = true);

    final res = await ApiClient.client.get(
      "/patients/medicines/search",
      queryParameters: {"query": query},
    );

    setState(() {
      medicines = res.data["results"];
      isLoading = false;
    });
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('find_your_medicine'.tr(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),

              // Barre de saisie
              TextField(
                controller: _searchController,
                onSubmitted: (value) => searchMedicine(value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textLight, size: 18),
                    onPressed: () => _searchController.clear(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filtres rapides
              Row(
                children: [
                  _filterChip(Icons.location_on, 'Near Me', true),
                  const SizedBox(width: 8),
                  _filterChip(Icons.access_time, '24-Hour', false),
                  const SizedBox(width: 8),
                  _filterChip(Icons.security, 'Insurance', false),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('available_results'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  Text('pharmacies_found'.tr(), style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                ],
              ),
              const SizedBox(height: 16),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (medicines.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('no_medicines_found'.tr(), style: TextStyle(color: AppColors.textLight)),
                )
              else
                ...medicines.map((m) {
                  return _buildMedicineResultCard(
                    name: m["name"] ?? "",
                    pharmacy: m["pharmacy"] ?? "Nearby pharmacy",
                    status: m["status"] ?? "In Stock",
                    subStatus: m["sub_status"] ?? "Insurance OK",
                    statusColor: const Color(0xFF15803D),
                    statusBg: const Color(0xFFDCFCE7),
                    medicineId: m["id"]?.toString() ?? '',
                  );
                }),
              const SizedBox(height: 24),

              // Bloc carte géographique
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('pharmacies_nearby_title'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PharmacyMapView()));
                    },
                    child: Text('view_on_map'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              _buildStaticMapCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(IconData icon, String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: selected ? Colors.white : AppColors.textDark),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selected ? Colors.white : AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildMedicineResultCard({
    required String name,
    required String pharmacy,
    required String status,
    required String subStatus,
    required Color statusColor,
    required Color statusBg,
    required String medicineId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineDetails(id: medicineId)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text(pharmacy, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                        child: Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(6)),
                        child: Text(subStatus, style: const TextStyle(color: AppColors.textDark, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticMapCard() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://i.imgur.com/39QOskD.png'),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10)]),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: Color(0xFFE5F1FB), shape: BoxShape.circle),
                child: const Icon(Icons.directions_walk, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('pharmacies_found'.tr(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    SizedBox(height: 2),
                    Text('within_10_mins'.tr(), style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PharmacyMapView()));
                },
                child: Text('view_on_map'.tr(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

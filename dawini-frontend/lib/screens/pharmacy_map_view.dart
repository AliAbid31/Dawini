import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/app_colors.dart';

class PharmacyMapView extends StatelessWidget {
  final List<Map<String, dynamic>> pharmacies;

  const PharmacyMapView({super.key, this.pharmacies = const []});

  @override
  Widget build(BuildContext context) {
    final center = pharmacies.isNotEmpty
        ? LatLng(
            (pharmacies.first['lat'] ?? 48.8566) as double,
            (pharmacies.first['lng'] ?? 2.3522) as double,
          )
        : const LatLng(48.8566, 2.3522);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('nearby_pharmacies_title'.tr(), style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 13,
          maxZoom: 19,
          minZoom: 3,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.dawini.app',
          ),
          MarkerLayer(
            markers: pharmacies.map((p) {
              return Marker(
                point: LatLng(
                  (p['lat'] ?? 48.8566) as double,
                  (p['lng'] ?? 2.3522) as double,
                ),
                width: 120,
                height: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_hospital, color: AppColors.primary, size: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                      ),
                      child: Text(
                        p['name'] ?? 'Pharmacy',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

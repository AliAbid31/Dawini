import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/services/location_service.dart';
import '../core/constants/app_colors.dart';

class LocationPickerResult {
  final double latitude;
  final double longitude;
  final String address;

  const LocationPickerResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();
  final FocusNode _searchFocus = FocusNode();

  late double _selectedLat;
  late double _selectedLng;
  String _selectedAddress = '';
  List<LocatedAddress> _suggestions = [];
  bool _isSearching = false;
  bool _isLoadingAddress = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selectedLat = widget.initialLatitude ?? 48.8566;
    _selectedLng = widget.initialLongitude ?? 2.3522;
    _selectedAddress = widget.initialAddress ?? '';
    _searchController.text = _selectedAddress;
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.length < 3) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isSearching = true);
      try {
        final results = await _locationService.searchPlaces(query);
        if (mounted) setState(() => _suggestions = results);
      } catch (_) {
      } finally {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  void _selectLocation(double lat, double lng, String address) {
    setState(() {
      _selectedLat = lat;
      _selectedLng = lng;
      _selectedAddress = address;
      _searchController.text = address;
      _suggestions = [];
    });
    _searchFocus.unfocus();
    _mapController.move(LatLng(lat, lng), 16);
  }

  Future<void> _onMapTap(TapPosition tapPosition, LatLng latLng) async {
    setState(() {
      _selectedLat = latLng.latitude;
      _selectedLng = latLng.longitude;
      _selectedAddress = '${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}';
      _suggestions = [];
    });
    _searchFocus.unfocus();

    setState(() => _isLoadingAddress = true);
    try {
      final addr = await _locationService.reverseGeocode(latLng.latitude, latLng.longitude);
      if (mounted) {
        setState(() {
          _selectedAddress = addr.displayName;
          _searchController.text = addr.displayName;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingAddress = true);
    try {
      final loc = await _locationService.getCurrentAddress();
      if (mounted) {
        _selectLocation(loc.latitude, loc.longitude, loc.displayName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  void _confirm() {
    Navigator.pop(context, LocationPickerResult(
      latitude: _selectedLat,
      longitude: _selectedLng,
      address: _selectedAddress,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('select_location'.tr(), style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _selectedAddress.isEmpty ? null : _confirm,
            child: Text('confirm'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'search_address_hint'.tr(),
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
                        prefixIcon: Icon(_isLoadingAddress ? null : Icons.search, color: AppColors.textLight, size: 20),
                        suffixIcon: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                              )
                            : _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18, color: AppColors.textLight),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _suggestions = []);
                                    },
                                  )
                                : null,
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _useCurrentLocation,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.my_location, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          if (_suggestions.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              color: Colors.white,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final s = _suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                    title: Text(
                      s.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 16, color: AppColors.textLight),
                    onTap: () => _selectLocation(s.latitude, s.longitude, s.displayName),
                  );
                },
              ),
            ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(_selectedLat, _selectedLng),
                initialZoom: 13,
                maxZoom: 19,
                minZoom: 3,
                onTap: _onMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.dawini.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_selectedLat, _selectedLng),
                      width: 80,
                      height: 80,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 44),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_selectedAddress.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedAddress,
                      style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _selectedAddress.isEmpty ? null : _confirm,
                  child: Text('confirm_location'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

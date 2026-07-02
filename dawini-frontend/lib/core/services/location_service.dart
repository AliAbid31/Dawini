import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class LocatedAddress {
  final double latitude;
  final double longitude;
  final String displayName;

  const LocatedAddress({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });
}

class LocationService {
  LocationService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<LocatedAddress> getCurrentAddress() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('La permission de localisation a été refusée.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('La permission de localisation est bloquée dans les paramètres.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    final response = await _dio.get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'format': 'jsonv2',
        'lat': position.latitude,
        'lon': position.longitude,
        'addressdetails': 1,
      },
      options: Options(
        headers: const {
          'User-Agent': 'DawiniApp/1.0 (flutter)',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    final displayName = (data['display_name'] as String?)?.trim();

    return LocatedAddress(
      latitude: position.latitude,
      longitude: position.longitude,
      displayName: displayName == null || displayName.isEmpty
          ? '${position.latitude}, ${position.longitude}'
          : displayName,
    );
  }
}
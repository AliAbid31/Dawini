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

    return reverseGeocode(position.latitude, position.longitude);
  }

  Future<LocatedAddress> reverseGeocode(double latitude, double longitude) async {
    final response = await _dio.get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'format': 'jsonv2',
        'lat': latitude,
        'lon': longitude,
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
      latitude: latitude,
      longitude: longitude,
      displayName: displayName == null || displayName.isEmpty
          ? '$latitude, $longitude'
          : displayName,
    );
  }

  Future<List<LocatedAddress>> searchPlaces(String query) async {
    final response = await _dio.get(
      'https://nominatim.openstreetmap.org/search',
      queryParameters: {
        'q': query,
        'format': 'jsonv2',
        'addressdetails': 1,
        'limit': 10,
      },
      options: Options(
        headers: const {
          'User-Agent': 'DawiniApp/1.0 (flutter)',
          'Accept': 'application/json',
        },
      ),
    );

    final List data = response.data as List;
    return data.map((item) {
      return LocatedAddress(
        latitude: double.parse(item['lat']),
        longitude: double.parse(item['lon']),
        displayName: item['display_name'] ?? '',
      );
    }).toList();
  }
}

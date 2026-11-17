
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// Error message for location problems
class LocationException implements Exception {
  final String message;

  const LocationException(this.message);

  @override
  String toString() => message;
}

// Handles requests for the device's location
class LocationService {
  Future<LatLng> getCurrentLocation() async {
    // 1. Check whether location services are enabled
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(
        'location is turned off on this device',
      );
    }

    // 2. Check location permission
    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'location permission was denied',
      );
    }

    // 3. Get the current position
    final Position position =
        await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        timeLimit: Duration(seconds: 10),
      ),
    );

    // Convert Position into LatLng
    return LatLng(
      position.latitude,
      position.longitude,
    );
  }
}

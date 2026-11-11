
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/attraction.dart';

class SpookyMap extends StatelessWidget {
  const SpookyMap({super.key, this.attractions = const []});

// The haunts to display on the map
final List<Attraction> attractions;

  // Example starting location: Denver, Colorado.
  // Replace with your school's coordinates in Step 6.
  static const LatLng homeBase = LatLng(39.51719, -104.761720);
  IconData _iconFor(AttractionType type) {
  return switch (type) {
    AttractionType.hauntedHouse => Icons.cottage,
    AttractionType.pumpkinPatch => Icons.agriculture,
    AttractionType.cornMaze => Icons.grass,
  };
}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 300,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: colorScheme.outline,
        ),
      ),
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: homeBase,
          initialZoom: 13,
          minZoom: 3,
          maxZoom: 18,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all &
                ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.spooky_find',
            tileBuilder: isDark ? darkModeTileBuilder : null,
          ),
          // One pin for every haunt
MarkerLayer(
  markers: [
    for (final attraction in attractions)
      Marker(
        point: attraction.location,
        width: 40,
        height: 40,
        child: Tooltip(
          message: attraction.name,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: colorScheme.surface,
              ),
            ),
            child: Icon(
              _iconFor(attraction.type),
              color: colorScheme.onPrimary,
              size: 22,
            ),
          ),
        ),
      ),
  ],
),
          const SimpleAttributionWidget(
            source: Text('OpenStreetMap contributors'),
          ),
        ],
      ),
    );
  }
}

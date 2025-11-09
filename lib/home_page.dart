import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  double _zoom = 15.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _determinePositionAndMove();
  }

  Future<void> _determinePositionAndMove() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _loading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _loading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _loading = false);
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    _currentLocation = LatLng(pos.latitude, pos.longitude);

    _mapController.move(_currentLocation!, _zoom);
    setState(() => _loading = false);
  }

  void _centerToCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final latlng = LatLng(pos.latitude, pos.longitude);
      _mapController.move(latlng, 17.0);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الخريطة'), centerTitle: true),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? LatLng(31.9454, 35.9284),
              initialZoom: _zoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    '© OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),

          Center(
            child: IgnorePointer(
              ignoring: true,
              child: const Icon(
                Icons.location_on,
                size: 54,
                color: Colors.orange,
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 24,
            child: FloatingActionButton.extended(
              onPressed: () {
                final center = _mapController.camera.center;
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('الموقع المختار'),
                    content: Text(
                      'lat: ${center.latitude.toStringAsFixed(6)}\n'
                      'lng: ${center.longitude.toStringAsFixed(6)}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('حسناً'),
                      ),
                    ],
                  ),
                );
              },
              label: const Text('تأكيد الموقع'),
              icon: const Icon(Icons.check),
            ),
          ),

          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: _centerToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),

          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

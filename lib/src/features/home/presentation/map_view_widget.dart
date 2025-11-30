import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_ease/src/features/home/domain/service_center_model.dart';

class MapViewWidget extends StatefulWidget {
  final List<ServiceCenter> serviceCenters;

  const MapViewWidget({super.key, required this.serviceCenters});

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  final LatLng _initialPosition =
      const LatLng(37.7749, -122.4194); // San Francisco

  Set<Marker> _createMarkers() {
    return widget.serviceCenters.map((center) {
      return Marker(
        markerId: MarkerId(center.id),
        position: LatLng(center.latitude, center.longitude),
        infoWindow: InfoWindow(
          title: center.name,
          snippet: center.address,
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 12,
      ),
      markers: _createMarkers(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}

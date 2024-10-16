import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class OrderTrackingScreen extends StatefulWidget {
  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  BitmapDescriptor? truckIcon;
  LatLng driverLocation = LatLng(-19.4517, 29.8167); // Initial driver location (Gweru)
  LatLng destinationLocation = LatLng(-17.8292, 31.0522); // Harare as an example destination
  String estimatedTime = "30 minutes";

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)),
      'assets/truck_icon.png',
    ).then((onValue) {
      truckIcon = onValue;
    });
    _addMajorCities();
    _simulateDriverMovement();
  }

  void _addMajorCities() {
    final cities = [
      {"name": "Harare", "lat": -17.8292, "lng": 31.0522},
      {"name": "Bulawayo", "lat": -20.1325, "lng": 28.6266},
      {"name": "Mutare", "lat": -18.9707, "lng": 32.6709},
      {"name": "Gweru", "lat": -19.4517, "lng": 29.8167},
      {"name": "Kwekwe", "lat": -18.9281, "lng": 29.8149},
    ];

    for (var city in cities) {
      _markers.add(Marker(
        markerId: MarkerId(city["name"] as String),
        position: LatLng(city["lat"] as double, city["lng"] as double),
        infoWindow: InfoWindow(title: city["name"] as String),
      ));
    }
  }
  void _simulateDriverMovement() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        driverLocation = LatLng(
          driverLocation.latitude + (destinationLocation.latitude - driverLocation.latitude) / 10,
          driverLocation.longitude + (destinationLocation.longitude - driverLocation.longitude) / 10,
        );
        updateMarkerPosition(driverLocation);
        _updatePolyline();
      });
    });
  }

  void _updatePolyline() {
    _polylines.clear();
    _polylines.add(Polyline(
      polylineId: PolylineId("route"),
      color: Colors.blue,
      points: [driverLocation, destinationLocation],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track Your Order')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(-19.4517, 29.8167), // Gweru, Zimbabwe
                zoom: 7,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated Time: $estimatedTime', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Start: Gweru', style: TextStyle(fontSize: 16)),
                Text('Destination: Harare', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateMarkerPosition(LatLng position) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId == MarkerId('driver_location'));
      _markers.add(Marker(
        markerId: MarkerId('driver_location'),
        position: position,
        icon: truckIcon ?? BitmapDescriptor.defaultMarker,
      ));
    });
    _controller?.animateCamera(CameraUpdate.newLatLng(position));
  }
}

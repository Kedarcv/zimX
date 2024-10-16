import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class OrderTrackingScreen extends StatefulWidget {
  OrderTrackingScreen({Key? key}) : super(key: key);

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late GoogleMapController _mapController;
  final LatLng _center = const LatLng(-19.0154, 29.1549);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late BitmapDescriptor _truckIcon;
  late Timer _timer;
  bool _isLoading = true;

  final List<LatLng> _truckRoute = [
    LatLng(-17.8216, 31.0492), // Harare
    LatLng(-20.1560, 28.5885), // Bulawayo
    LatLng(-18.9707, 32.6709), // Mutare
    LatLng(-16.5167, 28.8833), // Victoria Falls
  ];

  final List<Map<String, dynamic>> _zimbabweCities = [
    {'name': 'Harare', 'position': LatLng(-17.8216, 31.0492)},
    {'name': 'Bulawayo', 'position': LatLng(-20.1560, 28.5885)},
    {'name': 'Chitungwiza', 'position': LatLng(-18.0127, 31.0756)},
    {'name': 'Mutare', 'position': LatLng(-18.9707, 32.6709)},
    {'name': 'Gweru', 'position': LatLng(-19.4500, 29.8167)},
    {'name': 'Epworth', 'position': LatLng(-17.8897, 31.1631)},
    {'name': 'Kwekwe', 'position': LatLng(-18.9281, 29.8149)},
    {'name': 'Kadoma', 'position': LatLng(-18.3333, 29.9167)},
    {'name': 'Masvingo', 'position': LatLng(-20.0667, 30.8333)},
    {'name': 'Chinhoyi', 'position': LatLng(-17.3667, 30.2000)},
    {'name': 'Victoria Falls', 'position': LatLng(-17.9317, 25.8307)},
  ];

  int _currentRouteIndex = 0;

  @override
  void initState() {
    super.initState();
    _setCustomMapPin();
    _startTruckMovement();
    _addCityMarkers();
  }

  void _setCustomMapPin() async {
    try {
      _truckIcon = await BitmapDescriptor.asset(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/truck_icon.png',
      );
    } catch (e) {
      print('Error loading truck icon: $e');
    }
    setState(() {});
  }

  void _addCityMarkers() {
    for (var city in _zimbabweCities) {
      _markers.add(Marker(
        markerId: MarkerId(city['name']),
        position: city['position'],
        infoWindow: InfoWindow(title: city['name']),
      ));
    }
  }

  void _startTruckMovement() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        if (_currentRouteIndex < _truckRoute.length - 1) {
          _currentRouteIndex++;
          _updateTruckPosition();
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void _updateTruckPosition() {
    _markers.removeWhere((marker) => marker.markerId.value == 'truck');
    _markers.add(Marker(
      markerId: MarkerId('truck'),
      position: _truckRoute[_currentRouteIndex],
      icon: _truckIcon,
    ));

    _polylines.add(Polyline(
      polylineId: PolylineId('route'),
      visible: true,
      points: _truckRoute.sublist(0, _currentRouteIndex + 1),
      color: Colors.blue,
      width: 4,
    ));

    _mapController.animateCamera(
      CameraUpdate.newLatLng(_truckRoute[_currentRouteIndex]),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track your ZimXpress Order'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _isLoading = false;
                _mapController = controller;
                _updateTruckPosition();
              });
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 6.5,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            trafficEnabled: true,
            compassEnabled: true,
            indoorViewEnabled: true,
            buildingsEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            onTap: (LatLng latLng) {
              // Handle map tap event
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Estimated arrival time: ${_getEstimatedArrivalTime()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _getEstimatedArrivalTime() {
    int remainingStops = _truckRoute.length - _currentRouteIndex - 1;
    int estimatedMinutes = remainingStops * 5;
    return '$estimatedMinutes minutes';
  }
}

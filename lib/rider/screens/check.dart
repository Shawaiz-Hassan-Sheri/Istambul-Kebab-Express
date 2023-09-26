//---------------------------------------Show markers on map

import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CheckMap extends StatefulWidget {
  @override
  _CheckMapState createState() => _CheckMapState();
}

class _CheckMapState extends State<CheckMap> {
  Position? _currentPosition; // Store the current location of the delivery person
  MapController mapController = MapController();
  List<LatLng> deliveryLocations = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    // Request permission and get the current location of the delivery person
    _getCurrentLocation();

    // Listen for location updates continuously
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  // Function to request permission and fetch the current location of the delivery person
  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Request location permissions
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied. Please enable them to continue.');
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied. Please enable them in app settings.');
      return;
    }

    // Get the current location of the delivery person
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  // Function to draw the route on the map using the polyline points
  void _createRoute(LatLng start, LatLng end) async {
    polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBu_Ild2B1rMbRtMp_yJoTb9xjy8NrsjZM", // Replace this with your Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  @override
  void dispose() {
    // Cancel the position stream subscription when the widget is disposed
    //positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_rounded)),
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final orders = snapshot.data?.docs;

          if (orders == null || orders.isEmpty) {
            return Center(
              child: Text('No orders found.'),
            );
          }

          deliveryLocations.clear();
          for (var order in orders) {
            var orderData = order.data() as Map<String, dynamic>;
            double orderLat = orderData?['latitude'] ?? 0.0;
            double orderLon = orderData?['longitude'] ?? 0.0;
            double distance = calculateDistance(
              _currentPosition?.latitude ?? 0,
              _currentPosition?.longitude ?? 0,
              orderLat,
              orderLon,
            );
            if (distance <= 5000) {
              // If the order is within 5 kilometers, add it to the deliveryLocations list
              deliveryLocations.add(LatLng(orderLat, orderLon));
            }
          }

          if (deliveryLocations.isEmpty) {
            return Center(
              child: Text('No nearby orders found.'),
            );
          }

          // Draw route for efficient delivery
          _createRoute(LatLng(_currentPosition?.latitude ?? 0, _currentPosition?.longitude ?? 0), deliveryLocations.first);

          return Column(
            children: [
              Expanded(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: LatLng(_currentPosition?.latitude ?? 0, _currentPosition?.longitude ?? 0),
                    zoom: 12.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    PolylineLayer(
                        polylines: [
                          Polyline(
                            points: polylineCoordinates,
                            color: Colors.blue,
                            strokeWidth: 3,
                          ),
                        ],
                      ),
                     MarkerLayer(
                        markers: deliveryLocations.map((LatLng latLng) {
                          return Marker(
                            width: 40.0,
                            height: 40.0,
                            point: latLng,
                            builder: (ctx) => Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          );
                        }).toList(),
                      ),


                  ],
                ),
              ),
              // Add any other widgets you want to display below the map
              // ...
            ],
          );
        },
      ),
    );
  }
}

// Function to calculate the distance between two locations (in meters)

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  final p = 0.017453292519943295;
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)) * 1000;
}




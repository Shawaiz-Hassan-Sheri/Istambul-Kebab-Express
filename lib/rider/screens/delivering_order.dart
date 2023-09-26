import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users_food_app/rider/screens/check.dart';
import 'package:users_food_app/rider/screens/order_details_screen.dart';


class Order {
  final double latitude;
  final double longitude;
  final int totalCost;
  final String id12;
  Order({required this.totalCost,required this.id12,required this.latitude, required this.longitude});
}

class DeliveringOrder extends StatefulWidget {
  @override
  _DeliveringOrderState createState() => _DeliveringOrderState();
}

class _DeliveringOrderState extends State<DeliveringOrder> {
  List<Order> orders = [];
  Position? _currentPosition;



  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getOrders();
  }
  @override
  void didUpdateWidget(covariant DeliveringOrder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getCurrentLocation();
    _getOrders();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied. Please enable them to continue.');
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied. Please enable them in app settings.');
      return;
    }

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

  void _getOrders() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where("status", isEqualTo: "Picked")
          .get();
      setState(() {
        orders = snapshot.docs.map((doc) {
          String id1=doc.id;
          double latitude = doc['latitude'];
          double longitude = doc['longitude'];
          int total=doc['TotalCost'];
          return Order(id12: id1,totalCost:total,latitude: latitude, longitude: longitude);
        }).toList();

        // Sort the orders based on proximity to the rider's location
        orders.sort((a, b) => _calculateDistance(_currentPosition?.latitude ?? 0, _currentPosition?.longitude ?? 0, a.latitude, a.longitude)
            .compareTo(_calculateDistance(_currentPosition?.latitude ?? 0, _currentPosition?.longitude ?? 0, b.latitude, b.longitude)));
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions:[
          GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => CheckMap(),
                  ),
                ); Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => CheckMap(),
                  ),
                );
              },

              child: Icon(Icons.location_on)),
        ]
      ),
      
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          if(orders.length==0){
            return Text("No Orders in queue...");
          }

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => OrderDetailsScreen(
                      orderID: orders[index].id12,
                      latitude: orders[index].latitude,
                      longitude: orders[index].longitude,
                      totalCost: orders[index].totalCost,

                  ),
                ),
              ).then((_) {
                _getCurrentLocation(); // Execute this after returning from SecondScreen
                _getOrders(); // Execute this after returning from SecondScreen
              });;
      // Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (c) => OrderDetailsScreen(
      //                 orderID: orders[index].id12,
      //                 latitude: orders[index].latitude,
      //                 longitude: orders[index].longitude,
      //
      //             ),
      //           ),
      //         );

            },
            child: ListTile(
              title: Text('Order ${index + 1}'),
              subtitle: Text('Latitude: ${orders[index].latitude}, Longitude: ${orders[index].longitude}'),
              trailing: Text('Order Cost:  ${orders[index].totalCost}'),
              // Add any other order details you want to display
              // ...
            ),
          );
        },
      ),
    );
  }
}





//---------------------------------------Show markers on map

/*class DeliveringOrder extends StatefulWidget {
  @override
  _DeliveringOrderState createState() => _DeliveringOrderState();
}

class _DeliveringOrderState extends State<DeliveringOrder> {
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
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
}*/

/*



//-----------------------------------------Show distance from current location to order's location


class DeliveringOrder extends StatefulWidget {
  @override
  _DeliveringOrderState createState() => _DeliveringOrderState();
}

class _DeliveringOrderState extends State<DeliveringOrder> {
  Position? _currentPosition; // Store the current location of the delivery person

  @override
  void initState() {
    super.initState();
    // Request permission and get the current location of the delivery person using Geolocator
    _getCurrentLocation();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              // Extract data from the document
              var orderData = orders[index].data() as Map<String, dynamic>;

              // Get the latitude and longitude of the order from Firebase

              double orderLat = orderData['latitude'];
              double orderLon = orderData['longitude'];

              // Calculate the distance between the delivery person and the order location
              double distance = calculateDistance(
                _currentPosition?.latitude ?? 0,
                _currentPosition?.longitude ?? 0,
                orderLat,
                orderLon,
              );

              return ListTile(
                //title: Text('Order ID: ${orderData['order_id']}'),
                title: Text('Order Cost:  ${orderData['TotalCost']}'),
                subtitle: Text('Distance: ${distance.toStringAsFixed(2)} meters'),
              );
            },
          );
        },
      ),
    );
  }
}
*/



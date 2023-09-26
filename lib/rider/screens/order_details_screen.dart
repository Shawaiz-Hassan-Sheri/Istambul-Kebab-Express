import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../manager/models/offline_orders.dart';
import '../maps/send_location.dart';
import '../models/address.dart';
import '../widgets/progress_bar.dart';
import '../widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;
  final double longitude;
  final double latitude;
  final int totalCost;
  OrderDetailsScreen({required this.totalCost,required this.orderID,required this.longitude,required this.latitude,});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  //String orderStatus = "";
  // String orderByUser = "";
  // String sellerId = "";
  final CollectionReference ordersRef = FirebaseFirestore.instance.collection('Orders');
  double orderTotal(OnlineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
  getOrderInfo() {
    FirebaseFirestore.instance
        .collection("Orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot) {
    //  orderStatus = DocumentSnapshot.data()!["status"].toString();
    //  orderByUser = DocumentSnapshot.data()!["timestamp"].toString();
     // sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();

    getOrderInfo();
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = '';
  void _getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> deliverOrder( String id) async {
    try {
      final currentUser = await FirebaseAuth.instance.currentUser;
      // Assign the order to the selected rider

      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(id)
          .update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        'status':'Delivered',

      });
      print('ordersssssssssssssssssssssssssssssssssssssssssssssssssss');
      await FirebaseFirestore.instance
          .collection('Rider')
          .doc(userId)
          .update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        'RiderEarnings': FieldValue.increment(widget.totalCost) ,

      });
      print('ridersssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(' Success'),
            content: Text('Order Deliver successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                //  Navigator.of(context).pop();
                 //Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pop(context); // Pop the current route (FourthScreen)
                  Navigator.pop(context);

                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Assignment Failed'),
            content: Text('Failed to Deliver the order. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  Future<void> notReceivedOrder( String id) async {
    try {
      // Assign the order to the selected rider
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(id)
          .update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        'status':'NotReceived',

      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Not Received'),
            content: Text('Order is not received.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Assignment Failed'),
            content: Text(' Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          actions:[
            GestureDetector(
                onTap: () {

                   openGoogleMaps(widget.latitude, widget.longitude);
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (c) => OrderMap(latitude: widget.latitude, longitude: widget.longitude!,),
                      builder: (c) => SendLocation()
                    ),
                  );*/
                },
                child: Icon(Icons.location_on)),
          ]

      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("Orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
             // orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Total Amount: " +
                                  "\$ " +
                                  dataMap!["TotalCost"].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Divider(thickness: 4),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: width,
                          //height: height-((height*0.03)+(height*0.03)+(height*0.1)+(height*0.3)),
                          height: height*0.6,
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('Orders').doc(widget.orderID).get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(child: Text('Order not found'));
                              }

                              // Data exists, and snapshot.data contains the document data.

                               // Data exists, and snapshot.data contains the document data.
                              DocumentSnapshot<Object?>? orderSnapshot = snapshot.data;
                              OnlineOrders order = OnlineOrders.fromFirestore(orderSnapshot!);

                              // Now, you can use the orderData to display the information as you wish.
                              // For example:
                              return Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:  order.orderItems.length,
                                        itemBuilder: (context, index) {
                                          OrderItem1 item = order.orderItems[index];

                                          // Display the item details in the list.
                                          return ListTile(
                                            leading: CircleAvatar(
                                                radius: height*0.05,
                                                backgroundImage: Image.network(item.imageUrl).image
                                            ),
                                            title: Text('Title : ${item.name}'),
                                            subtitle: Text('Quantity: ${item.quantity}, Price: \$${item.price}, Total: \$${item.totalPrice}'),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(order.orderuserUID).get(),

                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text('Error: ${snapshot.error}'),
                                          );
                                        } else {
                                          final data = snapshot.data;
                                          return Column(
                                            children: [

                                              const SizedBox(height: 20),
                                              const Divider(
                                                thickness: 2,
                                                color: Colors.white,
                                              ),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.amber.withOpacity(0.4),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        padding: const EdgeInsets.all(5),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Image.asset(
                                                                "images/restaurant.png",
                                                                height: 30,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 5),
                                                            Text(
                                                              ' ${data!['UserName']}',
                                                              style: GoogleFonts.lato(
                                                                textStyle: const TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(5),
                                                        child: Text(
                                                          ' ${data!['UserEmail']}',
                                                          style: GoogleFonts.lato(
                                                            textStyle: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey.shade500),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Material(
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(80),
                                                      ),
                                                      elevation: 10,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(1),
                                                        child: SizedBox(
                                                          height: 100,
                                                          width: 100,
                                                          child: CircleAvatar(
                                                            //we get the profile image from sharedPreferences (global.dart)
                                                            backgroundImage: NetworkImage(

                                                              '${data!['UserPhotoUrl']}',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  SpinKitWave(
                                                    type: SpinKitWaveType.center,
                                                    color: Colors.black87,
                                                    size: 30.0,
                                                  ),
                                                  Text(
                                                    ' 0${data!['UserPhoneNumber']}',
                                                    style: TextStyle(fontSize: 25,
                                                        fontWeight: FontWeight.w400

                                                        , color: Colors.black),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () => _makePhoneCall(context,data!['UserPhoneNumber']),
                                                    child: Text('Call Now'),
                                                  ),
                                                ],
                                              ),
                                              const Divider(
                                                thickness: 2,
                                                color: Colors.white,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [

                                                  ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return Card(
                                                              child: AlertDialog(
                                                                title: Text('Deliver Order'),
                                                                content: Text(
                                                                    'Are you sure order is Delivered ?'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: Text('Cancel'),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text('Deliver'),
                                                                    onPressed: () {
                                                                      deliverOrder(order.id);
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: Text('Deliver'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return Card(
                                                              child: AlertDialog(
                                                                title: Text('Not Received Order'),
                                                                content: Text(
                                                                    'Are you sure Order is not received?'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: Text('Cancel'),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text('Not Receive'),
                                                                    onPressed: () {
                                                                      notReceivedOrder(order.id);
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: Text('Not Received'),
                                                  ),

                                                ],
                                              ),
                                              const Divider(
                                                thickness: 2,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(height: 5),

                                            ],
                                          );
                                        }
                                      }
                                    },
                                  ),

                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
  void _makePhoneCall(BuildContext context,phoneNumber) async {
    String url = 'tel:0$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make the call. Please try again later.')),
      );
    }
  }
  void openGoogleMaps(double latitude, double longitude) async {
    // String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

}


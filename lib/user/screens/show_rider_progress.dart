import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_food_app/rider/screens/delivering_order.dart';
import 'package:users_food_app/rider/screens/order_map.dart';

import '../../manager/models/offline_orders.dart';

import '../models/address.dart';
import '../widgets/progress_bar.dart';
import '../widgets/status_banner.dart';

class ShowRiderProgress extends StatefulWidget {
  final String? orderID;
  final String? riderID;
  ShowRiderProgress({required this.orderID,required this.riderID});

  @override
  State<ShowRiderProgress> createState() => _ShowRiderProgressState();
}

class _ShowRiderProgressState extends State<ShowRiderProgress> {

  double orderTotal(OnlineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
      title: Text("Rider's Details"),

      ),
      body: SingleChildScrollView(
        child:  Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: width,
          //height: height-((height*0.03)+(height*0.03)+(height*0.1)+(height*0.3)),

          decoration: BoxDecoration(
            color: Colors.amberAccent.withOpacity(0.7),
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
            future: FirebaseFirestore.instance.collection('Rider').doc(widget.riderID).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Text('Rider not found.'),
                  );
                }

                final riderData = snapshot.data!.data() as Map<String, dynamic>;

                // Now you can use the riderData to display rider information
                // For example:
                return Column(
                  children: [

                    const SizedBox(height: 20),
                    const Divider(
                      thickness: 2,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),



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
                                    ' ${riderData!['RiderName']}',
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
                                ' ${riderData!['RiderEmail']}',
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

                                    '${riderData!['RiderAvatarUrl']}',
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
                          ' 0${riderData!['RiderPhone']}',
                          style: TextStyle(fontSize: 25,
                              fontWeight: FontWeight.w400

                              , color: Colors.black),
                        ),
                        ElevatedButton(
                          onPressed: () => _makePhoneCall(context,riderData!['RiderPhone']),
                          child: Text('Call Now'),
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
            },
          ),
        )
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
  /*void openGoogleMaps(double latitude, double longitude) async {
    // String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps.';
    }
  }*/

}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/offline_orders.dart';
import '../models/orders.dart';

class OnlineOrderDetailScreen extends StatelessWidget {
  final OnlineOrders order;
  final String userid;

  OnlineOrderDetailScreen({
    required this.order,
    required this.userid,

  });

  @override
  Widget build(BuildContext context) {
    print('${order.id}');
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text('Order Details'),
          actions: [
            InkWell(
                onTap: ()async{
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cancel Order'),
                        content: Text('Are you sure to cancel this order?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async{
                             await
                                  FirebaseFirestore.instance.collection("Orders").doc(order.id)
                                  .update({
                                    'status':'Cancel',
                                  });
                                      //.delete();
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: ((context) => const AdminHomeScreen())));

                                  //Fluttertoast.showToast(msg: "Order  Cancel Successfully....");


                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),  TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );

                },
                child: Icon(Icons.delete))
          ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: order.orderItems.length,
              itemBuilder: (context, index) {
                final OrderItem1 item = order.orderItems[index];

                return ListTile(
                  leading: Image.network(item.imageUrl),
                  title: Text(item.name),
                  subtitle: Text('${item.quantity} x \$${item.price}'),
                  trailing: Text('\$${item.price * item.quantity}'),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('User')
                .doc(userid).get(),
s
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
                      const SizedBox(height: 5),

                    ],
                  );
                }
              }
            },
          ),


        ],
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
}

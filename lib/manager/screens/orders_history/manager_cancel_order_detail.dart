import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_food_app/manager/models/offline_orders.dart';


class ManagerCancelOrderDetail extends StatelessWidget {
  final OnlineOrders order;

  ManagerCancelOrderDetail({required this.order});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical:height*0.01 ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Cost :  ",style: TextStyle(

                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: height * 0.01 * 2.5,
                ),),
                Text("\$${order.totalCost}",style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: height * 0.01 * 2.5,
                ),),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            Expanded(

              child: ListView.builder(
                itemCount: order.orderItems.length,
                itemBuilder: (context, index) {
                  final OrderItem1 item = order.orderItems[index];

                  return ListTile(
                    leading: Image.network(item.imageUrl),
                    title: Text(item.name),
                    subtitle: Text('${item.quantity} x \$${item.price}'),
                    trailing: Text('\$${item.price * item.quantity}',style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: height * 0.01 * 2
                    ),),
                  );
                },
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Rider')
                  .doc(order.assignedRider).get(),

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
                          color: Colors.grey,
                        ),

                        Text(
                          ' Rider Details : ',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontFamily: "Acme",
                          ),
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
                                        ' ${data!['RiderName']}',
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
                                    ' ${data!['RiderEmail']}',
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
                              ' 0${data!['RiderPhone']}',
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
                          color: Colors.grey,
                        ),

                        Text(
                          ' Customer Details : ',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontFamily: "Acme",
                          ),
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

                          ],
                        ),
                        const SizedBox(height: 20),


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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_food_app/manager/models/offline_orders.dart';

import '../../../rider/models/riders.dart';

class Manager_Rider_Screen extends StatelessWidget {
  final String userID;

  Manager_Rider_Screen({required this.userID});

  Future<void> UpdateData(
      BuildContext context, String id, double totalearning) async {
    try {

      await FirebaseFirestore.instance.collection('Rider').doc(id).update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        //'RiderEarnings': FieldValue.increment(widget.totalCost) ,
        'RiderEarnings': 0.0,
      });
      await FirebaseFirestore.instance
          .collection('Manager')
          .doc(userID)
          .update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        //'RiderEarnings': FieldValue.increment(widget.totalCost) ,
        'ManagerEarnings': FieldValue.increment(totalearning),
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(' Success'),
            content: Text('Amount Updated successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  //  Navigator.of(context).pop();
                  //Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pop(
                      context); // Pop the current route (FourthScreen)
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
            content: Text('Failed to update money. Please try again.'),
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Riders')),
      body: Container(
        margin: EdgeInsets.symmetric( vertical: height * 0.01),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseFirestore.instance.collection('Rider')
                        .where('RiderEarnings', isGreaterThan: 0.0)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('All Amounts Are Collected'),
                    );
                  }

                  // Process the query snapshot data and build your UI
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // Access the document data using snapshot.data!.docs[index].data()
                      final riderData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      // Create UI widgets using riderData
                      return Column(
                        children: [

                          Container(
                            // margin: EdgeInsets.symmetric(vertical: 2),
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.amber,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ExpansionTile(
                              trailing: Text(
                                '\$${riderData!['RiderEarnings']}',
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                ' ${riderData!['RiderName']}',
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                ' ${riderData!['RiderEmail']}',
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors
                                            .amber, // Set the button's color to amber
                                      ),
                                      onPressed: () {

                                        UpdateData(
                                          context,
                                          riderData!['RiderUID'],
                                          riderData!['RiderEarnings'],
                                        );
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => AdminEmployeeDetailsScreen(model:employee),
                                        //   ),
                                        // );
                                      },
                                      child: Text(
                                        'Collect',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),



                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

/*
   Container(
              width: width,
              height: height * 0.5,
              child: FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance.collection('Rider').doc().get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.amber,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Container(
                              // margin: EdgeInsets.symmetric(vertical: 2),
                              margin: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                trailing: Text(
                                  '\$${data!['RiderEarnings']}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Name: ${data!['RiderName']}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  'Email: ${data!['RiderEmail']}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors
                                              .amber, // Set the button's color to amber
                                        ),
                                        onPressed: () {
                                          UpdateData(
                                            context,
                                            data!['RiderUID'],
                                            data!['RiderEarnings'],
                                          );
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => AdminEmployeeDetailsScreen(model:employee),
                                          //   ),
                                          // );
                                        },
                                        child: Text(
                                          'Collect',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                                // trailing: Icon(Icons.electric_bike_outlined,),
                              ),
                            ),

*/

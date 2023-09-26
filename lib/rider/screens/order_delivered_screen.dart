import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/manager/models/offline_orders.dart';
import 'package:users_food_app/rider/global/global.dart';

import '../../manager/models/orders.dart';
import '../../manager/widgets/orders_detail_screen.dart';
import '../assistantMethods/assistant_methods.dart';
import '../widgets/order_card_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';

class OrderDeliveredScreen extends StatefulWidget {
  String userid;

  OrderDeliveredScreen({required this.userid});

  @override
  _OrderDeliveredScreenState createState() => _OrderDeliveredScreenState();
}

class _OrderDeliveredScreenState extends State<OrderDeliveredScreen> {
  double orderTotal(OnlineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: SimpleAppBar(
        title: " Delivered",
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        // width: width,
        // //height: height-((height*0.03)+(height*0.03)+(height*0.1)+(height*0.3)),
        // height: height,
        // decoration: BoxDecoration(
        //   color: Colors.amberAccent,
        //   borderRadius: BorderRadius.circular(8),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.2),
        //       blurRadius: 4,
        //       offset: Offset(2, 2),
        //     ),
        //   ],
        // ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Orders')
            .where("assignedRider", isEqualTo: widget.userid)
            .where("status", isEqualTo: "Delivered")
              .orderBy('timestamp', descending: true)
            .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final List<OnlineOrders> orders = snapshot.data!.docs
                .map((doc) => OnlineOrders.fromFirestore(doc))
                .toList() ;
            return Scrollbar(
              thickness: 4,
              // Define the color of the scrollbar track
              trackVisibility: true,
              // Define the color of the scrollbar thumb
              thumbVisibility: true,
              child: Container(
                height: height,
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemExtent: orders.length * height*0.05,
                  itemBuilder: (context, index) {
                    final OnlineOrders order = orders[index];

                    return Container(
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
                      child: ListTile(
                        title: Text('Order ${order.id}'),
                        subtitle: Text('Total: \$${orderTotal(order)}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(order: order),
                            ),
                          );
                        },
                        trailing: Icon(Icons.electric_bike_outlined,),
                      ),
                    );
                  },
                ),
              ),
            );

          },
        ),
      ),
    );
  }
}


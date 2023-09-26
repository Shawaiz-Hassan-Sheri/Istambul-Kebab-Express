import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/user/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/user/global/global.dart';
import 'package:users_food_app/user/screens/show_rider_progress.dart';
import 'package:users_food_app/user/widgets/design/order_card_design.dart';
import 'package:users_food_app/user/widgets/progress_bar.dart';
import 'package:users_food_app/user/widgets/simple_app_bar.dart';

import '../../manager/models/offline_orders.dart';
import '../../manager/widgets/orders_detail_screen.dart';
import 'edit_order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  late String userid;
  MyOrdersScreen({required this.userid});
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}
class _MyOrdersScreenState extends State<MyOrdersScreen> {
  double orderTotal(OnlineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
  final ScrollController inProgressController = ScrollController();
  final ScrollController completedController = ScrollController();
  @override
  Widget build(BuildContext context) {
    print(" user id at my orders ${widget.userid}");

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: SimpleAppBar(
        title: "My Orders",
      ),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(-2.0, 0.0),
            end: FractionalOffset(5.0, -1.0),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAC898),
            ],
          ),
        ),
        child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Text("Orders In Progress"),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Orders')
                      .where("orderUserUID", isEqualTo: widget.userid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    // final List<OnlineOrders> orders = snapshot.data!.docs
                    //     .map((doc) => OnlineOrders.fromFirestore(doc))
                    //     .toList() ;
                    final List<OnlineOrders> orders = snapshot.data!.docs
                        .map((doc) => OnlineOrders.fromFirestore(doc))
                        .where((order) => order.status != "Delivered") // Filter locally
                        .toList();
                    return SingleChildScrollView(
                      controller: completedController,
                      child: Scrollbar(
                        controller: completedController,
                        thickness: 4,
                        // Define the color of the scrollbar track
                        trackVisibility: true,
                        // Define the color of the scrollbar thumb
                        thumbVisibility: true,
                        child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orders.length,

                          itemBuilder: (context, index) {
                            final OnlineOrders order = orders[index];
                            print(order.assignedRider);
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
                              child: ExpansionTile(
                                title: Text('Order ${order.id}',style: TextStyle(
                                  color: Colors.black,
                                ),),
                                subtitle: Text('Total: \$${orderTotal(order)}',style: TextStyle(
                                  color: Colors.black,
                                ),),

                                children: [

                                  // Additional content to display when the tile is expanded
                               (order.assignedRider == null || order.assignedRider == "")?
                               Container()
                                  :ElevatedButton(
                                 onPressed: () {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => ShowRiderProgress(
                                         orderID: order.id,
                                         riderID: order.assignedRider,
                                       ),
                                     ),
                                   );
                                   // Show the rider's progress and order status
                                   // ScaffoldMessenger.of(context).showSnackBar(
                                   //   SnackBar(content: Text('Rider Progress and Order Status')),
                                   // );
                                 },
                                 child: Text('Show Rider Progress'),
                               ),
                                   ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditOrderDetailScreen(order: order),
                                        ),
                                      );
                                    },
                                    child: Text('Show order Details'),

                                  )
                                ],
                                // trailing: Icon(Icons.electric_bike_outlined,),
                              ),
                            );
                          },
                        ),
                      ),
                    );

                  },
                ),
              ],
            )

        ),
      ),

    );
  }
}

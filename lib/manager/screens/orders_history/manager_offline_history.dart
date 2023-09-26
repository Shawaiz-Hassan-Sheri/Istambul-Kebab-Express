import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_food_app/user/widgets/simple_app_bar.dart';

import '../../models/offline_orders.dart';
import '../../widgets/offline_order_detail_screen.dart';
import '../../widgets/orders_detail_screen.dart';
import 'manager_offline_order_detail.dart';

class ManagerOfflineHistory extends StatefulWidget {
  late String userid;
  ManagerOfflineHistory({required this.userid});
  @override
  _ManagerOfflineHistoryState createState() => _ManagerOfflineHistoryState();
}

class _ManagerOfflineHistoryState extends State<ManagerOfflineHistory> {
  final ScrollController completedController = ScrollController();
  double orderTotal(OffLineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
  // String formattedDate='';
  // String formattedTime='';
  // Future<void> timefix(Timestamp _timestamp) async{
  //   DateTime dateTime = await _timestamp.toDate();
  //    formattedDate = await DateFormat('dd MMMM yyyy').format(dateTime);
  //    formattedTime = await DateFormat('jm').format(dateTime);
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: SimpleAppBar(
        title: "History",
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
        child:  StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance.collection('OfflineOrders')
              .where("status", isEqualTo : "done")
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final List<OffLineOrders> orders =  snapshot.data!.docs
                .map((doc) => OffLineOrders.fromFirestore(doc))
                .toList() ;
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

                  itemBuilder: (context, index)  {
                    final OffLineOrders order = orders[index];
                    Timestamp timestamp = order.timestamp; // Assuming your timestamp field is named 'timestamp'
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
                    String formattedTime = DateFormat('jm').format(dateTime);
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date : ${formattedDate}',style: TextStyle(
                                  color: Colors.black,
                                ),),
                                Text('Time : ${formattedTime}',style: TextStyle(
                                  color: Colors.black,
                                ),),
                              ],
                            ),
                          ),

                          ListTile(
                            title: Text('Order ${order.id}'),
                            subtitle: Text('Total: \$${orderTotal(order)}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Manager_Offline_Order_Detail(order: order),
                                ),
                              );
                            },
                            trailing: Icon(Icons.electric_bike_outlined,),
                          ),
                        ],
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

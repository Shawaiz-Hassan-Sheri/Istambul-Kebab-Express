import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../manager/models/orders.dart';
import '../assistantMethods/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/order_card_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_app_bar.dart';
class OrderInProgressScreen extends StatefulWidget {
  @override
  State<OrderInProgressScreen> createState() => _OrderInProgressScreenState();
}
class _OrderInProgressScreenState extends State<OrderInProgressScreen> {
  final CollectionReference ordersRef =
  FirebaseFirestore.instance.collection('Orders');
  String useruid='';
  void getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    useruid=user!.uid.toString();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserUid();
  }
  late int id1;


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders List'),

      ),
      body: Container(
        width: width,
        height: height*0.9,
        child: StreamBuilder<QuerySnapshot>(
          stream: ordersRef
              .where('status', isEqualTo: 'Picked')
              .where("assignedRider", isEqualTo: useruid)
              .snapshots(),
          //stream: ordersRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final List<Orders> orders = snapshot.data!.docs
                .map((doc) => Orders.fromFirestore(doc))
                .toList() ;
            if (orders.isEmpty) {
              return Center(
                child: Text('No orders found.'),
              );
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Orders order = orders[index];

                return ListTile(
                  title: Text('Order:  ${order.id}'),
                  subtitle: Text('Total: \$${orderTotal(order)}'),
                  onTap: () {
                  /*  showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Card(
                            child: AlertDialog(
                              title: Text('Picked Order'),
                              content: Text(
                                  'Do you want to Picked this order to ${order.id}?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Picked'),
                                  onPressed: () {
                                    //pickedOrder(order.id);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });*/
                  },
                  trailing: GestureDetector(
                      onTap: (){},
                      child: Icon(Icons.electric_bike_outlined,)),
                );
              },
            );
          },
        ),
      ),
    );
  }
  double orderTotal(Orders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
}


/*
class OrderInProgressScreen extends StatefulWidget {
  @override
  _OrderInProgressScreenState createState() => _OrderInProgressScreenState();
}

class _OrderInProgressScreenState extends State<OrderInProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Order in Progress",
      ),
      body: Container(
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
              .where("status", isEqualTo: "picking")
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("itemID",
                                whereIn: separateOrderItemIDs(
                                    (snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>)["productIDs"]))
                            .orderBy("publishedDate", descending: true)
                            .get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? OrderCard(
                                  itemCount: snap.data!.docs.length,
                                  data: snap.data!.docs,
                                  orderID: snapshot.data!.docs[index].id,
                                  seperateQuantitiesList:
                                      separateOrderItemQuantities(
                                          (snapshot.data!.docs[index].data()!
                                                  as Map<String, dynamic>)[
                                              "productIDs"]),
                                )
                              : Center(child: circularProgress());
                        },
                      );
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
*/

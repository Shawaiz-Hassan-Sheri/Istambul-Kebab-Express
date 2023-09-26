import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/manager/models/orders.dart';
class NewOrdersScreen extends StatefulWidget {
  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}
class _NewOrdersScreenState extends State<NewOrdersScreen> {
  final CollectionReference ordersRef =
  FirebaseFirestore.instance
      .collection('Orders');
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
  Future<void> pickedOrder( String id) async {
    try {
      // Assign the order to the selected rider
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(id)
          .update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        'status':'Picked',

      });
      await FirebaseFirestore.instance
          .collection('Rider')
          .doc(useruid)
          .update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        'RiderAvailability':'OnDelivery',

      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Assignment Success'),
            content: Text('Order Picked successfully.'),
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
            content: Text('Failed to Pick the order. Please try again.'),
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
        title: Text('Orders List'),

      ),
      body: Container(
        width: width,
        height: height*0.9,
        child: StreamBuilder<QuerySnapshot>(
          stream: ordersRef
              .where('status', isEqualTo: 'Assigned')
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

                  },
                  trailing: GestureDetector(
                      onTap: (){},
                      child:   ElevatedButton(
                        child: Text('Pick'),
                        onPressed: () {
                          showDialog(
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
                                          pickedOrder(order.id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),),
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
class NewOrdersScreen extends StatefulWidget {
  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
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
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: SimpleAppBar(
        title: "New Orders",
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(-1.0, 0.0),
            end: FractionalOffset(4.0, -1.0),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAC898),
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("status", isEqualTo: "Assign")
              .where("assignedRider", isEqualTo: useruid)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ?  OrderCard(
              itemCount: snapshot.data!.docs.length,
              data: snapshot.data!.docs,
              orderID: snapshot.data!.docs[index].id,
              seperateQuantitiesList:
              separateOrderItemQuantities(
                  (snapshot.data!.docs[index].data()!
                  as Map<String, dynamic>)[
                  "productIDs"]),
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

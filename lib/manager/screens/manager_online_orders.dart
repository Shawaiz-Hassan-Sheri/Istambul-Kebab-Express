
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../rider/models/riders.dart';
import '../models/offline_orders.dart';
import '../widgets/online_orders_detail_screen.dart';


class ManagerOnlineOrders extends StatefulWidget {
  @override
  State<ManagerOnlineOrders> createState() => _ManagerOnlineOrdersState();
}

class _ManagerOnlineOrdersState extends State<ManagerOnlineOrders> {
  final CollectionReference ordersRef =
  FirebaseFirestore.instance.collection('Orders');

  late int id1;

  Future<List<Map<String, dynamic>>> fetchRidersFromFirebase() async {
    // Fetch riders data from Firebase
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Rider')
        .where('status', isEqualTo: 'normal')
        .get();

    // // Extract rider names from query snapshot
    // List<String> riders = querySnapshot.docs
    //     .map((doc) => (doc.data() as Map<String, dynamic>)['RiderName'] as String)
    //     .toList();
    List<Map<String, dynamic>> riders = await querySnapshot.docs
        .map((doc) => {
      'name': (doc.data()as Map<String, dynamic>)['RiderName'] as String,
      'uid': (doc.data()as Map<String, dynamic>)['RiderUID'] as String,
    }).toList();

    return riders;
  }

  Future<void> assignOrderToRider(String uid, String id) async {
    try {
      // Assign the order to the selected rider
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(id)
          .update({
        //status: normal = order is placed online
        //status: assigned = order is assigned to rider
        'status':'Assigned',
        'assignedRider': uid,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Assignment Success'),
            content: Text('Order assigned to $uid successfully.'),
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
            content: Text('Failed to assign the order. Please try again.'),
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
  final CollectionReference ordersRef2 =
  FirebaseFirestore.instance.collection('Rider');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Orders List'),

      ),
      body: Container(
        width: width,
        height: height*0.9,
        child: StreamBuilder<QuerySnapshot>(
          stream: ordersRef.where('status', isEqualTo: 'Normal').snapshots(),
          //stream: ordersRef.snapshots(),
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
            if (orders.isEmpty) {
              return Center(
                child: Text('No orders found.'),
              );
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final OnlineOrders order = orders[index];

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
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

                    title: Text('Order ${order.id}'),
                    //subtitle: Text('Total: \$${orderTotal(order)}'),
                    subtitle: Text('Total: \$${orderTotal(order)}'),
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    width: width*0.8,
                                    height: height*0.4,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream:  FirebaseFirestore.instance.collection('Rider')
                                          .where("RiderAvailability", isEqualTo : "normal")
                                          .snapshots(),
                                      //ordersRef2.where("status", isEqualTo : "normal").snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }

                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }

                                        final List<Riders> rider = snapshot.data!.docs
                                            .map((doc) => Riders.fromFirestore(doc))
                                            .toList() ;
                                        return ListView.builder(
                                          itemCount: rider.length,
                                          itemBuilder: (context, index) {
                                            final Riders rider1 = rider[index];

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
                                                title: Text('Rider: ${rider1.riderName}'),
                                                subtitle: Text('Availability: ${rider1.riderAvailability}'),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Card(
                                                          child: AlertDialog(
                                                            title: Text('Assign Order'),
                                                            content: Text(
                                                                'Do you want to assign this order to ${rider1.riderName}?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text('Cancel'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text('Assign'),
                                                                onPressed: () {
                                                                  assignOrderToRider(
                                                                      rider1.riderUID.toString(),
                                                                      order.id);
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });

                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) => OffLineOrderDetailScreen(order: order),
                                                  //   ),
                                                  // );
                                                },
                                                trailing: Icon(Icons.electric_bike_outlined,),
                                              ),
                                            );
                                          },
                                        );

                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber, // Set the button's color to amber
                            ),
                            child: Text('Show Riders'

                              ,style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OnlineOrderDetailScreen(
                                      userid: order.orderuserUID,
                                    order: order,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber, // Set the button's color to amber
                            ),
                            child: Text('View order'

                              ,style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                   /* onTap: () {




                   *//*   showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(

                            width: width*0.8,
                            height: height*0.4,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: ordersRef2.snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }

                                final List<Riders> rider = snapshot.data!.docs
                                    .map((doc) => Riders.fromFirestore(doc))
                                    .toList() ;
                                return ListView.builder(
                                  itemCount: rider.length,
                                  itemBuilder: (context, index) {
                                    final Riders rider1 = rider[index];

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
                                        title: Text('Rider ${rider1.riderUID}'),
                                       // subtitle: Text('Total: \$${rider1(order)}'),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                            return Card(
                                              child: AlertDialog(
                                                title: Text('Assign Order'),
                                                content: Text(
                                                    'Do you want to assign this order to ${rider1.riderUID}?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Assign'),
                                                    onPressed: () {
                                                      assignOrderToRider(
                                                          rider1.riderUID.toString(),
                                                          order.id);
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          });

                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => OffLineOrderDetailScreen(order: order),
                                          //   ),
                                          // );
                                        },
                                        trailing: Icon(Icons.electric_bike_outlined,),
                                      ),
                                    );
                                  },
                                );

                              },
                            ),
                          );
                        },
                      );
*//*
                    },*/
                    // trailing: GestureDetector(
                    //     onTap: (){
                    //     },
                    //     child: Icon(Icons.electric_bike_outlined,)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  double orderTotal(OnlineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
}







/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/user/widgets/app_bar.dart';
import '../../user/models/cart.dart';
import '../../user/widgets/text_widget_header.dart';
import '../models/orders.dart';



class ManagerOnlineOrders extends StatefulWidget {
  // final Menus? model;
  // ManagerOnlineOrders({this.model});

  @override
  _ManagerOnlineOrdersState createState() => _ManagerOnlineOrdersState();
}
class _ManagerOnlineOrdersState extends State<ManagerOnlineOrders> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //-------------------------------------------------------
  List<CartItem1> orders = [];
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Orders');
  Future<DocumentSnapshot> getDocument() async {
    final DocumentSnapshot documentSnapshot = await collectionReference.doc().get();
    return documentSnapshot;
  }

 //-------------------------------------------------
  late List<Orders> _orders=[];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    List<Orders>? orders = (await Orders.getOrders()).cast<Orders>();
    setState(() {
      _orders = orders.cast<Orders>();
    });
  }

  //-------------------------------------------------


  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          title: Text(

            "Shawaiz Hassan Menu"
          )),
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
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                // title: widget.model!.menuTitle.toString().toUpperCase() + "'s Menu Items",
                title:" Menu Items",
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(color: Colors.white, thickness: 2),
            ),
            _orders != null
                ? SliverToBoxAdapter(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  Orders order = _orders[index];
                  return Container(
                    child: Text('Total Items: ${order.products!.length}'
                      ,style: TextStyle(color: Colors.red),),
                  );
                },
              ),
            )
                : SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            */
/*orders.isEmpty
                ? SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
            ),
                )
                : SliverToBoxAdapter (
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<Orders> orders = snapshot.data!.docs.map((doc) => Orders.fromFirestore(doc)).toList();
                        return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order ID: ${orders[index].id}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Date: ${orders[index].dateTime.toString()}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Total Amount: ${orders[index].totalAmount.toString()}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Items:',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: orders[index].items!.length,
                                        itemBuilder: (context, subIndex) {
                                          return Text(
                                            '${orders[index].items![subIndex].quantity} x ${orders[index].items![subIndex].pizza.title} - ${orders[index].items![subIndex].pizza.price}',
                                            style: TextStyle(fontSize: 16),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),*//*


          ],
        ),
      ),

    );
  }
}


*/
/*StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Orders")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
                    : SliverStaggeredGrid.countBuilder(
                  staggeredTileBuilder: (c) =>
                  const StaggeredTile.count(1, 1.5),
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 0,
                  itemBuilder: (context, index) {


                    Items model = Items.fromJson(
                        snapshot.data!.docs[index].data()!
                        as Map<String, dynamic>);


                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ManagerItemsDesignWidget(
                        context: context,
                        model: model,
                        name: model.title as String ,
                      ),
                    );
                  },

                  itemCount: snapshot.data!.docs.length,

                );
              },
            ),*/

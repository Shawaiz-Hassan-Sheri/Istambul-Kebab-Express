import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/manager/screens/invoice/invoice_generator.dart';
import 'package:users_food_app/rider/models/items.dart';
import 'package:users_food_app/user/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/user/widgets/items_avatar_carousel.dart';
import 'package:users_food_app/user/widgets/my_drawer.dart';
import 'package:users_food_app/user/widgets/progress_bar.dart';

import 'package:users_food_app/authentication/login.dart';

import '../../chec.dart';
import '../../user/models/User.dart';
import '../../user/widgets/user_info.dart';
import '../models/offline_orders.dart';
import '../widgets/manager_info.dart';
import '../widgets/mydrawer_manager.dart';
import '../widgets/offline_orders_detail_screen.dart';
import 'edit_manager_offline_orders.dart';
import 'manager_menu_items.dart';


class ManagerOfflineOrders extends StatefulWidget {

  @override
  _ManagerOfflineOrdersState createState() => _ManagerOfflineOrdersState();
}

class _ManagerOfflineOrdersState extends State<ManagerOfflineOrders> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  final CollectionReference ordersRef =
  FirebaseFirestore.instance.collection('OfflineOrders');
  late String _empName;
  late String _empPhotourl;
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;
  late User1 userEmployee;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  void getSpecificDataFromFirebase() async {
    DocumentSnapshot snapshot = await _db.collection('Manager').doc(firebaseUid).get();
    setState(() {
      _empName = snapshot.get('ManagerName');
      _empPhotourl = snapshot.get('ManagerAvatarUrl');
    });
    // final documentRef =
    //     await FirebaseFirestore.instance.collection('User').doc(firebaseUid);
    // final documentSnapshot = await documentRef.get();
    // setState(() {
    //   _empName = documentSnapshot.data()![userEmployee.UserName];
    //   _empPhotourl = documentSnapshot.data()![userEmployee.UserPhotoUrl];
    // });
  }
  late int total12;
  int orderTotal(OffLineOrders order) {
    int total = 0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    total12=total;
    return total;
  }
  @override
  void initState() {
    super.initState();
    _empName='';
    _empPhotourl='';
    clearCartNow(context);
    getSpecificDataFromFirebase();
    _getCurrentUser();
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = '';
  void _getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }
  Future<void> deleteOrder( String id) async {
    try {
      await FirebaseFirestore.instance.collection('OfflineOrders').doc(id).delete();

      print('ordersssssssssssssssssssssssssssssssssssssssssssssssssss');


      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(' Success'),
            content: Text('Order Delete successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  //  Navigator.of(context).pop();
                  //Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pop(context); // Pop the current route (FourthScreen)
                  //Navigator.pop(context);

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
            content: Text('Failed to Deliver the order. Please try again.'),
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
      drawer: MyDrawerManager(
        userid:userId ,
        empName1: _empName,
        empPhotourl1: _empPhotourl,
      ),
      appBar:AppBar(
        elevation: 1,
       // pinned: true,
        backgroundColor: const Color(0xFFFAC898),
        foregroundColor: Colors.black,
        //expandedHeight: 50,
        flexibleSpace: Container(
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
          child: FlexibleSpaceBar(
            title: Text(
              'Restaurants',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            centerTitle: false,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: const Icon(Icons.exit_to_app),
              ),
              onTap: () {
                firebaseAuth.signOut().then((value) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (c) => const LoginScreen(),
                  //   ),
                  // );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                  _controller.clear();
                }
                );
              },
            ),
          ),
        ],
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
                Container(
                  child: ManagerInformation(),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => ManagerMenuItems(),
                      ),
                    );
                  },
                  child: Container(
                    height: height * 0.1,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        begin: FractionalOffset(-1.0, 0.0),
                        end: FractionalOffset(5.0, -1.0),
                        colors: [
                          Colors.orangeAccent,
                          Colors.amber,
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                          offset: Offset(4, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.restaurant_menu_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.001,
                        ),
                        Center(
                          child: Text(
                            " Menu ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: width,
                  //height: height-((height*0.03)+(height*0.03)+(height*0.1)+(height*0.3)),
                  height: height*0.3,
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: ordersRef.where('status', isEqualTo: 'normal').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      final List<OffLineOrders> orders = snapshot.data!.docs
                          .map((doc) => OffLineOrders.fromFirestore(doc))
                          .toList() ;
                      // List<OffLineOrders> _items1 = [];
                      // snapshot.data!.docs.forEach((doc) {
                      //   _items1.add(OffLineOrders(
                      //       id: doc.id.toString(),
                      //       status: doc.get('status'),
                      //       timestamp: doc.get('timestamp'),
                      //       totalCost: doc.get('TotalCost'),
                      //       offlineorderUID: doc.get('offlineorderUID'),
                      //       orderItems:  List<OrderItem1>.from(doc['orderItems'].map(
                      //      (item) => OrderItem1.fromMap(item),
                      //    // doc.get('latitude'),
                      //
                      //   ))));
                      // });

                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final OffLineOrders order = orders[index];

                          return Container(
                            // margin: EdgeInsets.symmetric(vertical: 2),
                            margin: EdgeInsets.symmetric(vertical: 4,horizontal: 15),
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
                              subtitle: Text('Total: \$${orderTotal(order)}'),
                              // title: Text('Name : ${employee.employeeName}',style: TextStyle(
                              //   color: Colors.black,
                              // ),),
                              // subtitle: Text('Total: \$${orderTotal(order)}',style: TextStyle(
                              //   color: Colors.black,
                              // ),),
                              children: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => InvoiceGenerator(order: order),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.amber, // Set the button's color to amber
                                          ),
                                          child: Text('Print Receipt'

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
                                                builder: (context) => EditManagerOfflineOrders(

                                                  orderId: order.id,
                                                  order: order,
                                                  totalPrice: order.totalCost,


                                                ),
                                              ),
                                            );
                                            // Show the rider's progress and order status
                                            //  ScaffoldMessenger.of(context).showSnackBar(
                                            //    SnackBar(content: Text('Rider Progress and Order Status')),
                                            //  );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.amber, // Set the button's color to amber
                                          ),
                                          child: Text('Edit order'

                                            ,style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Card(
                                                child: AlertDialog(
                                                  title: Text('Delete Order'),
                                                  content: Text(
                                                      'Are you sure to delete this order ?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: () {
                                                        deleteOrder(order.offlineorderUID);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });

                                        // Show the rider's progress and order status
                                        //  ScaffoldMessenger.of(context).showSnackBar(
                                        //    SnackBar(content: Text('Rider Progress and Order Status')),
                                        //  );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.amber, // Set the button's color to amber
                                      ),
                                      child: Text('delete order'

                                        ,style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                              // trailing: Icon(Icons.electric_bike_outlined,),
                            ),
                          );
                            /*Container(
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
                                    builder: (context) => InvoiceGenerator(order: order),
                                  ),
                                );
                              },
                              trailing: Icon(Icons.electric_bike_outlined,),
                            ),
                          );*/
                        },
                      );
                    /*  return Scrollbar(
                        thickness: 4,
                        // Define the color of the scrollbar track
                        trackVisibility: true,
                        // Define the color of the scrollbar thumb
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final OffLineOrders order = orders[index];

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
                        ),
                      );*/
                    },
                  ),
                ),
              /*  GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => ManagerOffLineOrders(),
                      ),
                    );
                  },
                  child: Container(
                    height: height * 0.12,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        begin: FractionalOffset(-1.0, 0.0),
                        end: FractionalOffset(5.0, -1.0),
                        colors: [
                          Colors.orangeAccent,
                          Colors.amber,
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                          offset: Offset(4, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.restaurant_menu_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.007,
                        ),
                        Center(
                          child: Text(
                            " OffLine Orders ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/


                //List of offline orders are here.......................


              ],
            )


            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.all(5.0),
            //     child: SizedBox(
            //       //taking %20 height for the device
            //       height: MediaQuery.of(context).size.height * .2,
            //       //taking max width for the device
            //       width: MediaQuery.of(context).size.width,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: const [
            //           SellerCarouselWidget(),
            //           ItemsAvatarCarousel(),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            /*StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Items").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        itemBuilder: (context, index) {
                          Sellers smodel = Sellers.fromJson(
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>);
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: SellersDesignWidget(
                              model: smodel,
                              context: context,
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
              },
            )*/

        ),
      ),
    );
  }
}

import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../user/models/items.dart';
import '../models/offline_orders.dart';
import '../widgets/manager_items_design.dart';

class EditManagerOfflineOrders extends StatefulWidget {
  late String orderId;
  int totalPrice;
  OffLineOrders order;

  EditManagerOfflineOrders({
    required this.orderId,
    required this.order,
    required this.totalPrice,

  });
  @override
  State<EditManagerOfflineOrders> createState() => _EditManagerOfflineOrdersState();
}

class _EditManagerOfflineOrdersState extends State<EditManagerOfflineOrders> {
  final CollectionReference itemsRef =
  FirebaseFirestore.instance.collection('Items');

  List<Items> selectedItems = [];

  int quantityCheck = 0;

  bool isSelectedItem(Items item) {
    return selectedItems
        .any((selectedItem) => selectedItem.title == item.title);
  }

  int totalPrice = 0;

  void _addToSelectedItems(Items item1) {
    print(
        "Inner                  function is clicked..................................");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isItemSelected = isSelectedItem(item1);
      if (isItemSelected) {
        print(
            "condition is true   function is clicked..................................");
        for (Items selectedItem in selectedItems) {
          print("loop is clicked..................................");
          if (selectedItem.title == item1.title) {
            print("condition is true   ..................................");
            // The item with the same itemId already exists in the selected items list
            // Handle the duplicate item case here
            setState(() {
              print(
                  "condition is true   quantity is clicked..................................");
              selectedItem.quantity = selectedItem.quantity! + 1;
            });
            break;
          }
        }
      } else {
        print("item q.................................");
        if (item1.quantity == 0) {
          print("item quantity condition .................................");

          //quantityCheck=item.quantity! + 1;
          item1.quantity = item1.quantity! + 1;
          print("item is  ++   .................................");
          setState(() {
            print("item is added .................................");
            selectedItems.add(item1);
          });
        }
      }
      totalPrice = 0;
      for (Items item in selectedItems) {
        // totalPrice = ((item.price!.toDouble() * item.quantity!.toDouble()) + totalPrice as Double) as Double;
        totalPrice = ((item.price! * item.quantity!) + totalPrice);
      }
    });
  }

  void _placeOrder(String orderID) async {
    print("Place button is added .................................");
    final currentUser = await FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final orders = FirebaseFirestore.instance
          .collection('OfflineOrders')
          .doc(orderID);
      final orderId = orders.id;
      print(" button is added .................................");
      final cartData = selectedItems.map((item) => {
        'name': item.title,
        'imageUrl': item.thumbnailUrl,
        'price': item.price,
        'quantity': item.quantity,
        'totalPrice':item.price! * item.quantity!,
      }).toList();

      await orders.set({
        'status':"normal",
        'orderItems': cartData,
        'TotalCost': totalPrice,
        'offlineorderUID': orderId,
        'timestamp': FieldValue.serverTimestamp(), // optional timestamp field
      });
      setState(() {
        selectedItems.clear();
        totalPrice=0;
      });
      print("Place button is added cleared .................................");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    // Initialize selectedItems with order.orderItems values
    selectedItems = widget.order.orderItems.map((orderItem) {
      return Items(
        itemID: widget.order.offlineorderUID,
        title: orderItem.name,
        thumbnailUrl: orderItem.imageUrl,
        price: orderItem.price,
        totalPrice: orderItem.totalPrice,
        quantity: orderItem.quantity,
      );
    }).toList();

    // Calculate total price for selected items
    totalPrice = widget.totalPrice as int;
  }
  double orderTotal(OffLineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      //  endDrawer: Drawer(),
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: Container(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: itemsRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                return Container(
                  width: width * 0.5,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      Items model = Items.fromJson(snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>);

                      return ManagerItemsDesignWidget(
                        addToSelectedItems: _addToSelectedItems,
                        context: context,
                        model: model,
                        name: model.title as String,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
            ),
            Container(
              width: width * 0.4,
              child: Drawer(
                child: Column(
                  children: [
                    const Text(
                      'Selected Items',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: height * 0.15,
                      width: width,
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          Text("Total Price"),
                          Text("Total Price: \$${totalPrice}"),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    SizedBox(height: height * 0.01),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedItems.length,
                        itemBuilder: (context, index) {
                          final item = selectedItems[index];
                          int checkPrice;
                          return Container(
                            height: height * 0.15,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title!,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),

                                    Container(
                                      width:width*0.1,
                                      height:height*0.05,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            checkPrice = (item.price! * item.quantity!);
                                            totalPrice=totalPrice-checkPrice;
                                            selectedItems.removeAt(index);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('\$${item.price} *'),
                                    Text(' ${item.quantity}'),
                                    Text(' = \$${item.price! * item.quantity!.toDouble()}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Expanded(
                                    //   child: Text(
                                    //     'item id:  ${item.itemID}',
                                    //     style: TextStyle(
                                    //         overflow: TextOverflow.clip),
                                    //   ),
                                    // ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon:
                                        FaIcon(FontAwesomeIcons.deleteLeft),
                                        color: Colors.white,
                                        onPressed: () {
                                          if (item.quantity == 0 || item.quantity! < 0) {
                                          }
                                          else {
                                            setState(() {
                                              totalPrice = totalPrice - item.price!;
                                              item.quantity = (item.quantity! - 1);
                                            });
                                          }
                                          // do something when the minimize icon is pressed
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );

                          //   ListTile(
                          //   // leading: Container(
                          //   //     child: Image.network(item.imageUrl),height: 400,),
                          //   title:
                          // );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _placeOrder(widget.order.offlineorderUID);
                      },
                      child: Text('Update Order'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ), //elevated button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0, // Space between rows
                crossAxisSpacing: 1.0,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index].data() as Map<String, dynamic>?;

                return Column(
                  children: [
                    Container(
                        height: height*0.15,
                        child: Image.network(item?['thumbnailUrl'] ?? '',fit: BoxFit.fill,)),
                    SizedBox(height: 8.0),
                    Text(item?['title'] ?? ''),
                    Text('\$${item?['price'] ?? ''}'),
                  ],
                );
              },
            );*/

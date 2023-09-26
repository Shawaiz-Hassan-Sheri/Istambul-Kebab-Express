import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:users_food_app/manager/models/offline_orders.dart';
import 'package:users_food_app/user/models/items.dart';

import '../models/cart.dart';


class EditOrderDetailScreen extends StatefulWidget {
  final OnlineOrders order;

  EditOrderDetailScreen({required this.order});

  @override
  State<EditOrderDetailScreen> createState() => _EditOrderDetailScreenState();
}

class _EditOrderDetailScreenState extends State<EditOrderDetailScreen> {
  Future<void> deleteOrder( String id) async {
    try {
      await FirebaseFirestore.instance.collection('Orders').doc(id).delete();

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
  TextEditingController counterTextEditingController = TextEditingController();
  int itemIndex = -1; // Initialize with a value indicating item not found

  Future<void> retrieveItemIndex(String name) async {
    try {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .doc(widget.order.id)
          .get();

      if (orderSnapshot.exists) {
        Map<String, dynamic> orderData = orderSnapshot.data() as Map<String, dynamic>;

        if (orderData.containsKey('orderItems')) {
          List<dynamic> orderItems = orderData['orderItems'];

          if (orderItems != null) {
            for (int index = 0; index < orderItems.length; index++) {
              Map<String, dynamic> item = orderItems[index];
              if (item['name'] == name) {
                setState(() {
                  itemIndex = index;
                });
                break; // Exit loop when item is found
              }
            }
          } else {
            print('orderItems array is null');
          }
        } else {
          print('orderItems key not found in data');
        }
      } else {
        print('Order document does not exist');
      }
    } catch (e) {
      print('Error retrieving item index: $e');
    }
  }

  void _editOrder({
    required BuildContext context,
    required String id,
    required String name,
    required int quantity,
    required int price
     } ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('item : $name'),
               Text('item quantity :$quantity'),
               Text('item price : \$$price'),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    width: 150,
                    child: NumberInputWithIncrementDecrement(
                      controller: counterTextEditingController,
                      numberFieldDecoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      widgetContainerDecoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                      incIconDecoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      separateIcons: true,
                      decIconDecoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      incIconSize: 25,
                      decIconSize: 25,
                      incIcon: Icons.plus_one,
                      decIcon: Icons.exposure_neg_1,
                      // max: 9,
                      min: 1,
                      initialValue: quantity,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await retrieveItemIndex(name);
                  String counterText = counterTextEditingController.text;
                  int counterDigit = int.parse(counterText);
                  updateOrderItemQuantity(widget.order.id,counterDigit);
                  // await FirebaseFirestore.instance
                  //     .collection('Orders')
                  //     .doc(widget.order.id)
                  //     .update({
                  //   'orderItems.$itemIndex.quantity': counterDigit,
                  //   // You can also update other fields here if needed
                  // });

                  print('Quantity updated successfully');
                } catch (e) {
                  print('Error updating quantity: $e');
                }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              child: Text('update'),
            ),
          ],
        );
      },
    );
  }
  int totalPrice = 0;
  List<Items> selectedItems = [];
  void updateOrderItemQuantity(String orderId, int newQuantity) {
    totalPrice = 0;

    FirebaseFirestore.instance.collection('Orders').doc(orderId).get().then((orderSnapshot) async {
      if (orderSnapshot.exists) {
        List<dynamic> orderItems = orderSnapshot.data()!['orderItems'];
        List<CartItem1> listitems = orderSnapshot.data()!['orderItems'];

        selectedItems = await Future.wait(
          listitems.map((item) async {
            int? price = item.price;
            int quantity = item.quantity;
            int totalPrice = price! * quantity;
            return Items(
                price: price, quantity: quantity, totalPrice: totalPrice);
          }),
        );
        for (Items item in selectedItems) {
          // totalPrice = ((item.price!.toDouble() * item.quantity!.toDouble()) + totalPrice as Double) as Double;
          totalPrice = ((item.price! * item.quantity!) + totalPrice);
        }

        if (itemIndex >= 0 && itemIndex < orderItems.length) {
          Map<String, dynamic> updatedItem = orderItems[itemIndex];
          int _price1=updatedItem['price'];
          updatedItem['quantity'] = newQuantity;
          updatedItem['totalPrice'] =  updatedItem['quantity'] *  _price1;

          orderItems[itemIndex] = updatedItem;
// change total cost against the quantity chanage--------------------------------------------------
          FirebaseFirestore.instance.collection('Orders').doc(orderId).update({

            'orderItems': orderItems,
          }).then((_) {
            print('Quantity updated successfully.');
          }).catchError((error) {
            print('Error updating quantity: $error');
          });
          FirebaseFirestore.instance.collection('Orders').doc(orderId).update({

            'TotalCost': totalPrice,
          }).then((_) {
            print('Quantity updated successfully.');
          }).catchError((error) {
            print('Error updating quantity: $error');
          });
        } else {
          print('Invalid item index.');
        }
      } else {
        print('Order not found.');
      }
    }).catchError((error) {
      print('Error fetching order: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Order Details'),
          actions: [
         GestureDetector(
             onTap: (){
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
                               deleteOrder(widget.order.id);
                               Navigator.of(context).pop();
                             },
                           ),
                         ],
                       ),
                     );
                   });

             },
             child: Container(
                 margin: EdgeInsets.only(right: 20),
                 child: Icon(Icons.delete,color: Colors.black,))),
          ],
      ),
      body: ListView.builder(
        itemCount: widget.order.orderItems.length,
        itemBuilder: (context, index) {
          final OrderItem1 item = widget.order.orderItems[index];

          return ListTile(
            leading: Image.network(item.imageUrl),
            title: Text(item.name),
            subtitle: Text('${item.quantity} x \$${item.price} = \$${item.price * item.quantity}'),
           trailing: IconButton(
             onPressed: () {
               _editOrder(
                   context: context,
                   id: widget.order.id,
                   name:item.name ,
                   quantity: item.quantity,
                   price: item.price
               )


               ;
             },
             icon: Icon(Icons.edit),
           ),
           // trailing: Text('\$${item.price * item.quantity}'),
          );
        },
      ),
    );
  }
}

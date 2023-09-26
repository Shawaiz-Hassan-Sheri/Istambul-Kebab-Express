import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_food_app/manager/models/offline_orders.dart';


class Manager_Offline_Order_Detail extends StatelessWidget {
  final OffLineOrders order;

  Manager_Offline_Order_Detail({required this.order});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical:height*0.01 ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Cost :  ",style: TextStyle(

                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: height * 0.01 * 2.5,
                ),),
                Text("\$${order.totalCost}",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  fontSize: height * 0.01 * 2.5,
                ),),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            Expanded(

              child: ListView.builder(
                itemCount: order.orderItems.length,
                itemBuilder: (context, index) {
                  final OrderItem1 item = order.orderItems[index];

                  return ListTile(
                    leading: Image.network(item.imageUrl),
                    title: Text(item.name),
                    subtitle: Text('${item.quantity} x \$${item.price}'),
                    trailing: Text('\$${item.price * item.quantity}',style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: height * 0.01 * 2
                    ),),
                  );
                },
              ),
            ),



          ],
        ),
      ),
    );
  }
  void _makePhoneCall(BuildContext context,phoneNumber) async {
    String url = 'tel:0$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make the call. Please try again later.')),
      );
    }
  }
}

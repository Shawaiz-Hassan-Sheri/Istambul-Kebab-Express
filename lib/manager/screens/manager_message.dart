import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/manager/screens/add_expenses/dataexpense.dart';
import 'package:users_food_app/rider/assistantMethods/get_current_location.dart';
import 'package:users_food_app/rider/screens/earnings_screen.dart';
import 'package:users_food_app/rider/screens/delivering_order.dart';
import 'package:users_food_app/rider/screens/new_orders_screen.dart';
import 'package:users_food_app/rider/screens/order_delivered_screen.dart';
import 'package:users_food_app/rider/screens/parcel_in_progress_screen.dart';
import 'collect_rider_earnings/manager_collect_rider_earnings.dart';
import 'collect_rider_earnings/manager_rider_screen.dart';


class ManagerMessage extends StatefulWidget {
  String userId;
   ManagerMessage({required this.userId}) ;
  @override
  _ManagerMessageState createState() => _ManagerMessageState();
}
class _ManagerMessageState extends State<ManagerMessage> {
  final TextEditingController _controller = TextEditingController();

  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: FractionalOffset(1.0, -1.0),
            end: FractionalOffset(-1.0, -1.0),
            colors: [
              Colors.amber,
              Colors.orangeAccent,
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
              offset: Offset(4, 3),
            )
          ],
        )
            : BoxDecoration(
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
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //new orders
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => NewOrdersScreen())));
            }

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  bool _productCheck = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _toggleDeliveryStatus(bool? newValue) async {
    if (newValue != null) {
      setState(() {
        _productCheck = newValue;
      });

      // Update the status on Firebase
      await _firestore.collection('Check').doc(widget.userId).set({
        'productAvailability': _productCheck ? 'NoMoreOrders' : 'normal',

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // final userIdProvider = Provider.of<UserIdProvider>(context);
    // userId= userIdProvider.userId;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(

        flexibleSpace: Container(
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
        ),
        title: Text(
          //"Welcome " + sharedPreferences!.getString("name")!.toUpperCase(),
          "Message" .toUpperCase(),
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,

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
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Text(
              ' Set Orders Availability',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontFamily: "Acme",
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Normal'),
                    value: false,
                    groupValue: _productCheck,
                    onChanged: _toggleDeliveryStatus,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('No more Orders'),
                    value: true,
                    groupValue: _productCheck,
                    onChanged: _toggleDeliveryStatus,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            SizedBox(
              height: height*0.02,
            ),
            Text(
              ' Set Orders Availability',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontFamily: "Acme",
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.black,
                    size: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => Manager_Rider_Screen(userID: widget.userId,)),
                        ),
                      );
                    //  takeImage(context);
                    },
                    child: Text(
                      "Collect Rider's Amount",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Divider(
              thickness: 2,
              color: Colors.grey,
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseManagementPage(),
                  ),
                );
                // Show the rider's progress and order status
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Rider Progress and Order Status')),
                // );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber, // Set the button's color to amber
              ),
              child: Text('Add expenses'

                ,style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ShowRiderProgress(
                //       orderID: order.id,
                //       riderID: order.assignedRider,
                //     ),
                //   ),
                // );
                // Show the rider's progress and order status
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Rider Progress and Order Status')),
                // );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber, // Set the button's color to amber
              ),
              child: Text('Show Rider Progress'

                ,style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}

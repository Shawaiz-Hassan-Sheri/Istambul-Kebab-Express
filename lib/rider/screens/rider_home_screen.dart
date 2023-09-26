import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_food_app/rider/assistantMethods/get_current_location.dart';
import 'package:users_food_app/rider/screens/earnings_screen.dart';
import 'package:users_food_app/rider/screens/delivering_order.dart';
import 'package:users_food_app/rider/screens/new_orders_screen.dart';
import 'package:users_food_app/rider/screens/order_delivered_screen.dart';
import 'package:users_food_app/rider/screens/parcel_in_progress_screen.dart';
import '../../authentication/login.dart';
import '../../user/widgets/userIdProvider.dart';
import '../global/global.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({Key? key}) : super(key: key);
  @override
  _RiderHomeScreenState createState() => _RiderHomeScreenState();
}
class _RiderHomeScreenState extends State<RiderHomeScreen> {
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
            if (index == 1) {
              //Parcels in progress
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderInProgressScreen()));
            }
            if (index == 2) {
              //not yet delivered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDeliveredScreen(userid: userId,)));
            }
            if (index == 3) {
              //history
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DeliveringOrder()));
            }
            if (index == 4) {
              //total earnings
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EarningsScreen()));
            }
            if (index == 5) {
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
              //logout
              // firebaseAuth.signOut().then((value) {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: ((context) => const LoginScreen())));
              // });
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

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrenLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
    _getCurrentUser();

  }
  bool _isOnDelivery = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _toggleDeliveryStatus(bool? newValue) async {
    if (newValue != null) {
      setState(() {
        _isOnDelivery = newValue;
      });

      // Update the status on Firebase
      await _firestore.collection('Rider').doc(userId).update({
        'RiderAvailability': _isOnDelivery ? 'onDelivery' : 'normal',
      });
    }
  }
  // Future<void> _toggleDeliveryStatus(bool newValue) async {
  //   setState(() {
  //     _isOnDelivery = newValue;
  //   });
  //
  //   // Update the status on Firebase
  //   await _firestore.collection('Rider').doc('riderID').update({
  //     'RiderAvailability': _isOnDelivery ? 'onDelivery' : 'normal',
  //   });
  // }
  FirebaseAuth _auth = FirebaseAuth.instance;

  String userId = '';
  void _getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  getRiderPreviousEarnings() {
    // FirebaseFirestore.instance
    //     .collection("riders")
    //     .doc(sharedPreferences!.getString("uid"))
    //     .get()
    //     .then((snap) {
    //   previousRiderEarnings = snap.data()!["earnings"].toString();
    // });
    final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
          .collection("Rider")
          .doc(firebaseUid)
          .get()
          .then((snap) {
        previousRiderEarnings = snap.data()!["RiderEarnings"].toString();
      });

  }
  //method to calculate amount per delivery
  getPerParcelDeliveryAmount() {
    // FirebaseFirestore.instance
    //     .collection("perDelivery")
    //     .doc("taydinadnan")
    //     .get()
    //     .then((snap) {
    //   perParcelDeliveryAmount = snap.data()!["amount"].toString();
    //});
    FirebaseFirestore.instance
            .collection("OfflineOrders")
            .doc()
            .get()
            .then((snap) {
          perParcelDeliveryAmount = snap.data()!["TotalCost"].toString();
        });
  }

  @override
  Widget build(BuildContext context) {
    // final userIdProvider = Provider.of<UserIdProvider>(context);
    // userId= userIdProvider.userId;
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
          "Welcome Rider" .toUpperCase(),
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(80),
                  ),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(1),
                          offset: const Offset(-1, 2),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      //we get the profile image from sharedPreferences (global.dart)
                      backgroundImage: NetworkImage(
                        "https://www.shutterstock.com/image-vector/rider-front-view-on-yellow-260nw-2133689475.jpg"
                        //sharedPreferences!.getString("photoUrl")!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
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
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('On Delivery'),
                    value: false,
                    groupValue: _isOnDelivery,
                    onChanged: _toggleDeliveryStatus,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: Text('Normal'),
                    value: true,
                    groupValue: _isOnDelivery,
                    onChanged: _toggleDeliveryStatus,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpinKitWave(
                  type: SpinKitWaveType.center,
                  color: Colors.black87,
                  size: 30.0,
                ),
                Text(
                  '15',
                  style: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.w400

                      , color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () => _makePhoneCall(context,'15'),
                  child: Text('Call Now'),
                ),
              ],
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(2),
                children: [
                  makeDashboardItem("New Available", Icons.assignment, 0),
                  makeDashboardItem("Orders in Progress", Icons.airport_shuttle, 1),
                  makeDashboardItem("Delivered", Icons.location_history, 2),
                  makeDashboardItem("Delivering Order", Icons.done_all, 3),
                  makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
                  makeDashboardItem("Logout", Icons.logout, 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _makePhoneCall(BuildContext context,phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make the call. Please try again later.')),
      );
    }
  }
}

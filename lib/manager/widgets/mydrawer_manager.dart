import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/authentication/login.dart';
import 'package:users_food_app/manager/screens/manager_message.dart';
import 'package:users_food_app/user/global/global.dart';
import 'package:users_food_app/user/screens/history_screen.dart';
import 'package:users_food_app/user/screens/home_screen.dart';
import 'package:users_food_app/user/screens/my_orders_screen.dart';
import 'package:users_food_app/user/screens/search_screen.dart';

import '../screens/invoice/invoice_list_screen.dart';
import '../screens/manager_bottom_navigationbar.dart';
import '../screens/manager_history_screen.dart';




class MyDrawerManager extends StatefulWidget {
  late final empName1;
  late final empPhotourl1;
  final String userid;

  MyDrawerManager({ required this.userid ,this.empName1,this.empPhotourl1});

  @override
  State<MyDrawerManager> createState() => _MyDrawerManagerState();
}

class _MyDrawerManagerState extends State<MyDrawerManager> {

  final TextEditingController _controller = TextEditingController();
  // late final _empName;
  // late final _empPhotourl;
  // final  String  firebaseUid =FirebaseAuth.instance.currentUser!.uid;
  // late User1 userEmployee;
  //
  // void  getSpecificDataFromFirebase() async {
  //   final documentRef = await FirebaseFirestore.instance.collection('User').doc(firebaseUid);
  //   final documentSnapshot = await documentRef.get();
  //   _empName = documentSnapshot.data()![userEmployee.UserName];
  //   _empPhotourl = documentSnapshot.data()![userEmployee.UserPhotoUrl];
  // }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getSpecificDataFromFirebase();
  // }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
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
        child: ListView(
          children: [
            //header drawer
            Container(
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: [
                  Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(80),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: SizedBox(
                        height: 160,
                        width: 160,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                offset: const Offset(-1, 10),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            //we get the profile image from sharedPreferences (global.dart)
                            // backgroundImage: NetworkImage(
                            //   sharedPreferences!.getString("photoUrl")!,
                            // ),
                            backgroundImage: NetworkImage(
                                widget.empPhotourl1
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //we get the user name from sharedPreferences (global.dart)
                  Text(
                    //sharedPreferences!.getString("name")!,
                    widget.empName1,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            //body drawer
            Container(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  const Divider(height: 10, color: Colors.white, thickness: 2),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Home',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ManagerBottomNavigation()),
                        ),
                      );
                    },
                  ),
                  // const Divider(height: 10, color: Colors.white, thickness: 2),
                  // ListTile(
                  //   leading: const Icon(
                  //     Icons.reorder,
                  //     color: Colors.black,
                  //     size: 25,
                  //   ),
                  //   title: Text(
                  //     'Invoices',
                  //     style: GoogleFonts.lato(
                  //       textStyle: const TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (c) => InvoiceListScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  const Divider(height: 10, color: Colors.white, thickness: 2),
                  ListTile(
                    leading: const Icon(
                      Icons.access_time,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'History',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ManagerHistoryScreen(userid: widget.userid,)),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 10, color: Colors.white, thickness: 2),
                  ListTile(
                    leading: const Icon(
                      Icons.message,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Message',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ManagerMessage(userId: widget.userid,)),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 10, color: Colors.white, thickness: 2),
                   ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Sign Out',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      firebaseAuth.signOut().then((value) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                        _controller.clear();
                      });
                    },
                  ),
                  const Divider(height: 10, color: Colors.white, thickness: 2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

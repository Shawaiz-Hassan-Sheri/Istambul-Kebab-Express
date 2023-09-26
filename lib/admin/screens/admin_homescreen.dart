import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/admin/models/admin_employee.dart';
import 'package:users_food_app/admin/widgets/admin_mydrawer.dart';

import '../../authentication/login.dart';
import '../../user/models/menus.dart';
import '../../user/models/sellers.dart';
import '../../user/widgets/design/sellers_design.dart';
import '../../user/widgets/progress_bar.dart';
import '../../user/widgets/user_info.dart';
import '../widgets/admin_user_info.dart';
import 'admin_add_employee.dart';
import 'admin_add_item_screen.dart';
import 'admin_employee_screen.dart';
import 'admin_menu_items.dart';
import 'admin_reports_page.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shawaiz Dev',
      home: AdminHome(),
    );
  }
}
class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  @override
  _AdminHomeState createState() => _AdminHomeState();
}
class _AdminHomeState extends State<AdminHome> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  late final Menus model;

  @override
  void initState() {
    super.initState();
    //clearCartNow(context);

  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

    void _openDrawer() {
      _scaffoldKey.currentState?.openDrawer();
    }

    void _closeDrawer() {
      Navigator.of(context).pop();
    }

    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        drawer: AdminMyDrawer(),

        body: Container(
          height: height,
          width: width,
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
              SliverAppBar(
                elevation: 1,
                pinned: true,
                backgroundColor: const Color(0xFFFAC898),
                foregroundColor: Colors.black,
                expandedHeight: 50,
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
                ),
                title: Text(
                  'Istanbul Kebab Express',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      overflow: TextOverflow.visible,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => LoginScreen()),
                                (Route<dynamic> route) => false,
                          );
                          _controller.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                            child: const Icon(Icons.menu),
                          ),
                          onTap: () {
                            _openDrawer;
                          },
                        ),
                        Text(
                          'Istanbul Kebab Express',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        GestureDetector(
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
                              _controller.clear();
                            });
                          },
                        ),
                      ],
                    ),*/
                    Container(
                      child: AdminUserInformation(

                      ),
                    ),

                    SizedBox(
                      height: height*0.03,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => AdminMenuItems(),
                          ),
                        );
                      },
                      child: Container(
                        height: height*0.12,
                        width: width*0.4,
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
                              height: height*0.007,
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
                      height: height*0.03,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => AdminEmployeeScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: height*0.12,
                        width: width*0.4,
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
                              child: Image.asset(
                                "images/people.png",
                                height: 35,
                              ),
                            ),
                            SizedBox(
                              height: height*0.007,
                            ),
                            Center(
                              child: Text(
                                " Employees ",
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
                      height: height*0.03,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => ReportsPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: height*0.12,
                        width: width*0.4,
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
                              child: Image.asset(
                                "images/report.png",
                                height: 30,
                              ),
                            ),
                            SizedBox(
                              height: height*0.007,
                            ),
                            Center(
                              child: Text(
                                " Reports ",
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

                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
            icon: Icons.add,
            backgroundColor: Colors.amber,
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            children: [

              SpeedDialChild(
                child: const Icon(Icons.person_add,color: Colors.black),
                label: 'Add Employee',
                backgroundColor: Colors.amber,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => AdminAddEmployee(),
                    ),
                  );

                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.add_business,color: Colors.black),
                label: 'Add Item',
                backgroundColor: Colors.amber,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => AdminAddItemScreen(),
                    ),
                  );

                },
              ),
            ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/admin/screens/admin_homescreen.dart';

import '../../authentication/login.dart';
import '../../user/global/global.dart';

class AdminMyDrawer extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

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
                            backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/2206/2206368.png"
                             // sharedPreferences!.getString("photoUrl")!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //we get the user name from sharedPreferences (global.dart)
                  Text(
                    "Admin Name: Admin",
                    //sharedPreferences!.getString("name")!,
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
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) => AdminHomeScreen()),
                            (Route<dynamic> route) => false,
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

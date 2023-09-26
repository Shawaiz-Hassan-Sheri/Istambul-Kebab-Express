import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/authentication/register.dart';
import 'package:users_food_app/user/screens/check.dart';

import '../admin/screens/admin_homescreen.dart';
import '../rider/screens/rider_home_screen.dart';
import '../user/global/global.dart';
import '../manager/screens/manager_bottom_navigationbar.dart';
import '../user/widgets/bottom_navigationbar.dart';
import '../user/widgets/custom_text_field.dart';
import '../user/widgets/error_dialog.dart';
import '../user/widgets/loading_dialog.dart';
import '../user/widgets/login_header_widget.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double _headerHeight = 250;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

String _roleSelected='User';
  // For roles set
void setRoles(String v){


  WidgetsBinding.instance.addPostFrameCallback((_) {

    setState(() {
      _roleSelected=v.toString();
    });

  });
}

// depend on roles navigation
  Future<void> _signInWithEmailAndPasswordAndGoToScreen() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Check the user's role in Firestore and navigate to the appropriate screen
      FirebaseFirestore.instance
          .collection('Employee')
          .doc(userCredential.user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data()! as Map<String, dynamic>?;
          if (data!['EmployeeRole'] == 'User') {
            //Navigator.pushNamed(context, '/student');

          }else if (data['EmployeeRole'] == ' ') {
            Route newRoute = MaterialPageRoute(builder: (c) => const AdminHomeScreen());
            Navigator.pushReplacement(context, newRoute);
          } else if (data['EmployeeRole'] == 'Rider') {
            Route newRoute = MaterialPageRoute(builder: (c) => const RiderHomeScreen());
            Navigator.pushReplacement(context, newRoute);
          }else if (data['EmployeeRole'] == 'Manager') {
            Route newRoute = MaterialPageRoute(builder: (c) =>  ManagerBottomNavigation());
            Navigator.pushReplacement(context, newRoute);
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }


//form validation for login
  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorDialog(
            message: "Please enter email/password.",
          );
        },
      );
    }
  }

//login function
  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingDialog(
          message: "Checking Credentials...",
        );
      },
    );

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then(
      (auth) {
        currentUser = auth.user!;
      },
    ).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString(),
          );
        },
      );
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
    }
  }

//read data from firestore and save it locally
  Future readDataAndSetDataLocally(User currentUser) async {
    await _roleSelected.toString()=="User"?FirebaseFirestore.instance
        .collection("User")
        .doc(currentUser.uid)
        .get()
        .then(
          (snapshot) async {
        //check if the user is user
        if (snapshot.exists) {
          if (snapshot.data()!["UserStatus"] == "approved") {
            // await sharedPreferences!.setString("uid", currentUser.uid);
            // await sharedPreferences!
            //     .setString("email", snapshot.data()!["UserEmail"]);
            // await sharedPreferences!
            //     .setString("name", snapshot.data()!["UserName"]);
            // await sharedPreferences!
            //     .setString("photoUrl", snapshot.data()!["UserPhotoUrl"]);
            // List<String> userCartList =
            // snapshot.data()!["userCart"].cast<String>();
            // await sharedPreferences!.setStringList("UserCart", userCartList);

            Navigator.pop(context);
            FirebaseFirestore.instance
                .collection('User')
                .doc(currentUser.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                // Map<String, dynamic>? data = documentSnapshot.data()! as Map<String, dynamic>?;
                // if (data!['UserRole'] == 'User') {
                //   //Navigator.pushNamed(context, '/student');
                //   Route newRoute = MaterialPageRoute(builder: (c) =>  HomeBottomNavigation());
                //   Navigator.pushReplacement(context, newRoute);
                // }
               Route newRoute = MaterialPageRoute(builder: (c) =>  HomeBottomNavigation());
                  Navigator.pushReplacement(context, newRoute);

              }
            });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (c) => HomeScreen(),
            //   ),
            // );
          } else {
            firebaseAuth.signOut();
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Your account has been blocked!");
          }
        }
        //if user is not a user
        else {
          firebaseAuth.signOut();
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const LoginScreen(),
            ),
          );
          showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "No record exist.",
              );
            },
          );
        }
      },
    ):FirebaseFirestore.instance
        .collection("Employee")
        .doc(currentUser.uid)
        .get()
        .then(
          (snapshot) async {
        //check if the user is user
        if (snapshot.exists) {
          if (snapshot.data()!["EmployeeStatus"] == "approved") {
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!
                .setString("email", snapshot.data()!["EmployeeEmail"]);
            await sharedPreferences!
                .setString("name", snapshot.data()!["EmployeeName"]);
            await sharedPreferences!
                .setString("photoUrl", snapshot.data()!["EmployeeAvatarUrl"]);
            //List<String> userCartList =
            // snapshot.data()!["userCart"].cast<String>();
            // await sharedPreferences!.setStringList("userCart", userCartList);

            Navigator.pop(context);
            FirebaseFirestore.instance
                .collection('Employee')
                .doc(currentUser.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                Map<String, dynamic>? data = documentSnapshot.data()! as Map<String, dynamic>?;
                if (data!['EmployeeRole'] == 'User') {
                  //Navigator.pushNamed(context, '/student');
                  Route newRoute = MaterialPageRoute(builder: (c) =>  HomeBottomNavigation());
                  Navigator.pushReplacement(context, newRoute);

                }else if (data['EmployeeRole'] == 'Admin') {
                  Route newRoute = MaterialPageRoute(builder: (c) => const AdminHomeScreen());
                  Navigator.pushReplacement(context, newRoute);
                } else if (data['EmployeeRole'] == 'Rider') {
                  Route newRoute = MaterialPageRoute(builder: (c) => const RiderHomeScreen());
                  Navigator.pushReplacement(context, newRoute);
                }else if (data['EmployeeRole'] == 'Manager') {
                  Route newRoute = MaterialPageRoute(builder: (c) => ManagerBottomNavigation());
                  Navigator.pushReplacement(context, newRoute);
                }
              }
            });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (c) => HomeScreen(),
            //   ),
            // );
          } else {
            firebaseAuth.signOut();
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Your account has been blocked!");
          }
        }
        //if user is not a user
        else {
          firebaseAuth.signOut();
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const LoginScreen(),
            ),
          );
          showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "No record exist.",
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press event
        // Return true to prevent the app from closing
        // Return false to allow the app to close

        // For example, you can show a dialog asking for confirmation
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    // Pop the dialog and allow the app to continue
                    Navigator.of(dialogContext).pop();
                  },
                ),
                TextButton(
                  child: Text('Exit'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // Close the app completely
                    SystemNavigator.pop();
                    // Pop the dialog and prevent the app from closing


                  },
                ),
              ],
            );
          },
        );

        // Return false by default to allow the app to close
        return false;
      },
      child: Scaffold(

        body: Container(
          height: MediaQuery.of(context).size.height,
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: _headerHeight,
                  child: LoginHeaderWidget(
                    _headerHeight,
                    true,
                    Icons.food_bank,
                      setRoles,
                  ), //let's create a common header widget
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'Login',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        data: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        isObsecre: false,
                      ),
                      CustomTextField(
                        data: Icons.lock,
                        controller: passwordController,
                        hintText: "Password",
                        isObsecre: true,
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                             Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPassword()), );
                          },
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 1.0],
                            colors: [
                              Colors.amber,
                              Colors.black,
                            ],
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(const Size(50, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              'Sign In'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //          Check1(rol: _roleSelected.toString())));
                            formValidation();
                          },
                        ),
                      ),

                      if (_roleSelected.toString()=="User") Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Create',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const RegisterScreen()));
                                  },
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      else Container( ),
                    ],
                  ),
                ),

                // GestureDetector(
                //     onTap: (){
                //       Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (c) => MainScreen(),
                //                 ),
                //               );
                //     },
                //     child: Text("Notification")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/admin/models/admin_employee.dart';
import 'package:users_food_app/admin/models/admin_menu.dart';
import 'package:users_food_app/admin/screens/admin_homescreen.dart';
import '../../user/widgets/simple_app_bar.dart';
import 'package:shimmer/shimmer.dart';
class AdminEmployeeDetailsScreen extends StatefulWidget {
  final AdminEmployee? model;
  AdminEmployeeDetailsScreen({this.model});
  @override
  _AdminEmployeeDetailsScreenState createState() => _AdminEmployeeDetailsScreenState();
}

class _AdminEmployeeDetailsScreenState extends State<AdminEmployeeDetailsScreen> {
  //TextEditingController counterTextEditingController = TextEditingController();

  deleteEmployee(String empUID) async {
    try {
      // Fetch the user by UID
      UserCredential? userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "${widget.model!.employeeEmail}", // Provide a dummy email (required parameter)
        password: "${widget.model!.employeePassword}",   // Provide a dummy password (required parameter)
      );

      User? user = userCredential.user;

      if (user != null && user.uid == empUID) {
        // Delete employee's authentication credentials
        await user.delete();
      } else {
        print("User with UID $empUID not found or not authenticated.");
      }
    } catch (error) {
      // Handle any errors that might occur
      print('Error deleting employee credentials: $error');
    }
    await FirebaseFirestore.instance
        .collection("Employee")
        .doc(empUID)
        .delete()
        .then(
          (value) {
        FirebaseFirestore.instance.collection("Employee").doc(empUID).delete();
        // Navigator.push(context,
        //     MaterialPageRoute(builder: ((context) => const AdminHomeScreen())));

        Fluttertoast.showToast(msg: "Employee Data Deleted Successfully....");
      },
    );
  }
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title:  widget.model!.employeeName!,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: Colors.white,
                height: 250,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                              gradient: LinearGradient(
                                begin: FractionalOffset(1.0, 1.0),
                                end: FractionalOffset(1.0, 1.0),
                                colors: [
                                  Color(0xFFFFFFFF),
                                  Color(0xFFFAC898),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(-1, 10),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _isLoading
                              ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 200,
                              height: 200,
                              color: Colors.white, // Use the background color of your screen
                            ),
                          )
                              :Image.network(
                            widget.model!.employeeAvatarUrl.toString(),
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color(0xFFFAC898),
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.model!.employeeEmail.toString(),
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact: ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '0${widget.model!.employeePhone.toString()}',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Price: ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                             widget.model!.employeeEarnings.toString(),
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: InkWell(
                        onTap: () async {
                          await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Data'),
                              content: Text('Are you sure to delete this data?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                     deleteEmployee(widget.model!.employeeUID!);
                                     Navigator.pop(context);
                                     Navigator.pop(context);
                                  },
                                ),  TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                          );
                          //delete item
                         // deleteItem(widget.model!.employeeUID!);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

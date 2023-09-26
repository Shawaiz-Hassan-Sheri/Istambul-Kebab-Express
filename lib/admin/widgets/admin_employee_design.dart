import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:users_food_app/admin/models/admin_menu.dart';

import '../screens/admin_employee_details_screen.dart';
import '../screens/admin_item_details_screen.dart';

// ignore: must_be_immutable
class AdminEmployeeDesign extends StatefulWidget {
  AdminMenu model;
  String name="";
  BuildContext context;

  AdminEmployeeDesign({Key? key, required this.context, required this.name, required this.model}) : super(key: key);

  @override
  _AdminEmployeeDesignState createState() => _AdminEmployeeDesignState();
}

class _AdminEmployeeDesignState extends State<AdminEmployeeDesign> {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: height*0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.amber,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.model.adminthumbnailUrl!,
                    height: height*0.2,
                    width: width*0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.model!.admintitle!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.model!.adminshortInfo! as String,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (c) => AdminEmployeeDetailsScreen(model: widget.model),
          //   ),
          // );
        });
    //   ),
    // );
  }
}

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/admin/models/admin_employee.dart';
import 'package:users_food_app/user/global/global.dart';

import '../../user/widgets/progress_bar.dart';
import '../models/admin.dart';


class AdminUserInformation extends StatefulWidget {

  BuildContext? context;

   AdminUserInformation({
    this.context,


  });
  @override
  State<AdminUserInformation> createState() => _AdminUserInformationState();
}
late final _empName;
late final _empEmail;
late final _empPhotourl;
class _AdminUserInformationState extends State<AdminUserInformation> {
  double sellerTotalEarnings = 0;
 @override
  void initState()  {
    // TODO: implement initState
    super.initState();
     //getSpecificDataFromFirebase();
  }
 // late Admin adminEmployee;
  // void  getSpecificDataFromFirebase() async {
  //   final documentRef = FirebaseFirestore.instance.collection('Admin').doc('QNAOYbpelwgUas13DMuQucoozW02');
  //   final documentSnapshot = await documentRef.get();
  //   _empName = documentSnapshot.data()![adminEmployee.adminName];
  //   _empEmail = documentSnapshot.data()![adminEmployee.adminEmail];
  //   _empPhotourl = documentSnapshot.data()![adminEmployee.adminAvatarUrl];
  //
  // }

  // final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Employee');
  //
  //
  // Stream<QuerySnapshot<Object?>>? getDocumentStream() {
  //   return collectionReference.where("EmployeeUID", isEqualTo: "Yqe4uHqZSbgbGMJJEh56hHwvfF22").snapshots();
  // }
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('Admin');


  Future<DocumentSnapshot> getDocument() async {
    final DocumentSnapshot documentSnapshot = await collectionReference.doc('QNAOYbpelwgUas13DMuQucoozW02').get();
    return documentSnapshot;
  }

// Function to fetch image from Firebase Firestore
  Future<Uint8List?> getImageFromFirestore(String imageUrl) async {
    try {
      // Create a Firebase Storage instance
      final storage = FirebaseStorage.instance;

      // Get a reference to the image location in Firestore
      final ref = storage.refFromURL(imageUrl);

      // Download the image data
      final bytes = await ref.getData();

      // Return the image data as a Uint8List
      return bytes;
    } catch (e) {
      print('Error fetching image from Firestore: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context)  {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(-1.0, -7.0),
          end: FractionalOffset(5.0, -6.0),
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFAC898),
          ],
        ),
      ),
      child: FutureBuilder<DocumentSnapshot>(
        future: getDocument(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final data = snapshot.data;
              return Column(
                children: [

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    "images/restaurant.png",
                                    height: 30,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  ' ${data!['AdminName']}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              ' ${data!['AdminEmail']}',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade500),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  "Earnings: ",
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  ' ${data!['AdminEarnings']}',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(80),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircleAvatar(
                                //we get the profile image from sharedPreferences (global.dart)
                                backgroundImage: NetworkImage(

                                  '${data!['AdminAvatarUrl']}',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          "images/menu.png",
                          height: 30,
                        ),
                      ),
                      Text(
                        "Menus",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                    ],
                  )

                ],
              );
            }
          }
        },
      )


    );
  }
}
// StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("Employee")
//             .where('EmployeeUID', isEqualTo: 'Yqe4uHqZSbgbGMJJEh56hHwvfF22')
//             .snapshots(),
//
//       ),


/*
child: FutureBuilder<DocumentSnapshot>(
future: getDocument(),
builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return Center(
child: CircularProgressIndicator(),
);
} else {
if (snapshot.hasError) {
return Center(
child: Text('Error: ${snapshot.error}'),
);
} else {
final data = snapshot.data;
return Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
' ${data!['EmployeeName']}',
style: TextStyle(fontSize: 20.0),
),
SizedBox(height: 10.0),

Text(
// 'Field 2: ${data['field2']}'
data['EmployeeEmail'],

style: TextStyle(fontSize: 20.0),
),
],
),
);
}
}
},
)*/



/*
Column(
children: [
Padding(
padding: const EdgeInsets.all(8.0),
child: Text(
"Profile".toUpperCase(),
style: GoogleFonts.lato(
textStyle: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
),
),
const SizedBox(height: 20),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
decoration: BoxDecoration(
color: Colors.amber.withOpacity(0.4),
borderRadius: BorderRadius.circular(15),
),
padding: const EdgeInsets.all(5),
child: Row(
children: [
Container(
child: Image.asset(
"images/user.png",
height: 30,
),
),
const SizedBox(width: 15),
Text(
' $data["EmployeeName"]',
// sharedPreferences!.getString(
//   "name",
// )!,
style: GoogleFonts.lato(
textStyle: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
),
],
),
),
Padding(
padding: const EdgeInsets.all(5),
child: Text(
' $data["EmployeeEmail"]',



// sharedPreferences!.getString("email")!,
style: GoogleFonts.lato(
textStyle: TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Colors.grey.shade500),
),
),
),
],
),
ClipRRect(
borderRadius: BorderRadius.circular(50),
child: Material(
borderRadius: const BorderRadius.all(
Radius.circular(80),
),
elevation: 10,
child: Padding(
padding: const EdgeInsets.all(1),
child: SizedBox(
height: 100,
width: 100,
child: CircleAvatar(
//we get the profile image from sharedPreferences (global.dart)
backgroundImage: NetworkImage(
' $data["EmployeeAvatarUrl"]',
//sharedPreferences!.getString("photoUrl")!,
),
),
),
),
),
),
],
),
const Divider(
thickness: 2,
color: Colors.white,
),

],
);*/

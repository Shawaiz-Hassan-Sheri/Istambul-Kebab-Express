import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';

class UserInformation extends StatefulWidget {
  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  double sellerTotalEarnings = 0;
  final  String  firebaseUid =FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('User');


  Future<DocumentSnapshot> getDocument() async {
    final DocumentSnapshot documentSnapshot = await collectionReference.doc(firebaseUid).get();
    return documentSnapshot;
  }

  @override
  Widget build(BuildContext context) {

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
                                    "images/user.png",
                                    height: 30,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  ' ${data!['UserName']}',
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
                              ' ${data!['UserEmail']}',
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

                                  '${data!['UserPhotoUrl']}',
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
                      Image.asset(
                        "images/menu.png",
                        height: 30,
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
      ),
    );
  }
}
/*
Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
Text(
"Restaurants".toUpperCase(),
style: GoogleFonts.lato(
textStyle: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),
),
Center(
child: Text(
"Meals".toUpperCase(),
style: GoogleFonts.lato(
textStyle: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),
),
),
],
)*/


/*
Container(
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
child: Column(
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
sharedPreferences!.getString(
"name",
)!,
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
sharedPreferences!.getString("email")!,
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
sharedPreferences!.getString("photoUrl")!,
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
Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
Text(
"Restaurants".toUpperCase(),
style: GoogleFonts.lato(
textStyle: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),
),
Center(
child: Text(
"Meals".toUpperCase(),
style: GoogleFonts.lato(
textStyle: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Colors.black,
),
),
),
),
],
)
],
),
);*/

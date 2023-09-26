import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EarningsScreen extends StatefulWidget {
  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = '';
  double earnings = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      _getEarnings();
    }
  }

  void _getEarnings() async{
     await  _firestore.collection('Rider').doc(userId).get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double earningsValue = data['RiderEarnings'] ?? 0;
        setState(() {
          earnings = earningsValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return Scaffold(
     // backgroundColor: const Color(0xFFFAC898),
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              earnings==0?CircularProgressIndicator():Text(
          ' \$${earnings.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 80,
            color: Colors.red,
            fontFamily: "Signatra",
          ),
        ),
              const SizedBox(height: 10),
              const Text(
                "Total Earnings ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),
              const SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }
}

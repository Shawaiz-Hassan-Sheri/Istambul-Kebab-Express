
import 'package:flutter/material.dart';

import '../authentication/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      gotoLogin();
    });
  }

  void gotoLogin() async {

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>LoginScreen()), (Route<dynamic> route) => false);

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.amber.withOpacity(0.4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:  Center(
          child: Container(
            height:height*0.4 ,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Image.asset('images/welcome.png'),
          ),
        ),
    );
  }
}

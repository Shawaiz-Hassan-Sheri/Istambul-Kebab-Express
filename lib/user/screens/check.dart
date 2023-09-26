import 'package:flutter/material.dart';

class Check1 extends StatefulWidget {
  String rol;
   Check1({Key? key,required this.rol}) : super(key: key);

  @override
  State<Check1> createState() => _Check1State();
}

class _Check1State extends State<Check1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Container(
          child: Text(widget.rol),
        ),
      ),
    );
  }
}

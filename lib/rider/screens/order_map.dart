import 'package:flutter/material.dart';

class OrderMap extends StatefulWidget {
   final double latitude;
   final double longitude;

  OrderMap({required this.latitude,required this.longitude});

  @override
  State<OrderMap> createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

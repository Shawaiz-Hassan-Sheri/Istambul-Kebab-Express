
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/user/screens/home_screen.dart';
import 'package:users_food_app/user/screens/item_detail_screen.dart';
import 'package:users_food_app/user/screens/items_screen.dart';

import '../../user/models/cart.dart';
import 'manager_offline_orders.dart';
import 'manager_online_orders.dart';


class ManagerBottomNavigation extends StatefulWidget {

  @override
  _ManagerBottomNavigationState createState() => _ManagerBottomNavigationState();
}

class _ManagerBottomNavigationState extends State<ManagerBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [    ManagerOfflineOrders(),    ManagerOnlineOrders()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider1>(context);
    int itemCount = cartProvider.counter;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My App'),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Offline Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Online Orders',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Cart',
          // ),


        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}

/*
class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({Key? key}) : super(key: key);

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Manager",style: TextStyle(
            color: Colors.black,
            fontSize: 25
        ),),
      ),
    );
  }
}*/

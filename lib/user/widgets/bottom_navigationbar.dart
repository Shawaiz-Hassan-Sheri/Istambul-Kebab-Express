import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/user/screens/home_screen.dart';
import 'package:users_food_app/user/screens/item_detail_screen.dart';
import 'package:users_food_app/user/screens/items_screen.dart';
import 'package:users_food_app/user/widgets/userIdProvider.dart';

import '../../notused.dart';
import '../cart/cart_provider.dart';
import '../models/cart.dart';
import '../screens/cart_screen.dart';
import '../screens/item_screen_bottom.dart';
import '../screens/profile_screen.dart';

class HomeBottomNavigation extends StatefulWidget {
  @override
  _HomeBottomNavigationState createState() => _HomeBottomNavigationState();
}

class _HomeBottomNavigationState extends State<HomeBottomNavigation> {
  int _selectedIndex = 0;


  final List<Widget> _pages = [    HomeScreen(),    ItemsScreenBottom(),CartScreenn() ,ProfileScreennotused()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My App'),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.food_bank),
          //   label: 'Food Menu',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Cart',
          // ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (Provider.of<CartProvider1>(context).counter!= 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${Provider.of<CartProvider1>(context).counter}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Profile ',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}


import 'dart:ffi';

import 'package:flutter/material.dart';

import 'items.dart';

class CartItem1 {
  String? title;
  int quantity;
  int? price;
  String? imageUrl;
  String? itemID;
  int?  totalPrice;

  CartItem1({
    this.title,
    required this.quantity,
    this.price,
    this.imageUrl,
    this.itemID,
    this.totalPrice

  });
}
class CartItem2 {
  String? title;
  int quantity;
  int? price;
  String? imageUrl;
  String? itemID;
  int? totalPrice;

  CartItem2({
    this.title,
    required this.quantity,
    this.price,
    this.imageUrl,
    this.itemID,
    this.totalPrice

  });
}
class CartProvider1 with ChangeNotifier {
  List<CartItem1> _items = [];
  late int counter=0;
   void  setcounter(int a){

     counter=0;
     notifyListeners();
   }

  int get counter1=>counter;
  List<CartItem1> get items => _items;
  //  Set<CartItem1>  get items {
  //    return {..._items};
  //  }
  void addToCart(Items cartItem,int _cartCounter) {
    // Check if the pizza item is already in the cart
    bool exists = false;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].title == cartItem.title) {
        exists = true;
        _items[i].quantity++;
        break;
      }
    }
    counter++;
    // If the pizza item is not in the cart, add it with quantity 1
    if (!exists) {
      _items.add(CartItem1(
          price: cartItem.price,
          title: cartItem.title,
          imageUrl: cartItem.thumbnailUrl,
          totalPrice: cartItem.totalPrice,
          //quantity: cartItem.quantity! ,
          quantity: _cartCounter ,
          itemID: cartItem.itemID
        //quantity: carItem.,

      ));
    }

    // Notify listeners of the change
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    counter=0;
    notifyListeners();
  }

  void removeFromCart(CartItem1 item) {
    _items.remove(item);
    notifyListeners();
  }
}
class CartProvider2 with ChangeNotifier {
  List<CartItem2> _items = [];
  late int counter=0;
  void  setcounter(int a){

    counter=0;
    notifyListeners();
  }

  int get counter2=>counter;
  List<CartItem2> get items => _items;
  //  Set<CartItem1>  get items {
  //    return {..._items};
  //  }
  void addToCart(Items cartItem,int _cartCounter) {
    // Check if the pizza item is already in the cart
    bool exists = false;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].title == cartItem.title) {
        exists = true;
        _items[i].quantity++;
        break;
      }
    }
    counter++;
    // If the pizza item is not in the cart, add it with quantity 1
    if (!exists) {
      _items.add(CartItem2(
          price: cartItem.price,
          title: cartItem.title,
          imageUrl: cartItem.thumbnailUrl,
          //quantity: cartItem.quantity! ,
          quantity: _cartCounter ,
          itemID: cartItem.itemID
        //quantity: carItem.,

      ));
    }

    // Notify listeners of the change
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    counter=0;
    notifyListeners();
  }

  void removeFromCart(CartItem2 item) {
    _items.remove(item);
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(PizzaItem pizza) {
    // Check if the pizza item is already in the cart
    bool exists = false;
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].pizza.name == pizza.name) {
        exists = true;
        _items[i].quantity++;
        break;
      }
    }

    // If the pizza item is not in the cart, add it with quantity 1
    if (!exists) {
      _items.add(CartItem(pizza: pizza));
    }

    // Notify listeners of the change
    notifyListeners();
  }

  void clearCart() {
    _items = [];
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  Future<void> saveCart(String userId) async {
    // Create a new collection for the cart items
    CollectionReference cartCollection =
    FirebaseFirestore.instance.collection('carts');

    // Create a new document for the user's cart
    DocumentReference cartDoc = cartCollection.doc(userId);

    // Convert the cart items to a list of maps
    List<Map<String, dynamic>> cartItems =
    _items.map((item) => {'name': item.pizza.name, 'quantity': item.quantity}).toList();


    // Save the cart items to Firestore
    await cartDoc.set({'items': cartItems});
  }

  Future<void> loadCart(String userId) async {
    // // Create a reference to the user's cart document
    // DocumentReference cartDoc =
    //     FirebaseFirestore.instance.collection('carts').doc(userId);
    //
    // // Load the cart items from Firestore
    // DocumentSnapshot cartSnapshot = await cartDoc.get();
    // if (cartSnapshot.exists) {
    //   List<Map<String, dynamic>> cartItems =
    //       List<Map<String, dynamic>>.from(cartSnapshot.data()!['items']);
    //
    //   // Convert the list of maps back to CartItem objects
    //   _items = cartItems.map((item) {
    //     PizzaItem pizza =
    //         _items.firstWhere((item) => item.name == item['name']) as PizzaItem;
    //     ;
    //     return CartItem(pizza: pizza, quantity: item['quantity']);
    //   }).toList();
    // }
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }


  Future<void> s1aveCart(List<CartItem> cartItems) async {
    final cartRef = FirebaseFirestore.instance.collection('addtocart');

    // Create a new document with a unique ID
    final newCartDocRef = cartRef.doc();

    // Map each CartItem to a Map<String, dynamic> representation
    final cartData = cartItems.map((item) => {
      'name': item.pizza.name,
      'imageUrl': item.pizza.imageUrl,
      'price': item.pizza.price,
      'quantity': item.quantity,
    }).toList();

    // Set the data of the new document to the cartData array
    await newCartDocRef.set({
      'cartData': cartData,
      'timestamp': FieldValue.serverTimestamp(), // optional timestamp field
    });

    print('Cart saved to Firestore!');
  }




}

class PizzaItem {
  final String name;
  final String imageUrl;
  final double price;

  PizzaItem({
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class CartItem {
  final PizzaItem pizza;
  int quantity;

  CartItem({required this.pizza, this.quantity = 1});
}

class FoodMenu extends StatelessWidget {
  final List<PizzaItem> pizzaItems = [
    PizzaItem(
      name: 'Margherita',
      imageUrl: 'https://via.placeholder.com/150',
      price: 5.99,
    ),
    PizzaItem(
      name: 'Pepperoni',
      imageUrl: 'https://via.placeholder.com/150',
      price: 7.99,
    ),
    PizzaItem(
      name: 'Vegetarian',
      imageUrl: 'https://via.placeholder.com/150',
      price: 6.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pizzaItems.length,
      itemBuilder: (context, index) {
        PizzaItem pizza = pizzaItems[index];
        return ListTile(
          title: Text(pizza.name),
          subtitle: Text('\$${pizza.price}'),
          trailing: ElevatedButton(
            child: Icon(Icons.shopping_cart),
            onPressed: () {


              CartProvider cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              cartProvider.addToCart(pizza);
            },
          ),
        );
      },
    );
  }
}

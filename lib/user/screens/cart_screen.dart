import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/user/models/items.dart';
import '../models/cart.dart';
import 'item_detail_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CartScreenn extends StatefulWidget {
  @override
  State<CartScreenn> createState() => _CartScreennState();
}

class _CartScreennState extends State<CartScreenn> {
  // ignore: non_constant_identifier_names
  int totalPrice = 0;
  List<Items> selectedItems = [];
  Future<int?> PlaceOrder() async {
    final currentUser = await FirebaseAuth.instance.currentUser;
    CartProvider1 cartProvider =
        await Provider.of<CartProvider1>(context, listen: false);
    List<CartItem1> listitems = cartProvider.items;
    try {
      if (currentUser != null) {
        // final cartRef = FirebaseFirestore.instance
        //     .collection('User')
        //     .doc(currentUser.uid)
        //     .collection('Cart')
        //     .doc();
        final orders = FirebaseFirestore.instance.collection('Orders').doc();

        //----------------------------------------------
        // FirebaseFirestore.instance.collection("User").doc(userUid).update({
        //   "UserName": userName.text,
        //   "UserPhoneNumber": phoneNumber.text,
        //   "UserPhotoUrl": imageMap,
        // });
        // Map each CartItem to a Map<String, dynamic> representation
        final cartData = listitems
            .map((item) => {
                  'name': item.title,
                  'imageUrl': item.imageUrl,
                  'price': item.price,
                  'quantity': item.quantity,
                  'totalPrice': item.price! * item.quantity!,
                })
            .toList();
        print("/////////////////    before total price  ");
        totalPrice = 0;
        //  selectedItems = (await listitems.map((item) => {
        //   'price': item.price,
        //   'quantity': item.quantity,
        //   'totalPrice': item.price! * item.quantity!,
        // })).cast<Items>().toList();

        selectedItems = await Future.wait(
          listitems.map((item) async {
            int? price = item.price;
            int quantity = item.quantity;
            int totalPrice = price! * quantity;
            return Items(
                price: price, quantity: quantity, totalPrice: totalPrice);
          }),
        );
        for (Items item in selectedItems) {
          // totalPrice = ((item.price!.toDouble() * item.quantity!.toDouble()) + totalPrice as Double) as Double;
          totalPrice = ((item.price! * item.quantity!) + totalPrice);
        }

        // Set the data of the new document to the cartData array
        // await cartRef.set({
        //   'latitude': _latitude,
        //   'longitude': _longitude,
        //   'cartData': cartData,
        //   'timestamp': FieldValue.serverTimestamp(), // optional timestamp field
        // });
        await orders.set({
          'status': 'Normal',
          'latitude': _latitude,
          'longitude': _longitude,
          'TotalCost': totalPrice,
          'orderItems': cartData,
          'orderUserUID': currentUser.uid,
          'timestamp': FieldValue.serverTimestamp(), // optional timestamp field
        });

        print('Cart saved to Firestore!');
        //------------------------------------------------------

        await Fluttertoast.showToast(
            msg: "Order Placed Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        final cartProvider1 = await Provider.of<CartProvider1>(context);
        setState(() {
          cartProvider1.setcounter(0);
          totalPrice = 0;
          selectedItems.clear();
        });
      }
      return 1;
    } catch (e) {
      print('Error saving items: $e');
    }
  }

  /*//saving seller information to firestore
  Future saveCartToFirestore(User currentUser) async {
    final CollectionReference itemsCollection = await FirebaseFirestore.instance.collection('Cart');
    try {
      CartProvider1 cartProvider =
      Provider.of<CartProvider1>(context, listen: false);
      List<CartItem1> listitems=cartProvider.items;

      await itemsCollection.doc(currentUser.uid).set({
        'items': listitems.,
        'id': currentUser.uid,
      });
      print('Items saved successfully');
      Fluttertoast.showToast(
          msg: "Order Placed Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } catch (e) {
      print('Error saving items: $e');
    }
    // FirebaseFirestore.instance.collection("Cart").doc(currentUser.uid).set(
    //   {
    //     "UserUid": currentUser.uid,
    //     "UserEmail": currentUser.email,
    //
    //   },
    // );

    // // save data locally (to access data easly from phone storage)
    // sharedPreferences = await SharedPreferences.getInstance();
    // await sharedPreferences!.setString("uid", currentUser.uid);
    // await sharedPreferences!.setString("email", currentUser.email.toString());
    // await sharedPreferences!.setString("name", nameController.text.trim());
    // await sharedPreferences!.setString("photoUrl", userImageUrl);
    // await sharedPreferences!.setStringList(
    //     "userCart", ['garbageValue']); //empty cart list while registration
  }*/
  double? _latitude;
  double? _longitude;

  // Function to pick current location
  bool _locationServiceEnabled = false;
  bool _fetchingLocation = false;
  LatLng? _currentLocation;
  bool check = false;
  // Location
  Position? position;
  List<Placemark>? placeMarks;
  TextEditingController locationController = TextEditingController();
  // Address name variable
  String completeAddress = "";

 /* Future<Position?> getCurrenLocation() async {
    setState(() {
      check = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;
    _latitude = newPosition.latitude;
    _longitude = newPosition.longitude;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
        '${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';

    locationController.text = completeAddress;
    setState(() {
      check = false;
    });
    Navigator.pop(context);
  }
*/
  Future<void> getCurrenLocation() async {
    setState(() {
      check = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        check = false;
      });
      // Show a dialog to prompt user to enable location services
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Services Disabled'),
            content: Text('Please enable location services to proceed.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          check = false;
        });
        // Show a dialog to inform user about the denied permission
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Permission Denied'),
              content: Text('Please grant location permission to proceed.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    // Check if permission is denied forever
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        check = false;
      });
      // Show a dialog to inform user about permanently denied permission
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Denied'),
            content: Text('Location permissions are permanently denied, we cannot proceed.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Get current position
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );


    position = newPosition;
    _latitude = newPosition.latitude;
    _longitude = newPosition.longitude;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
    '${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';

    locationController.text = completeAddress;
    setState(() {
      check = false;
    });
    Navigator.pop(context);

  }

  late GoogleMapController _mapController;
  // Function to pick location from map
  void _pickLocationFromMap() async {
    LatLng pickedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: Text('Pick Location')),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.422, -122.084), // Initial map position
              zoom: 15,
            ),
            onTap: (LatLng location) {
              setState(() {
                _latitude = location.latitude;
                _longitude = location.longitude;
              });
              Navigator.of(ctx).pop(location); // Return the picked location
            },
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _mapController = controller;
              });
            },
          ),
        ),
      ),
    );
    if (pickedLocation != null) {
      // Update the latitude and longitude variables
      setState(() {
        _latitude = pickedLocation.latitude;
        _longitude = pickedLocation.longitude;
      });
    }
  }

  // Function to place order
  void _placeOrder() async {
    // Check if all fields are filled
    if (_latitude != null && _longitude != null) {
      // Add the order details to Firebase Firestore
      // Use the Firebase Firestore package to add the order details
      // You can use the Firestore.instance.collection('orders').add() method to add a new document
      // with the order details and latitude/longitude as fields
      // Show success/error messages using AlertDialog or SnackBar
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all fields and pick a location.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CartItem1> itemsnow =
        Provider.of<CartProvider1>(context, listen: true).items;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text("Add to Cart ITEMS"),
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // border color
                    width: 2, // border width
                  ),
                  borderRadius: BorderRadius.circular(10), // border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, // shadow color
                      offset: Offset(0, 2), // shadow offset
                      blurRadius: 5, // shadow blur radius
                    ),
                  ],
                ),
                height: 400,
                child: ListView.builder(
                    itemCount: itemsnow.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // border color
                            width: 2, // border width
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade50, // shadow color
                              offset: Offset(0, 2), // shadow offset
                              blurRadius: 5, // shadow blur radius
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(itemsnow[index].title as String),
                          subtitle: Text('\$${itemsnow[index].price}'),
                          trailing: ElevatedButton(
                            child: Icon(Icons.shopping_cart),
                            onPressed: () {
                              // CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
                              // cartProvider.addToCart(pizza);
                            },
                          ),
                        ),
                      );
                    }),
              ),

              SingleChildScrollView(
                child: Container(
                  height: height * 0.25,
                  child: Column(
                    children: [
                      Text(
                        "${locationController.text}",
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      check
                          ? CircularProgressIndicator()
                          : Center(
                        child: Container(),
                              // child: TextButton.icon(
                              //   onPressed: () {
                              //     getCurrenLocation();
                              //   },
                              //   icon: const Icon(
                              //     Icons.location_on,
                              //     size: 40,
                              //     color: Colors.red,
                              //   ),
                              //   label: Text("Pick Current Location"),
                              // ),
                            ),
                      itemsnow.length == 0
                          ? Container()
                      :ElevatedButton(
                        child: Text('Choose Location'),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  width: width,
                                  height: height * 0.4,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: ElevatedButton(
                                            child:
                                                Text('Pick Current Location'),
                                            onPressed: () {
                                              getCurrenLocation();
                                            },
                                          ),
                                        ),
                                        // ElevatedButton(
                                        //   child: Text('Pick Location from Map'),
                                        //   onPressed: _pickLocationFromMap,
                                        // ),
                                      ]));
                            },
                          );
                        },
                      ),
                      // Text("Longitude  is  :  $_longitude"),
                      // Text("Latitude   is  :  $_latitude"),
                    ],
                  ),
                ),
              ),

              /*  TextButton(
                child: Text('Pick Current Location'),
                onPressed: _pickCurrentLocation,
              ),
              TextButton(
                child: Text('Pick Location from Map'),
                onPressed: _pickLocationFromMap,
              ),*/
              itemsnow.length == 0
                  ? Container(
                      child: Text(
                        "Cart is Empty...",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () async {
                          int? a = await PlaceOrder();
                          Provider.of<CartProvider1>(context, listen: false)
                              .clearCart();


                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 5.0)
                              ],
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 1.0],
                                colors: [
                                  Colors.amber,
                                  Colors.black,
                                ],
                              ),
                              color: Colors.deepPurple.shade300,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                'Place Order'.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}






/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/user/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/user/assistantMethods/total_amount.dart';
import 'package:users_food_app/splash_screen/splash_screen.dart';
import 'package:users_food_app/user/widgets/design/cart_item_design.dart';
import 'package:users_food_app/user/widgets/progress_bar.dart';

import '../assistantMethods/cart_item_counter.dart';
import '../assistantMethods/total_amount.dart';
import '../models/items.dart';
import '../widgets/text_widget_header.dart';
import 'address_screen.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;

  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(-2.0, 0.0),
              end: FractionalOffset(5.0, -1.0),
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFAC898),
              ],
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.orange,
                ),
              ),
              Positioned(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.brightness_1,
                      size: 20,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                      child: Center(
                        child: Consumer<CartItemCounter>(
                            builder: (context, counter, c) {
                          return Text(
                            counter.count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: () {
            clearCartNow(context);
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text(
                "Clear Cart",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.amber,
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                clearCartNow(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const SplashScreen()));

                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text(
                "Check Out",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.amber,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => AddressScreen(
                      totalAmount: totalAmount.toDouble(),
                      sellerUID: widget.sellerUID,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(-1.0, 0.0),
            end: FractionalOffset(2.0, -1.0),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAC898),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            //overall total price
            SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "My Cart List"),
            ),

            SliverToBoxAdapter(
              child: Consumer2<TotalAmount, CartItemCounter>(
                  builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "Total Price: ${"\$" + amountProvider.tAmount.toString()}",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                  ),
                );
              }),
            ),

            //display cart items with quantity numbers
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .where("itemID", whereIn: separateItemIDs())
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    //if length = 0 no data
                    // : snapshot.data!.docs.length == 0
                    //     ? Container()
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            Items model = Items.fromJson(
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>,
                            );

                            //calculating total price in cart list
                            if (index == 0) {
                              totalAmount = 0;
                              totalAmount = totalAmount +
                                  (model.price! *
                                      separateItemQuantityList![index]);
                            } else {
                              totalAmount = totalAmount +
                                  (model.price! *
                                      separateItemQuantityList![index]);
                            }
                            //update in real time
                            if (snapshot.data!.docs.length - 1 == index) {
                              WidgetsBinding.instance!.addPostFrameCallback(
                                (timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayTotalAmount(
                                          totalAmount.toDouble());
                                },
                              );
                            }

                            return CartItemDesign(
                              model: model,
                              context: context,
                              quanNumber: separateItemQuantityList![index],
                            );
                          },
                          childCount:
                              snapshot.hasData ? snapshot.data!.docs.length : 0,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/

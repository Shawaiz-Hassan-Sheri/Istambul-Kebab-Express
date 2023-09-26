import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_food_app/rider/screens/rider_home_screen.dart';
import 'package:users_food_app/user/assistantMethods/address_changer.dart';
import 'package:users_food_app/user/assistantMethods/cart_item_counter.dart';
import 'package:users_food_app/user/assistantMethods/total_amount.dart';
import 'package:users_food_app/user/cart/cart_provider.dart';
import 'package:users_food_app/user/global/global.dart';
import 'package:users_food_app/user/models/cart.dart';
import 'authentication/login.dart';
import 'notused.dart';
import 'splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  //runApp(const AdminHomeScreen());
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: ((c) => CartItemCounter()),
        ),
        ChangeNotifierProvider(
          create: ((c) => TotalAmount()),
        ),
        ChangeNotifierProvider(
          create: ((c) => AddressChanger()),
        ),
        ChangeNotifierProvider(
            create: (_) => CartProvider()
        ),
        ChangeNotifierProvider(
            create: (_) => CartProvider1()
        ),
        // ChangeNotifierProvider<UserIdProvider>(
        //   create: (context) => UserIdProvider(),
       // ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) => UserProfileProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Shawaiz Dev',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        // home:  MapHomePage(),
        //home:  ManagerMenuItems(),
        //home: const LoginScreen(),
       // home:  mapcheck(),
        home:  SplashScreen(),
        //home:  RiderHomeScreen(),
        //home:  MapScreen(apiKey: 'AIzaSyB49FO_DNss2IIzfnj5anXulK-1nVl3yoM',),

       // home:  Check1(),
        //home:  ManagerOnlineOrders(),
      ),
    );
  }
}

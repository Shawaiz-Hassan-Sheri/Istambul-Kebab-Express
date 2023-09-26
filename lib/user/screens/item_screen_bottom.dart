import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../notused.dart';
import '../models/items.dart';
import 'item_detail_screen.dart';

class ItemsScreenBottom extends StatefulWidget {
  @override
  _ItemsScreenBottomState createState() => _ItemsScreenBottomState();
}

class _ItemsScreenBottomState extends State<ItemsScreenBottom> {
  // late String productAvailability;


  // @override
  // void initState() {
  //   super.initState();
  //   // Fetch string from Firestore and store it in productAvailability
  //   fetchProductAvailability();
  // }

  // Future<void> fetchProductAvailability() async {
  //   try {
  //     DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
  //         .collection('Check')
  //         .doc('4JgSUqcssJTNGcCtABLCAWV3ZlJ2')
  //         .get();
  //
  //     productAvailability = docSnapshot['productAvailability'];
  //     setState(() {}); // Update the UI with the fetched value
  //   } catch (e) {
  //     print('Error fetching product availability: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    String productAvailability=userProfileProvider.avalabilityProduct;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(" Menu Items",style: TextStyle(color: Colors.black),)),
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

        elevation: 0,
      ),
      body: productAvailability.isEmpty // Assuming productAvailability is a non-null string
          ? Center(
        child: CircularProgressIndicator(),
      )
          : productAvailability == 'NoMoreOrders'
          ? Center(
        child: Text('No more orders available.'),
      )
          : Container(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(color: Colors.white, thickness: 2),
              Container(
                width: width,
                height: height*0.8,
                margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),

                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Items').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {

                      return  GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns in the grid
                          mainAxisSpacing: 20.0, // Space between rows
                          crossAxisSpacing: 10.0, // Space between columns
                          childAspectRatio: 0.65, // Width-to-height ratio of grid items
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Items model = Items.fromJson(
                              snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => ItemDetailsScreen(model: model),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1, // Aspect ratio of item's thumbnail
                                    child: Image.network(
                                      model.thumbnailUrl ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    model.title ?? '',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '\$${model.price ?? 0}',
                                    style: TextStyle(fontSize: 14, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/user/screens/item_detail_screen.dart';
import 'package:users_food_app/user/widgets/app_bar.dart';
import 'package:users_food_app/user/widgets/design/items_design.dart';

import '../../notused.dart';
import '../models/items.dart';
import '../models/menus.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget_header.dart';

class ItemsScreenBottom extends StatefulWidget {
  // final Menus? model;
  // ItemsScreenBottom({this.model});

  @override
  _ItemsScreenBottomState createState() => _ItemsScreenBottomState();
}

class _ItemsScreenBottomState extends State<ItemsScreenBottom> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late String productavailablitycheck;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    productavailablitycheck=userProfileProvider.avalabilityProduct;
     return Scaffold(
      // appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      appBar:AppBar(
        title: Center(child: Text(" Menu Items",style: TextStyle(color: Colors.black),)),
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

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Container(
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

        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(color: Colors.white, thickness: 2),
              Container(
                width: width,
                height: height*0.8,
                margin: EdgeInsets.symmetric(vertical: 2,horizontal: 10),

                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('Check')
                      .doc('4JgSUqcssJTNGcCtABLCAWV3ZlJ2')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      final productAvailability = data['productAvailability'] ?? '';

                      if (productAvailability == 'NoMoreOrders') {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('Items')
                              .orderBy("publishedDate", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                        */
/*    // if (productavailablitycheck=='NoMoreOrders') {
                            //   return Text("No More Orders are taking now...........");
                            //
                            // }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData) {
                              return Center(
                                child: circularProgress(),
                              );
                            }

*//*
                         */
/* if (snapshot.connectionState == ConnectionState.active) {
                            return  GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Number of columns in the grid
                                mainAxisSpacing: 20.0, // Space between rows
                                crossAxisSpacing: 10.0, // Space between columns
                                childAspectRatio: 0.65, // Width-to-height ratio of grid items
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Items model = Items.fromJson(
                                    snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => ItemDetailsScreen(model: model),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1, // Aspect ratio of item's thumbnail
                                          child: Image.network(
                                            model.thumbnailUrl ?? '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          model.title ?? '',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '\$${model.price ?? 0}',
                                          style: TextStyle(fontSize: 14, color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                              }*//*

                        if (productavailablitycheck=='normal') {
                            return  GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Number of columns in the grid
                                mainAxisSpacing: 20.0, // Space between rows
                                crossAxisSpacing: 10.0, // Space between columns
                                childAspectRatio: 0.65, // Width-to-height ratio of grid items
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Items model = Items.fromJson(
                                    snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => ItemDetailsScreen(model: model),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1, // Aspect ratio of item's thumbnail
                                          child: Image.network(
                                            model.thumbnailUrl ?? '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          model.title ?? '',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '\$${model.price ?? 0}',
                                          style: TextStyle(fontSize: 14, color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );}
                            return Center(
                              child: Text('No more orders available.'),
                            );
                          },
                        );
                      } else if (productAvailability == 'NoMoreOrders') {
                        return Center(
                          child: Text('No/........... more orders available.'),
                        );
                      }
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
             ],
          ),
        ),
      ),
    );
  }
}
*/

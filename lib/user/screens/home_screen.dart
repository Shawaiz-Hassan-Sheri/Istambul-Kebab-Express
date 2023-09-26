import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:users_food_app/user/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/user/widgets/items_avatar_carousel.dart';
import 'package:users_food_app/user/widgets/my_drawer.dart';
import 'package:users_food_app/user/widgets/progress_bar.dart';

import 'package:users_food_app/authentication/login.dart';
import '../../notused.dart';
import '../models/User.dart';
import '../models/sellers.dart';
import '../widgets/seller_avatar_carousel.dart';
import '../widgets/design/sellers_design.dart';
import '../widgets/userIdProvider.dart';
import '../widgets/user_info.dart';
import 'items_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();


  late String _empName;
  late String _empEmail;
  late String _empPhotourl;
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;
  late User1 userEmployee;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  void getSpecificDataFromFirebase() async {
    DocumentSnapshot snapshot = await _db.collection('User').doc(firebaseUid).get();
    setState(() {
      _empName = snapshot.get('UserName');
      _empEmail = snapshot.get('UserEmail');
      _empPhotourl = snapshot.get('UserPhotoUrl');
    });
    var userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    await userProfileProvider.setUserProfile(_empName, _empEmail);
    print('data saveingggggggggggggggggggggggggggggggg');

  }

  @override
  void initState() {
    super.initState();
    _empName='';
    _empPhotourl='';
    // Future.delayed(
    //     Duration(
    //       seconds: 3
    //     ),(){}
    // );
    clearCartNow(context);
    getSpecificDataFromFirebase();
    _getCurrentUser();
    _getProductStatus();
    fetchProductAvailability();
  }
  late String productAvailability;
  Future<void> fetchProductAvailability() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Check')
          .doc('4JgSUqcssJTNGcCtABLCAWV3ZlJ2')
          .get();

      productAvailability = docSnapshot['productAvailability'];
      setState(() {});
      var userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
      await userProfileProvider.setCheck(productAvailability);
      print('data saveingggggggggggggggggggggggggggggggg');
    } catch (e) {
      print('Error fetching product availability: $e');
    }
  }
  void _getProductStatus() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = '';
  void _getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }
  @override
  Widget build(BuildContext context) {


    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      drawer: MyDrawer(
        userid: userId,
        empName1: _empName,
        empPhotourl1: _empPhotourl,
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
        child: CustomScrollView(
          slivers: [
            //appbar
            SliverAppBar(
              elevation: 1,
              pinned: true,
              backgroundColor: const Color(0xFFFAC898),
              foregroundColor: Colors.black,
              expandedHeight: 50,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(-1.0, 0.0),
                    end: FractionalOffset(4.0, -1.0),
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFAC898),
                    ],
                  ),
                ),
                child: FlexibleSpaceBar(
                  title: Text(
                    'Istambul Kebar Express'.toUpperCase(),
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  centerTitle: false,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      child: const Icon(Icons.exit_to_app),
                    ),
                    onTap: () {
                      firebaseAuth.signOut().then((value) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (c) => const LoginScreen(),
                        //   ),
                        // );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                        _controller.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
            //Carausel
            SliverToBoxAdapter(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: UserInformation(),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => ItemsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: height * 0.12,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        begin: FractionalOffset(-1.0, 0.0),
                        end: FractionalOffset(5.0, -1.0),
                        colors: [
                          Colors.orangeAccent,
                          Colors.amber,
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                          offset: Offset(4, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.restaurant_menu_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.007,
                        ),
                        Center(
                          child: Text(
                            " Menu ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),

            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.all(5.0),
            //     child: SizedBox(
            //       //taking %20 height for the device
            //       height: MediaQuery.of(context).size.height * .2,
            //       //taking max width for the device
            //       width: MediaQuery.of(context).size.width,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: const [
            //           SellerCarouselWidget(),
            //           ItemsAvatarCarousel(),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            /*StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Items").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        itemBuilder: (context, index) {
                          Sellers smodel = Sellers.fromJson(
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>);
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: SellersDesignWidget(
                              model: smodel,
                              context: context,
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      );
              },
            )*/
          ],
        ),
      ),
    );
  }

}

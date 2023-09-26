import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';
import '../widgets/userIdProvider.dart';

class MyButton2 extends StatelessWidget {
  final void Function() onPressed;
  final String name;
  double height1;
  double width1;

  MyButton2(this.name, this.height1, this.width1, this.onPressed);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * height1,
      width: width * width1,
      // height: height*.04,
      // width: width*.35,
      child: ElevatedButton(
        child: Text(name, style: TextStyle(fontSize: 16)),
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 1, 83, 137),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              // side: BorderSide(Color.fromARGB(255, 1, 83, 137),)
            ))),
        onPressed: onPressed,
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String name;

  MyTextFormField({
    required this.controller,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: name,
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //  TextEditingController _textController = TextEditingController();
  String name = 'hussain';

  // This key will be used to show the snack bar
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // This function is triggered when the copy icon is pressed

  //late User1 userProfile;
  late TextEditingController phoneNumber;
  late TextEditingController useremail1;
  late TextEditingController userName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  bool isMale = false;
  bool check = false;

  void vaildation() async {
    if (userName.text.isEmpty && phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Flied Are Empty"),
        ),
      );
    } else if (userName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Is Empty "),
        ),
      );
    } else if (userName.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Must Be 6 "),
        ),
      );
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Phone Number Must Be 11 "),
        ),
      );
    } else {
      userDetailUpdate();
    }
  }

  late File _pickedImage;

  late PickedFile _image;

  Future<void> getImage({required ImageSource source}) async {
    _image = (await ImagePicker().getImage(source: source))!;
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
      });
    }
  }

  late String userUid;

  Future<String> _uploadImage({required File image}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Users").child(fileName);
    ;
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }


  bool centerCircle = false;
  var imageMap;

  void userDetailUpdate() async {
    setState(() {
      centerCircle = true;
    });
    _pickedImage != null
        ? imageMap = await _uploadImage(image: _pickedImage)
        : Container();
    FirebaseFirestore.instance.collection("User").doc(userUid).update({
      "UserName": userName.text,
      "UserPhoneNumber": phoneNumber.text,
      "UserPhotoUrl": imageMap,
    });
    setState(() {
      centerCircle = false;
    });
    setState(() {
      edit = false;
    });
  }


  Widget _buildSingleContainer(
      {Color? color, String? startText, String? endText}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: edit == true ? color : Colors.white,
          borderRadius: edit == false
              ? BorderRadius.circular(30)
              : BorderRadius.circular(0),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                startText!,
                style: TextStyle(fontSize: 17, color: Colors.black45),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  endText!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late String userImage;
  bool edit = false;

  Widget _buildContainerPart() {
    userName = TextEditingController(text: username);
    useremail1 = TextEditingController(text: useremail);

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleContainer(
            endText: username,
            startText: "Name",
          ),
          _buildSingleContainer(
            endText: useremail,
            startText: "Email",
          ),
          // _buildSingleContainer(
          //   endText: userProfile.UserPhonenumber!,
          //   startText: "Phone Number",
          // ),
        ],
      ),
    );
  }

  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Pick Form Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Pick Form Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  late String useremail;
  late String username;

  Future<void> fetchCurrentUserData(String userId) async {
    try {
      // Check if a user is signed in
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        // If the user is signed in, fetch data from Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot snapshot = await firestore.collection('User').doc(userId).get();

        // You can access the user data using snapshot.data()
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        // Replace "name" and "email" with the fields you have in your Firestore document
         username = userData['UserName'];
         useremail = userData['UserEmail'];

        // Do something with the user data
        print('User Name: $name');
        print('User Email: $useremail');
      } else {
        // No user is signed in
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
/*  Future<void> getUserProfileData() async {
    try {
      print(userUid);
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('User')
          .doc(userUid)
          .get();
      userProfile = User1.fromDocumentSnapshot(snapshot);
//      setState(() {}); // Refresh the UI after getting data
    } catch (e) {
      print('Error fetching user profile data: $e');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

   // getUserProfileData();
    final userIdProvider = Provider.of<UserIdProvider>(context);
    String userId = userIdProvider.userId;
    fetchCurrentUserData(userId);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        leading: edit == true
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    edit = false;
                  });
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // setState(() {
                  //   Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(
                  //       builder: (ctx) => HomePage(),
                  //     ),
                  //   );
                  // });
                },
              ),
        title: edit == true
            ? Container()
            : Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
        backgroundColor: Color.fromARGB(255, 1, 83, 137),
        actions: [
          edit == false
              //? NotificationButton()
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (check == true) {
                      vaildation();
                    } else {
                      setState(() {
                        edit = false;
                      });
                    }
                  },
                ),
        ],
      ),
      body: centerCircle == false
          ?  SingleChildScrollView(
        child: Container(
          height: height,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSizedBox(height*0.04),
              edit == true
                  ? CircleAvatar(
                  maxRadius: height*0.15,
                  //backgroundImage:NetworkImage(userProfile.UserPhotoUrl as String)



                //     ? userProfile.UserPhotoUrl == null
                //     ? AssetImage("images/userImage.png")
                //     : NetworkImage(userProfile.UserPhotoUrl ?? "images/userImage.png")
                //     :NetworkImage(userProfile.UserPhotoUrl ?? "images/userImage.png")

              )
                  :  CircleAvatar(
                  maxRadius: 50,
                 // backgroundImage:NetworkImage(userProfile.UserPhotoUrl as String)
              ),
              CustomSizedBox(height*0.04),

              edit == true
                  ? GestureDetector(
                onTap: () {
                  myDialogBox(context);
                  setState(() {
                    check=true;
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)),
                    child: edit == true
                        ? MyButton2(
                        "Change Image",
                        .06,
                        .65,
                            (){

                        }


                    )
                        : Container(),
                  ),
                ),
              )
                  :  Container(),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  child: edit == false
                      ? MyButton2(
                    "Edit Image",
                    .04,
                    .35,
                        () {
                      setState(() {
                        edit = true;
                      });
                    },
                  )
                      : Container(),
                ),
              ),
              edit == true
                  ? Container()
                  : Container(),
              Container(
                height: height*0.6,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: edit == true
                            ? Container()
                            : _buildContainerPart(),
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      )

          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget CustomSizedBox(double s) {
    return SizedBox(
      height: s,
    );
  }
}

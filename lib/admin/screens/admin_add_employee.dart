
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:users_food_app/user/global/global.dart';
import 'package:users_food_app/user/widgets/custom_text_field.dart';
import 'package:users_food_app/user/widgets/error_dialog.dart';
import 'package:users_food_app/user/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import '../../user/widgets/custom_number_text_field.dart';
import '../../user/widgets/custom_password_text_field.dart';
import '../widgets/admin_header_widget.dart';
import 'admin_homescreen.dart';

class AdminAddEmployee extends StatefulWidget {
  const AdminAddEmployee({Key? key}) : super(key: key);

  @override
  _AdminAddEmployeeState createState() => _AdminAddEmployeeState();
}

class _AdminAddEmployeeState extends State<AdminAddEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();


  bool isloading=true;

// For Roles
  String _selectedRole = '';
  final List<String> roles=['Manager','Admin','Rider','Employee'];


//image picker
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

//location
  Position? position;
  List<Placemark>? placeMarks;

//address name variable
  String completeAddress = "";

//seller image url
  String sellerImageUrl = "";

//function for getting current location
 /* Future<Position?> getCurrenLocation() async {
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

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
    '${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';

    locationController.text = completeAddress;
  }*/

//function for getting image
  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

//Form Validation
  Future<void> signUpFormValidation() async {
    //checking if user selected image
    if (imageXFile == null) {
      setState(
            () {
          // imageXFile == "images/bg.png";
          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please select an image",
              );
            },
          );
        },
      );
    } else {
      if (passwordController.text == confirmpasswordController.text) {
        //nested if (cheking if controllers empty or not)
        if (confirmpasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            _selectedRole.isNotEmpty &&
            phoneController.text.isNotEmpty
           // locationController.text.isNotEmpty
        ) {
            if(_selectedRole=="Manager"){
              //start uploading image
              showDialog(
                context: context,
                builder: (c) {
                  return LoadingDialog(
                    message: "Registering Account",
                  );
                },
              );
              String fileName = DateTime.now().millisecondsSinceEpoch.toString();
              fStorage.Reference reference = fStorage.FirebaseStorage.instance
                  .ref()
                  .child("Manager")
                  .child(fileName);
              fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url)   {
                sellerImageUrl = url;

                // save info to firestore
                AuthenticateSellerAndSignUp();
              });
            }
            if(_selectedRole=="Rider"){
              //start uploading image
              showDialog(
                context: context,
                builder: (c) {
                  return LoadingDialog(
                    message: "Registering Account",
                  );
                },
              );
              String fileName = DateTime.now().millisecondsSinceEpoch.toString();
              fStorage.Reference reference = fStorage.FirebaseStorage.instance
                  .ref()
                  .child("Rider")
                  .child(fileName);
              fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url)   {
                sellerImageUrl = url;

                // save info to firestore
                AuthenticateSellerAndSignUp();
              });
            }
            if(_selectedRole=="Admin"){
              //start uploading image
              showDialog(
                context: context,
                builder: (c) {
                  return LoadingDialog(
                    message: "Registering Account",
                  );
                },
              );
              String fileName = DateTime.now().millisecondsSinceEpoch.toString();
              fStorage.Reference reference = fStorage.FirebaseStorage.instance
                  .ref()
                  .child("Admin")
                  .child(fileName);
              fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url)   {
                sellerImageUrl = url;

                // save info to firestore
                AuthenticateSellerAndSignUp();
              });
            }
            if(_selectedRole=="Employee"){
              //start uploading image
              showDialog(
                context: context,
                builder: (c) {
                  return LoadingDialog(
                    message: "Registering Account",
                  );
                },
              );
              String fileName = DateTime.now().millisecondsSinceEpoch.toString();
              fStorage.Reference reference = fStorage.FirebaseStorage.instance
                  .ref()
                  .child("Employee")
                  .child(fileName);
              fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url)   {
                sellerImageUrl = url;

                // save info to firestore
                AuthenticateSellerAndSignUp();
              });
            }

        }
        //if there is empty place show this message
        else {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please fill the required info for Registration. ",
              );
            },
          );
        }
      } else {
        //show an error if passwords do not match
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Password do not match",
            );
          },
        );
      }
    }
  }

  void AuthenticateSellerAndSignUp() async {
    User? currentUser;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError(
          (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          },
        );
      },
    );

    if (currentUser != null) {
      saveDataToFirestore(currentUser!)
          .then((value) async {
            setState(() {
              isloading=true;
            });
        Navigator.pop(context);
        //send user to Home Screen
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Data Uploaded'),
                  content: Text('Your data has been successfully uploaded.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();

                      },
                    ),
                  ],
                );
              },
            );
        Route newRoute = MaterialPageRoute(builder: (c) => const AdminHomeScreen());
        Navigator.pushReplacement(context, newRoute);

      }
      );
    }
  }

//saving seller information to firestore
  Future saveDataToFirestore(User currentUser) async {
     String phoneNumber = phoneController.text;
    int? parsedPhoneNumber = int.tryParse(phoneNumber);

    await FirebaseFirestore.instance.collection("Employee").doc(currentUser.uid).set(
      {
        "EmployeeUID": currentUser.uid,
        "EmployeeEmail": currentUser.email,
        "EmployeePassword":passwordController.text,
        "EmployeeName": nameController.text.trim(),
        "EmployeeAvatarUrl": sellerImageUrl,
        "EmployeePhone": parsedPhoneNumber,
        "EmployeeRole":_selectedRole,
        //"address": completeAddress,
        "EmployeeStatus": "approved",
        "EmployeeEarnings": 0.0,

        // "lat": position!.latitude,
        // "lng": position!.longitude,
      },
    );
     if(_selectedRole=="Manager"){
       await FirebaseFirestore.instance.collection("Manager").doc(currentUser.uid).set(
         {
           "ManagerUID": currentUser.uid,
           "ManagerEmail": currentUser.email,
           "ManagerPassword":passwordController.text,
           "ManagerName": nameController.text.trim(),
           "ManagerAvatarUrl": sellerImageUrl,
           "ManagerPhone": parsedPhoneNumber,
           "ManagerRole":_selectedRole,
           //"address": completeAddress,
           "ManagerStatus": "approved",
           "ManagerEarnings": 0.0,

           // "lat": position!.latitude,
           // "lng": position!.longitude,
         },
       );
     }
     if(_selectedRole=="Rider"){
       await FirebaseFirestore.instance.collection("Rider").doc(currentUser.uid).set(
         {
           "RiderUID": currentUser.uid,
           "RiderEmail": currentUser.email,
           "RiderPassword":passwordController.text,
           "RiderName": nameController.text.trim(),
           "RiderAvatarUrl": sellerImageUrl,
           "RiderPhone": parsedPhoneNumber,
           "RiderRole":_selectedRole,
           //"address": completeAddress,
           "RiderStatus": "approved",
           "RiderEarnings": 0.0,
           // "lat": position!.latitude,
           // "lng": position!.longitude,
         },
       );
     }
     if(_selectedRole=="Admin"){
       await FirebaseFirestore.instance.collection("Admin").doc(currentUser.uid).set(
         {
           "AdminUID": currentUser.uid,
           "AdminEmail": currentUser.email,
           "AdminPassword":passwordController.text,
           "AdminName": nameController.text.trim(),
           "AdminAvatarUrl": sellerImageUrl,
           "AdminPhone": parsedPhoneNumber,
           "AdminRole":_selectedRole,
           //"address": completeAddress,
           "AdminStatus": "approved",
           "AdminEarnings": 0.0,
           // "lat": position!.latitude,
           // "lng": position!.longitude,
         },
       );
     }
    // save data locally (to access data easly from phone storage)
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
    //Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
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
            mainAxisSize: MainAxisSize.max,
            children: [

              Stack(
                children: [
                  Container(
                    height: 150,
                    child: const AdminHeaderWidget(
                      150,
                      false,
                      Icons.add,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        _getImage();
                      },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.20,
                        backgroundColor: Colors.white,
                        backgroundImage: imageXFile == null
                            ? null
                            : FileImage(
                          File(imageXFile!.path),
                        ),
                        child: imageXFile == null
                            ? Icon(
                          Icons.person_add_alt_1,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.grey,
                        )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      data: Icons.person,
                      controller: nameController,
                      hintText: "Name",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                      isObsecre: false,
                    ),
                    CustomPasswordTextField(
                      data: Icons.lock,
                      controller: passwordController,
                      hintText: "Password",
                      isObsecre: true,

                    ),
                    CustomPasswordTextField(
                      data: Icons.lock,
                      controller: confirmpasswordController,
                      hintText: "Confirm password",
                      isObsecre: true,

                    ),
                    CustomNumberTextField(
                      data: Icons.phone_android_outlined,
                      controller: phoneController,
                      hintText: "Phone nummber",
                      isObsecre: false,
                    ),
                 Container(
                   height: height*0.07,
                   width: width*0.745,
                   child: DropdownSearch<String>(
                       mode: Mode.MENU,
                       showSearchBox: false,
                       showSelectedItems: true,
                       items: roles,
                       label: 'Select a role',
                       selectedItem: _selectedRole,
                        onChanged: (newValue) {
                         setState(() {
                        _selectedRole = newValue!;

                      });
                    },
                ),
                 ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     CustomTextField(
                    //       data: Icons.my_location,
                    //       controller: locationController,
                    //       hintText: "Cafe/Restorant Address",
                    //       isObsecre: false,
                    //       enabled: false,
                    //     ),
                    //     Center(
                    //       child: IconButton(
                    //         onPressed: () {
                    //           getCurrenLocation();
                    //         },
                    //         icon: const Icon(
                    //           Icons.location_on,
                    //           size: 40,
                    //         ),
                    //         color: Colors.red,
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              isloading?Padding(
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
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      minimumSize:
                      MaterialStateProperty.all(const Size(50, 50)),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text(
                        'Add Employee'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () async {

                       setState(() {
                         isloading=false;
                       });
                       await signUpFormValidation();
                      // Navigator.of(context).pop();




                      // This will navigate back to the previous screen


                    },
                  ),
                ),
              ):CircularProgressIndicator(),

            ],
          ),
        ),
      ),
    );
  }
}

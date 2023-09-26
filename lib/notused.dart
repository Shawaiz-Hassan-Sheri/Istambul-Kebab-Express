import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  String _profilePictureUrl = ''; // Add profile picture URL
  String _avalabilityProduct='';

  String get name => _name;
  String get email => _email;
  String get profilePictureUrl => _profilePictureUrl; // Add getter for profile picture URL
  String get avalabilityProduct => _avalabilityProduct;

  Future<void> setUserProfile(String name, String email) async {
    _name = name;
    _email = email;
    notifyListeners();
  }
  Future<void> setUserName(String name) async {
    _name = name;
    //_email = email;
    notifyListeners();
  }
  Future<void> setCheck(String avalablity) async {
    _avalabilityProduct = avalablity;
    notifyListeners();
  }
  void setProfilePictureUrl(String url) {
    _profilePictureUrl = url;
    notifyListeners();
  }

  Future<void> updateProfileData(String newName, String newProfilePictureUrl) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('User').doc(user.uid).update({
          'UserName': newName,
          //'UserEmail': newEmail,
          'UserPhotoUrl': newProfilePictureUrl, // Update the profile picture URL in Firestore
        });

        setUserName(newName);
        setProfilePictureUrl(newProfilePictureUrl);
        print('User profile updated successfully!');
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> uploadProfilePicture(String imagePath) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref() .child("Users").child(fileName);;
        UploadTask uploadTask = ref.putFile(File(imagePath));

        await uploadTask.whenComplete(() async {
          String downloadUrl = await ref.getDownloadURL();
          setProfilePictureUrl(downloadUrl);
          print('Profile picture uploaded successfully!');
        });
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }
}


class ProfileScreennotused extends StatefulWidget {
  @override
  _ProfileScreennotusedState createState() => _ProfileScreennotusedState();
}

class _ProfileScreennotusedState extends State<ProfileScreennotused> {
  final TextEditingController _nameController = TextEditingController();
 // final TextEditingController _emailController = TextEditingController();
  String _pickedImagePath = '';
   late final userProfileProvider;
  @override
  Widget build(BuildContext context) {
     userProfileProvider = Provider.of<UserProfileProvider>(context);

    _nameController.text = userProfileProvider.name;
   // _emailController.text = userProfileProvider.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              _editProfile(context);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () async {
              //_pickedImagePath = await _pickImage();
            },
            child: CircleAvatar(
              radius: 60,
              backgroundImage: userProfileProvider.profilePictureUrl.isNotEmpty
                  ? NetworkImage(userProfileProvider.profilePictureUrl)
                  : null,
              child: _pickedImagePath.isEmpty
                  ? Icon(Icons.camera_alt,color: Colors.amber ,size: 50)
                  : null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Name'),
            subtitle: Text(userProfileProvider.name),
          ),
          // ListTile(
          //   leading: Icon(Icons.email),
          //   title: Text('Email'),
          //   subtitle: Text(userProfileProvider.email),
          // ),
        ],
      ),
    );
  }

  Future<String> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return pickedImage.path;
    }
    return '';
  }

  void _editProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  _pickedImagePath = await _pickImage();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: userProfileProvider.profilePictureUrl.isNotEmpty
                      ? NetworkImage(userProfileProvider.profilePictureUrl)
                      : null,
                  child: _pickedImagePath.isEmpty
                      ? Icon(Icons.camera_alt,color: Colors.amber ,size: 50)
                      : null,
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              // TextField(
              //   controller: _emailController,
              //   decoration: InputDecoration(labelText: 'Email'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();
                //String newEmail = _emailController.text.trim();

                if (newName.isNotEmpty || _pickedImagePath.isNotEmpty) {
                  var userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
                  if (_pickedImagePath.isNotEmpty) {
                    // Upload the profile picture and get the download URL
                    await userProfileProvider.uploadProfilePicture(_pickedImagePath);
                  }

                  // Update the user profile data in Firestore and Provider
                  await userProfileProvider.updateProfileData(newName, userProfileProvider.profilePictureUrl);

                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

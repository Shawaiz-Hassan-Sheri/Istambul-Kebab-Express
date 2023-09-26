import 'package:cloud_firestore/cloud_firestore.dart';

class User1 {
   String? UserEmail;
   String? UserName;
   String? UserPassword;
   String? UserRole;
   String? UserPhotoUrl;
   String? UserPhonenumber;

  User1({required this.UserPhonenumber,required this.UserEmail,required this.UserPhotoUrl ,required this.UserName, required this.UserRole,required this.UserPassword});

  User1.fromJson(Map<String, dynamic> json) {
    UserEmail = json["UserEmail"];
    UserName = json["UserName"];
    UserPhonenumber = json["UserPhoneNumber"];
    UserPassword = json["UserPassword"];
    UserRole = json["UserRole"];
    UserPhotoUrl = json["UserPhotoUrl"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["UserEmail"] = UserEmail;
    data["UserName"] = UserName;
    data["UserPhoneNumber"] = UserPhonenumber;
    data["UserPassword"] = UserPassword;
    data["UserRole"] = UserRole;
    data["UserPhotoUrl"] = UserPhotoUrl;

    return data;
  }
   factory User1.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
     Map<String, dynamic> data = snapshot.data()!;
     return User1(

       UserPhonenumber: data['UserPhoneNumber'] ?? '',
       UserEmail:data['UserEmail'] ?? '',
       UserPhotoUrl:data['UserPhotoUrl'] ?? '',
       UserName: data['UserName'] ?? '',
       UserRole:data['UserRole'] ?? '',
       UserPassword:data['UserPassword'] ?? '',
     );
   }


}

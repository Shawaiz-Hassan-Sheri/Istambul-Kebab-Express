import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMenu {
  String? adminitemID;
  String? adminlongDescription;
  int? adminprice;
  String? adminshortInfo ;
  Timestamp? adminpublishedDate;
  String? adminstatus;
  String? adminthumbnailUrl;
  String? admintitle;

  AdminMenu({
    this.adminitemID,
    this.adminlongDescription,
    this.adminprice,
    this.adminpublishedDate,
    this.adminshortInfo,
    this.adminstatus,
    this.adminthumbnailUrl,
    this.admintitle,
  });

  AdminMenu.fromJson(Map<String, dynamic> json) {
    adminitemID = json["menuID"];
    adminlongDescription = json["longDescription"];
    adminprice = json["price"];
    adminpublishedDate = json["publishedDate"];
    adminshortInfo = json["shortInfo"];
    adminstatus = json["status"];
    adminthumbnailUrl = json["thumbnailUrl"];
    admintitle = json["title"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["itemID"] = adminitemID;
    data["longDescription"] = adminlongDescription;
    data["price"] = adminprice;
    data["publishedDate"] = adminpublishedDate;
    data["shortInfo"] = adminshortInfo;
    data["status"] = adminstatus;
    data["thumbnailUrl"] = adminthumbnailUrl;
    data["title"] = admintitle;
    return data;
  }
  factory AdminMenu.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;



    String? adminitemID=data["menuID"];
    String? adminlongDescription=data["longDescription"];
    int? adminprice=data["price"];
    String? adminshortInfo =data["publishedDate"];
    Timestamp? adminpublishedDate=data["shortInfo"];
    String? adminstatus=data["status"];
    String? adminthumbnailUrl=data["thumbnailUrl"];


    return AdminMenu(
        adminitemID: adminitemID,
        adminlongDescription: adminlongDescription,
        adminprice: adminprice,
    adminpublishedDate: adminpublishedDate,
    adminshortInfo: adminshortInfo,
    adminstatus: adminstatus,
    adminthumbnailUrl: adminthumbnailUrl,
    );
  }
}

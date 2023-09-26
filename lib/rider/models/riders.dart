import 'package:cloud_firestore/cloud_firestore.dart';

class Riders {
  String? riderUID;
  String? riderStatus;
  String? riderName;
  String? riderAvailability;


  Riders({
    this.riderAvailability,
    this.riderName,
    this.riderStatus,
    this.riderUID,
  });

  Riders.fromJson(Map<String, dynamic> json) {
    riderUID = json["RiderUID"];
    riderStatus = json["RiderStatus"];
    riderName = json["RiderName"];
    riderAvailability = json["RiderAvailability"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["RiderUID"] = riderUID;
    data["RiderStatus"] = riderStatus;
    data["RiderName"] = riderName;
    data["RiderAvailability"] = riderAvailability;


    return data;
  }
  factory Riders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Riders(
      riderUID: doc.id.toString(),

      riderAvailability: data['RiderAvailability'].toString(),
      riderName: data['RiderName'].toString(),
      riderStatus: data['RiderStatus'],
      // // timestamp: (data['timestamp'] as Timestamp).toDate(),
      // orderItems: List<OrderItem1>.from(data['orderItems'].map(
      //       (item) => OrderItem1.fromMap(item),
      //)),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
class OrderItem1 {
  final String imageUrl;
  final String name;
  final int price;
  final int quantity;
  final int totalPrice;

  OrderItem1({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    return data;
  }
  factory OrderItem1.fromJson(Map<String, dynamic> json) {
    return OrderItem1(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
      totalPrice: json['totalPrice'] as int? ?? 0,
    );
  }


  factory OrderItem1.fromMap(Map<String, dynamic> data) {
    return OrderItem1(
      imageUrl: data['imageUrl'],
      name: data['name'],
      price: data['price'] as int? ?? 0,
      quantity: data['quantity']as int? ?? 0,
      totalPrice: data['totalPrice']as int? ?? 0,
    );
  }
}
class OrderItem2 {
  final String imageUrl;
  final String name;
  final int price;
  final int quantity;
  final int totalPrice;

  OrderItem2({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnailUrl'] = imageUrl;
    data['title'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    return data;
  }
  factory OrderItem2.fromJson(Map<String, dynamic> json) {
    return OrderItem2(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
      totalPrice: json['totalPrice'] as int? ?? 0,
    );
  }


  factory OrderItem2.fromMap(Map<String, dynamic> data) {
    return OrderItem2(
      imageUrl: data['imageUrl'],
      name: data['name'],
      price: data['price'] as int? ?? 0,
      quantity: data['quantity']as int? ?? 0,
      totalPrice: data['totalPrice']as int? ?? 0,
    );
  }
}


class OffLineOrders {
  final String id;
  final String status;
  final Timestamp timestamp;
  final String offlineorderUID;
  final int totalCost;
  // final DateTime timestamp;
  final List<OrderItem1> orderItems;

  OffLineOrders({
    required this.id,
    required this.status,
    required this.timestamp,
    required this.totalCost,
    required this.offlineorderUID,
    // required this.timestamp,
    required this.orderItems,
  });
/*  factory OffLineOrders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OffLineOrders(
      id: doc.id.toString(),
      offlineorderUID: data['offlineorderUID'].toString(),
      totalCost: data['TotalCost'],
      status: data['status'],
      timestamp: data['timestamp'],
      orderItems: List<OrderItem1>.from(data['orderItems'].map(
            (item) => OrderItem1.fromMap(item as Map<String, dynamic>),
      )),
    );
  }*/

  factory OffLineOrders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OffLineOrders(
      id: doc.id.toString(),

      offlineorderUID: data['offlineorderUID'].toString(),
      totalCost: data['TotalCost'],
      status: data['status'],
      timestamp: data['timestamp'],
      // timestamp: (data['timestamp'] as Timestamp).toDate(),
      orderItems: List<OrderItem1>.from(data['orderItems'].map(
            (item) => OrderItem1.fromMap(item),
      )),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['timestamp'] = timestamp;
    data['offlineorderUID'] = offlineorderUID;
    data['TotalCost'] = totalCost;
    data['orderItems'] = orderItems.map((item) => item.toJson()).toList();
    return data;
  }

  factory OffLineOrders.fromJson(Map<String, dynamic> json) {
    return OffLineOrders(
      id: json['id'],
      status: json['status'],
      timestamp: json['timestamp'],
      offlineorderUID: json['offlineorderUID'],
      totalCost: json['TotalCost'],
      orderItems: (json['orderItems'] as List).map((item) => OrderItem1.fromJson(item)).toList(),
    );
  }
}
class OnlineOrders {
  final String id;


  // final DateTime timestamp;
  final List<OrderItem1> orderItems;

  final int totalCost;
  final String assignedRider;
  final double latitude;
  final double longitude;
  final String orderuserUID;
  final String status;
  final Timestamp timestamp;
  OnlineOrders({
    required this.id,
    required this.totalCost,
    required this.longitude,
    required this.latitude,
    required this.assignedRider,
    required this.status,
    required this.timestamp,
   // required this.totalCost,
    required this.orderuserUID,
    // required this.timestamp,
    required this.orderItems,
  });
 /* factory OnlineOrders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OnlineOrders(
      id: doc.id.toString(),
      totalCost: data['totalCost'],
      assignedRider: data['assignedRider'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      orderuserUID: data['orderUserUID'],
      status: data['status'],
      timestamp: data['timestamp'],
      orderItems: List<OrderItem1>.from(data['orderItems'].map(
            (item) => OrderItem1.fromMap(item as Map<String, dynamic>),
      )),
    );
  }*/

  factory OnlineOrders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OnlineOrders(
      id: doc.id.toString(),

    totalCost: data['TotalCost'],
    assignedRider: data['assignedRider']??"",
    latitude: data['latitude'],
    longitude: data['longitude'],
    orderuserUID: data['orderUserUID'],
    timestamp: data['timestamp'],
      status: data['status'] ?? '',
     // totalCost: data['TotalCost'],
      // timestamp: (data['timestamp'] as Timestamp).toDate(),
      orderItems: List<OrderItem1>.from(data['orderItems'].map(
            (item) => OrderItem1.fromMap(item),
      )),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['TotalCost'] = totalCost;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['assignedRider'] = assignedRider;
    data['status'] = status;
    data['timestamp'] = timestamp;
    data['orderUserUID'] = orderuserUID;
    data['orderItems'] =
        orderItems.map((item) => item.toJson()).toList();
    return data;
  }

  factory OnlineOrders.fromJson(Map<String, dynamic> json) {
    return OnlineOrders(
      id: json['id'],
      totalCost: json['TotalCost'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      assignedRider: json['assignedRider'],
      status: json['status'],
      timestamp: json['timestamp'],
      orderuserUID: json['orderUserUID'],
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem1.fromJson(item))
          .toList(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
class OrderItem {
  final String imageUrl;
  final String name;
  final int price;
  final int quantity;

  OrderItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }
  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      imageUrl: data['imageUrl'],
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
    );
  }
}
class Orders {
   String id;
   String userId;
  // final DateTime timestamp;
   List<OrderItem> orderItems;
  Orders({
    required this.id,
    required this.userId,
    // required this.timestamp,
    required this.orderItems,
  });
   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data['id'] = id;
     data['userId'] = userId;
     data['orderItems'] =
         orderItems.map((item) => item.toJson()).toList();
     return data;
   }
  factory Orders.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Orders(
      id: doc.id.toString(),
      userId: data['userId'].toString(),
      // timestamp: (data['timestamp'] as Timestamp).toDate(),
      orderItems: List<OrderItem>.from(data['orderItems'].map(
            (item) => OrderItem.fromMap(item),
      )),
    );
  }


}


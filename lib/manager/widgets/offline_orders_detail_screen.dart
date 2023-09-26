import 'package:flutter/material.dart';

import '../models/offline_orders.dart';
import '../models/orders.dart';

class OffLineOrderDetailScreen extends StatelessWidget {
  final OffLineOrders order;

  OffLineOrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: ListView.builder(
        itemCount: order.orderItems.length,
        itemBuilder: (context, index) {
          final OrderItem1 item = order.orderItems[index];

          return ListTile(
            leading: Image.network(item.imageUrl),
            title: Text(item.name),
            subtitle: Text('${item.quantity} x \$${item.price}'),
            trailing: Text('\$${item.price * item.quantity}'),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:users_food_app/manager/models/offline_orders.dart';


class OrderDetailScreen extends StatelessWidget {
  final OnlineOrders order;

  OrderDetailScreen({required this.order});

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

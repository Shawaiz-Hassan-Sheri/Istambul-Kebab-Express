import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseManagementPage extends StatefulWidget {
  @override
  _ExpenseManagementPageState createState() => _ExpenseManagementPageState();
}

class _ExpenseManagementPageState extends State<ExpenseManagementPage> {
  CollectionReference expenses = FirebaseFirestore.instance.collection('Expenses');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Management System'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: expenses.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(doc['title']),
                subtitle: Text('Quantity: ${doc['quantity']}, Price: ${doc['price']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    expenses.doc(doc.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen to add new expenses
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpensePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddExpensePage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  CollectionReference expenses = FirebaseFirestore.instance.collection('Expenses');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Expense'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            ElevatedButton(
              onPressed: () {
                expenses.add({
                  'title': titleController.text,
                  'quantity': int.parse(quantityController.text),
                  'price': double.parse(priceController.text),
                });
                Navigator.pop(context);
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}

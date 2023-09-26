import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';

class InvoiceListScreen extends StatefulWidget {
  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Invoices').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No invoices found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final invoiceData = snapshot.data!.docs[index].data()
              as Map<String, dynamic>;

              return Column(
                children: [
                  Container(
                    width: width*0.9,
                    height: height*0.8,
                    child: Image.network(
                      invoiceData['invoiceUrl'],
                      height: 300,
                    ),
                  ),
                  ListTile(
                   // title: Text('Invoice for Order #${invoiceData['offlineorderUID']}'),
                    title: Text(' #${invoiceData['offlineorderUID']}'),
                    subtitle: Text(
                      'Generated on: ${invoiceData['timestamp'].toDate()}',
                    ),
                    onTap: () {
                      // Implement navigation to view PDF or perform other actions
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
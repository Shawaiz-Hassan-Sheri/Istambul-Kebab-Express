import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/offline_orders.dart';

class InvoiceGenerator extends StatefulWidget {
  final OffLineOrders order;

  InvoiceGenerator({required this.order});
  @override
  _InvoiceGeneratorState createState() => _InvoiceGeneratorState();
}

class _InvoiceGeneratorState extends State<InvoiceGenerator> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> generateAndPrintInvoice(String orderId) async {
    try {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('OfflineOrders')
          .doc(widget.order.offlineorderUID)
          .get();

      if (orderSnapshot.exists) {
        Map<String, dynamic> orderData =
        orderSnapshot.data() as Map<String, dynamic>;

        pw.Document pdf = await generateInvoiceDocument(orderData);


        String pdfUrl = await saveInvoiceToFirebaseStorage(pdf);
        await saveInvoiceToFirestore(orderData, pdfUrl);
        printInvoice(pdf);

      } else {
        print('Order not found in Firestore.');
      }
    } catch (error) {
      print('Error generating or printing invoice: $error');
    }
  }

  Future<pw.Document> generateInvoiceDocument(
      Map<String, dynamic> orderData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Invoice for Order #${orderData['offlineorderUID']}',
                style:
                pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              // Add details about ordered items
              for (var item in orderData['orderItems'])
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${item['name']} (Qty: ${item['quantity']})'),
                    pw.Text('\$${item['totalPrice']}'),
                  ],
                ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Cost:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('\$${orderData['TotalCost']}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              // Add customer information, order date, etc.
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<String> saveInvoiceToFirebaseStorage(pw.Document pdf) async {

    final pdfImageBytes = await pdf.save();
    final pdfFileName = 'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final pdfRef = _storage.ref().child('Invoices').child(pdfFileName);
    final pdfUploadTask = pdfRef.putData(pdfImageBytes);

    await pdfUploadTask.whenComplete(() =>
        print('Invoice PDF saved to Firebase Storage: $pdfFileName'));

    final pdfUrl = await pdfRef.getDownloadURL();
    return pdfUrl;
  }

  Future<void> saveInvoiceToFirestore(
      Map<String, dynamic> orderData, String pdfUrl) async {
    await FirebaseFirestore.instance.collection('Invoices').add({
      'offlineorderUID': orderData['offlineorderUID'],
      'invoiceUrl': pdfUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance
        .collection('OfflineOrders')
        .doc(widget.order.offlineorderUID)
        .update({
      //status: normal = order is placed online
      //status: assigned = order is assigned to rider
      'status':'done',
    });

  }

  void printInvoice(pw.Document pdf) async {

    // Use the Printing class from the printing package to print the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      return pdf.save();
    });
    await FirebaseFirestore.instance
        .collection('OfflineOrders')
        .doc(widget.order.offlineorderUID)
        .update({
      //status: normal = order is placed online
      //status: assigned = order is assigned to rider
      'status':'done',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Generator'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => generateAndPrintInvoice('${widget.order.offlineorderUID}'),
          child: Text('Generate and Print Invoice'),
        ),
      ),
    );
  }
}


//
// void main() {
//   runApp(MaterialApp(
//     title: 'Invoice Generator Example',
//     theme: ThemeData(primarySwatch: Colors.blue),
//     initialRoute: '/',
//     routes: {
//       '/': (context) => InvoiceGenerator(order: null,),
//       '/invoiceList': (context) => InvoiceListScreen(),
//     },
//   ));
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  CollectionReference orders = FirebaseFirestore.instance.collection('Orders');
  List<DocumentSnapshot> orderData = [];
  String selectedPeriod = 'Weekly';
  int currentPage = 1;
  static const int itemsPerPage = 30;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    QuerySnapshot querySnapshot = await orders.get();
    setState(() {
      orderData = querySnapshot.docs;
    });
  }

  List<DocumentSnapshot> getVisibleOrders() {
    DateTime now = DateTime.now();
    List<DocumentSnapshot> visibleOrders = [];

    if (selectedPeriod == 'Weekly') {
      visibleOrders = orderData.where((doc) {
        DateTime orderTime = (doc['timestamp'] as Timestamp).toDate();
        return now.difference(orderTime).inDays <= 7; // Filter orders within 7 days
      }).toList();
    } else if (selectedPeriod == 'Monthly') {
      visibleOrders = orderData.where((doc) {
        DateTime orderTime = (doc['timestamp'] as Timestamp).toDate();
        return now.difference(orderTime).inDays <= 30; // Filter orders within 30 days
      }).toList();
    }

    return visibleOrders.skip((currentPage - 1) * itemsPerPage).take(itemsPerPage).toList();
  }


  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> visibleOrders = getVisibleOrders();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Reports',style: TextStyle(
          color: Colors.white
        ),),
        actions: [
          DropdownButton<String>(
            value: selectedPeriod,
            items: ['Weekly', 'Monthly'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: ( newValue) {
              setState(() {
                selectedPeriod = newValue!;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber, // Set the button's color to amber
                  ),
                  child: Text('<'

                    ,style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {

                    setState(() {
                      currentPage++;
                    });

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber, // Set the button's color to amber
                  ),
                  child: Text('>'

                    ,style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            DataTable(
              columns: [
                DataColumn(label: Text('Order #')),
                DataColumn(label: Text('Total Cost')),
              ],
              rows: visibleOrders.map((doc) {
                return DataRow(
                  cells: [
                    DataCell(Text('Order #${doc.id}')),
                    DataCell(Text('\$${doc['TotalCost']}')),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Total Cost: \$${visibleOrders.fold<double>(0, (sum, doc) => sum + doc['TotalCost'])}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Column(
        children: [

          // FloatingActionButton(
          //   onPressed: () {
          //     setState(() {
          //       currentPage++;
          //     });
          //   },
          //   child: Icon(Icons.arrow_forward),
          // ),
        ],
      ),
    );
  }
}



/*

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final double latitude;
  final int totalCost;
  final String orderUserUID;

  Order(this.latitude, this.totalCost, this.orderUserUID);
}

class AdminReportsPage extends StatefulWidget {
  @override
  _AdminReportsPageState createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  final int itemsPerPage = 10;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if(snapshot.data==null ){
            print('errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrror');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Order> orders = [];
          snapshot.data!.docs.forEach((doc) {
            orders.add(Order(
              doc.get('latitude'),
              doc.get('TotalCost'),
              doc.get('orderUserUID'),
            ));
          });

          int totalOrders = orders.length;
          int startIndex = currentPage * itemsPerPage;
          int endIndex = (currentPage + 1) * itemsPerPage;
          List<Order> paginatedOrders = orders.sublist(
            startIndex,
            endIndex < totalOrders ? endIndex : totalOrders,
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 40, // Set the height of each row
                    headingRowHeight: 50, // Set the height of the header row
                    dividerThickness: 2, // Set the thickness of the horizontal divider line
                    horizontalMargin: 10, // Set horizontal padding/margin for the entire table
                    columnSpacing: 20, // Set the spacing between columns

                    // Set the table border
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    columns: [
                      DataColumn(label: Text('Latitude')),
                      DataColumn(label: Text('Total Cost')),
                      DataColumn(label: Text('Order User')),
                    ],
                    rows: paginatedOrders.map((order) {
                      return DataRow(
                          cells: [
                        DataCell(Text(order.latitude.toString())),
                        DataCell(Text(order.totalCost.toString())),
                        DataCell(Text(order.orderUserUID,style: TextStyle(
                          overflow: TextOverflow.fade
                        ),)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: currentPage > 0 ? () => goToPage(currentPage - 1) : null,
                  ),
                  Text('Page ${currentPage + 1}'),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: endIndex < totalOrders ? () => goToPage(currentPage + 1) : null,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Total Orders: $totalOrders'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void goToPage(int page) {
    setState(() {
      currentPage = page;
    });
  }
}



*/
/*
class Order {
  final String id;
  final String totalCost;
  final double latitude;
  Order(this.id, this.totalCost, this.latitude);
}

class AdminReportsPage extends StatefulWidget {
  @override
  _AdminReportsPageState createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  final int itemsPerPage = 10;
  Query? ordersQuery;
  List<Order> orders = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Create the initial query
    ordersQuery = FirebaseFirestore.instance.collection('Orders').limit(itemsPerPage);
    fetchOrders();
  }

  void fetchOrders() {
    // Fetch the orders based on the current query
    ordersQuery!.get().then((snapshot) {
      setState(() {
        orders = snapshot.docs.map((doc) => Order(
          doc.get("orderUserUID"),
          doc.get('TotalCost'),
          doc.get('Latitude'),
        )).toList();
      });
    });
  }

  void goToPage(int page) {
    // Update the query with the new page's startAfter value
    ordersQuery = FirebaseFirestore.instance.collection('Orders')
        .orderBy('TotalCost')
        .startAfter([orders[page * itemsPerPage - 1].totalCost])
        .limit(itemsPerPage);
    fetchOrders();
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                header: Text('Orders'),
                columns: [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Total Cost')),
                  DataColumn(label: Text('Latitude')),
                ],
                source: _OrderDataSource(orders),
                onPageChanged: (page) => goToPage(page),
                rowsPerPage: itemsPerPage,
                availableRowsPerPage: [itemsPerPage],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text('Total Orders: ${orders.length}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDataSource extends DataTableSource {
  final List<Order> _orders;
  _OrderDataSource(this._orders);

  @override
  DataRow? getRow(int index) {
    if (index >= _orders.length) return null;
    final order = _orders[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(order.id,style: TextStyle(color: Colors.amber),)),
        DataCell(Text(order.totalCost)),
        DataCell(Text('\$${order.latitude.toStringAsFixed(2)}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _orders.length;

  @override
  int get selectedRowCount => 0;
}
*/



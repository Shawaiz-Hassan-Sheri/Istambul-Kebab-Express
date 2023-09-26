import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/admin_employee.dart';
import '../widgets/admin_mydrawer.dart';
import 'admin_employee_details_screen.dart';


class AdminEmployeeScreen extends StatefulWidget {
  // final AdminMenu? model;
  // AdminEmployeeScreen({this.model});

  @override
  _AdminEmployeeScreenState createState() => _AdminEmployeeScreenState();

}

class _AdminEmployeeScreenState extends State<AdminEmployeeScreen> {
  final ScrollController inProgressController = ScrollController();
  final ScrollController completedController = ScrollController();

  @override
  Widget build(BuildContext context) {


    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
      ),
      drawer: AdminMyDrawer(),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(-2.0, 0.0),
            end: FractionalOffset(5.0, -1.0),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAC898),
            ],
          ),
        ),
        child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Text("Employees Data"),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Employee')
                      // .where("orderUserUID", isEqualTo: widget.userid)
                      // .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    return SingleChildScrollView(
                      controller: completedController,
                      child: Scrollbar(
                        controller: completedController,
                        thickness: 4,
                        // Define the color of the scrollbar track
                        trackVisibility: true,
                        // Define the color of the scrollbar thumb
                        thumbVisibility: true,
                        child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            AdminEmployee employee = AdminEmployee.fromJson(snapshot.data!.docs[index]
                                .data() as Map<String, dynamic>);

                            return Container(
                             // margin: EdgeInsets.symmetric(vertical: 2),
                              margin: EdgeInsets.symmetric(vertical: 4,horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                title: Text('Name : ${employee.employeeName}',style: TextStyle(
                                  color: Colors.black,
                                ),),
                                // subtitle: Text('Total: \$${orderTotal(order)}',style: TextStyle(
                                //   color: Colors.black,
                                // ),),
                                children: [

                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => ShowRiderProgress(
                                          //       orderID: order.id,
                                          //       riderID: order.assignedRider,
                                          //     ),
                                          //   ),
                                          // );
                                          // Show the rider's progress and order status
                                          // ScaffoldMessenger.of(context).showSnackBar(
                                          //   SnackBar(content: Text('Rider Progress and Order Status')),
                                          // );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.amber, // Set the button's color to amber
                                        ),
                                        child: Text('Show Rider Progress'

                                        ,style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.amber, // Set the button's color to amber
                                        ),
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdminEmployeeDetailsScreen(model:employee),
                                            ),
                                          );
                                        },
                                        child: Text('Show Employee'
                                          ,style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),

                                      )
                                    ],
                                  ),

                                ],
                                // trailing: Icon(Icons.electric_bike_outlined,),
                              ),
                            );
                          },
                        ),
                      ),
                    );

                  },
                ),
              ],
            )

        ),
      ),
    );
  }
}

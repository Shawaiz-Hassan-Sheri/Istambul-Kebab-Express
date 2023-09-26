import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:users_food_app/user/assistantMethods/assistant_methods.dart';
import 'package:users_food_app/user/global/global.dart';
import 'package:users_food_app/user/widgets/design/order_card_design.dart';
import 'package:users_food_app/user/widgets/progress_bar.dart';
import 'package:users_food_app/user/widgets/simple_app_bar.dart';

import '../../manager/models/offline_orders.dart';
import '../../manager/widgets/orders_detail_screen.dart';
import 'orders_history/manager_cancel_order.dart';
import 'orders_history/manager_notreceived_order.dart';
import 'orders_history/manager_offline_history.dart';
import 'orders_history/manager_online_history.dart';

class ManagerHistoryScreen extends StatefulWidget {
  late String userid;
  ManagerHistoryScreen({required this.userid});
  @override
  _ManagerHistoryScreenState createState() => _ManagerHistoryScreenState();
}

class _ManagerHistoryScreenState extends State<ManagerHistoryScreen> {
  final ScrollController completedController = ScrollController();
  double orderTotal(OnlineOrders order) {
    double total = 0.0;
    order.orderItems.forEach((item) => total += item.price * item.quantity);
    return total;
  }
  // String formattedDate='';
  // String formattedTime='';
  // Future<void> timefix(Timestamp _timestamp) async{
  //   DateTime dateTime = await _timestamp.toDate();
  //    formattedDate = await DateFormat('dd MMMM yyyy').format(dateTime);
  //    formattedTime = await DateFormat('jm').format(dateTime);
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: SimpleAppBar(
        title: "History",
      ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: height*0.03,),
              Container(
                width: width*0.6,
                height: height*0.2,
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagerOfflineHistory(userid: widget.userid,),
                      ),
                    );
                    //_placeOrder(widget.order.offlineorderUID);
                  },
                  child: Text('Offline Orders',style: TextStyle(
                    fontSize: height*0.03
                  ),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: height*0.03,),
              Container(
                width: width*0.6,
                height: height*0.2,
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagerOnlineHistory(userid: widget.userid,),
                      ),
                    );
                    //_placeOrder(widget.order.offlineorderUID);
                  },
                  child: Text('Online Orders',style: TextStyle(
                    fontSize: height*0.03
                  ),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: height*0.03,),
              Container(
                width: width*0.6,
                height: height*0.2,
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagerNotaReceivedOrder(userid: widget.userid,),
                      ),
                    );
                    //_placeOrder(widget.order.offlineorderUID);
                  },
                  child: Text('Not Received',style: TextStyle(
                      fontSize: height*0.03
                  ),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: height*0.03,),
              Container(
                width: width*0.6,
                height: height*0.2,
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagerCancelOrder(userid: widget.userid,),
                      ),
                    );
                    //_placeOrder(widget.order.offlineorderUID);
                  },
                  child: Text('Cancel Orders',style: TextStyle(
                      fontSize: height*0.03
                  ),),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}

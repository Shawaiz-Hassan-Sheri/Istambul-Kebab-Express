import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_food_app/admin/models/admin_menu.dart';

import 'package:users_food_app/admin/widgets/admin_mydrawer.dart';
import 'package:users_food_app/admin/models/admin_menu.dart';
import 'package:users_food_app/user/widgets/text_widget_header.dart';

import '../../user/widgets/progress_bar.dart';
import '../widgets/admin_items_design.dart';


class AdminMenuItems extends StatefulWidget {
  // final AdminMenu? model;
  // AdminMenuItems({this.model});

  @override
  _AdminMenuItemsState createState() => _AdminMenuItemsState();

}

class _AdminMenuItemsState extends State<AdminMenuItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminMyDrawer(),
      body: Container(
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
        child: CustomScrollView(
          slivers: [
            //appbar
            SliverAppBar(
              elevation: 1,
              pinned: true,
              backgroundColor: const Color(0xFFFAC898),
              foregroundColor: Colors.black,
              expandedHeight: 50,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(-1.0, 0.0),
                    end: FractionalOffset(4.0, -1.0),
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFAC898),
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      child: const Icon(Icons.add),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (c) => ItemsUploadScreen(model:widget.model! ,),
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                //  title: widget.model!.admintitle.toString().toUpperCase() + "'s Menu Items".toUpperCase()
                  title: "Menu of istanbul".toUpperCase()

              ),
            ),
            //divider
            const SliverToBoxAdapter(
              child: Divider(color: Colors.white, thickness: 2),
            ),
            StreamBuilder<QuerySnapshot> (
              stream: FirebaseFirestore.instance
                  .collection("Items")
              //ordering menus and items by publishing date (descending)
                  //.orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)  {

                 return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                )
                    : SliverStaggeredGrid.countBuilder(
                  staggeredTileBuilder: (c) =>
                  const StaggeredTile.count(1, 1.5),
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  itemBuilder: (context, index)  {

                    AdminMenu model = AdminMenu.fromJson(
                        snapshot.data!.docs[index].data()
                        as Map<String, dynamic>);


                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child:ListTile(
                      //     leading: const Icon(Icons.flight_land),
                      //     title:  Text(
                      //       model.admintitle!,
                      //     ),
                      //     subtitle: const Text('The airplane is only in Act II.'),
                      //     onTap: () => print("ListTile")
                      // )
                      child: AdminItemsDesign(
                        name: model.admintitle as String ,
                        model: model,
                        context: context,
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

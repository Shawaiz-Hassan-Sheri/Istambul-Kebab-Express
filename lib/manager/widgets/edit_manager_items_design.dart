import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/manager/models/offline_orders.dart';
import 'package:users_food_app/user/models/items.dart';
import 'package:users_food_app/user/screens/item_detail_screen.dart';


// ignore: must_be_immutable
class EditManagerItemsDesignWidget extends StatefulWidget {
  OrderItem1 model;
  String name="";
  BuildContext context;
  Function addToSelectedItems;
  EditManagerItemsDesignWidget({Key? key,required this.addToSelectedItems ,
    required this.context, required this.name, required this.model}) : super(key: key);

  @override
  _EditManagerItemsDesignWidgetState createState() => _EditManagerItemsDesignWidgetState();
}

class _EditManagerItemsDesignWidgetState extends State<EditManagerItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.model.imageUrl!,
                    height: height*0.2,
                    width: width*0.35,
                    fit: BoxFit.cover,
                  ),
                ),

                Text(
                  widget.model!.name!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.model!.price! as String,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print("function is clicked..................................");
          widget.addToSelectedItems(widget.model);
          Scaffold.of(context).openEndDrawer();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (c) => ItemDetailsScreen(model: widget.model),
          //   ),
          // );
        });
    //   ),
    // );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:users_food_app/user/models/items.dart';
import 'package:users_food_app/user/screens/item_detail_screen.dart';

import '../models/orders.dart';




// ignore: must_be_immutable
class ManagerEditManagerItemsDesignWidget extends StatefulWidget {
  Orders model;

  BuildContext context;

  ManagerEditManagerItemsDesignWidget({Key? key, required this.context, required this.model}) : super(key: key);

  @override
  _ManagerEditManagerItemsDesignWidgetState createState() => _ManagerEditManagerItemsDesignWidgetState();
}

class _ManagerEditManagerItemsDesignWidgetState extends State<ManagerEditManagerItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: height*0.4,
            width: MediaQuery.of(context).size.width,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    //widget.model.items!.pizza.thumbnailUrl!,
                    widget.model.items[index].pizza.title.
                    height: height*0.2,
                    width: width*0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.model.items!.pizza.title!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.model.items!.pizza.price! as String,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (c) => ItemDetailsScreen(model: widget.model),
          //   ),
          // );
        });
    //   ),
    // );
  }
}

*/
/*
class ManagerEditManagerItemsDesignWidget extends StatefulWidget {
  Items? model;

  ManagerEditManagerItemsDesignWidget({this.model});

  @override
  _ManagerEditManagerItemsDesignWidgetState createState() => _ManagerEditManagerItemsDesignWidgetState();
}

class _ManagerEditManagerItemsDesignWidgetState extends State<ManagerEditManagerItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((c) => ItemDetailsScreen(model: widget.model)),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 1),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.model!.thumbnailUrl!,
                  height: height*0.2,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 1),
              const SizedBox(height: 5),
              Text(
                widget.model!.title!,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.model!.shortInfo!,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
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
*/

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool isObsecre = true;
  bool? enabled = true;

  CustomPasswordTextField({

    Key? key,
    this.controller,
    this.data,
    this.enabled,
    this.hintText,
    required this.isObsecre,
  }) : super(key: key);

  @override
  State<CustomPasswordTextField> createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.controller,
        obscureText: widget.isObsecre,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(widget.isObsecre ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
               setState(() {
                 widget.isObsecre = !widget.isObsecre;
               });

            },
          ),
          hintText: widget.hintText,
          labelText: widget.hintText,
          fillColor: Colors.white70,
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}

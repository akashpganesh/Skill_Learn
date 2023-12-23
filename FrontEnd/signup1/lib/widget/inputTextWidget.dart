import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final labelText;
  final icon;
  final bool obscureText;
  final keyboardType;
  final controller;
  final validator;
  final initialValue;
  final hintText;

  const InputTextWidget(
      {
        this.labelText,
        this.icon,
        required this.obscureText,
        required this.keyboardType,
        this.controller,
        this.validator,
        this.initialValue,
        this.hintText})
      : super();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Container(
        child: Material(
          elevation: 15.0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(15.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 15.0),
            child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                autofocus: false,
                keyboardType: keyboardType,
                validator: validator,
                initialValue: initialValue,
                decoration: InputDecoration(
                  icon: Icon(
                    icon,
                    color: Colors.black,
                    size: 32.0, /*Color(0xff224597)*/
                  ),
                  labelText: labelText,
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 18.0),
                  hintText: hintText,
                  enabledBorder: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  border: InputBorder.none,
                ),



                ),
          ),
        ),
      ),
    );
  }
}
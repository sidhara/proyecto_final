// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final String text;
  bool password;
  final TextEditingController controller;
  TextFieldCustom({Key? key, required this.text, required this.controller, required this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(password){
      return TextFormField(
        obscureText: password,
        obscuringCharacter: "*",
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20)
          ),
          labelText: text
        ),
      );
    }else{
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20)
          ),
          labelText: text
        ),
      );
    }
  }
}
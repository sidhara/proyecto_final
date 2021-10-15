// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final String text;
  final bool password;
  final TextEditingController controller;
  const TextFieldCustom({Key? key, required this.text, required this.controller, required this.password}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(password){
      return TextFormField(
        obscureText: true,
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
// ignore_for_file: file_names
import 'package:flutter/material.dart';

class BackButtonCustom extends StatelessWidget {
  final Color backgroundColor;
  final Function()? onTap;
  final bool? isBorder;
  const BackButtonCustom({Key? key,
  required this.backgroundColor,
  this.onTap,
  this.isBorder=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 25,bottom: 5),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(150),
          border: Border.all(
            width: 2,
            color: backgroundColor
          )
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        )
      ),
    );
  }
}
// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class LargeCircularButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final Function()? onTap;
  final bool? isBorder;
  const LargeCircularButton({Key? key,
  required this.backgroundColor,
  required this.textColor,
  required this.text,
  this.onTap,
  this.isBorder=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: (width-150)/2),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(150),
          border: Border.all(
            width: 2,
            color: backgroundColor
          )
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: textColor
            ),
          ),
        )
      ),
    );
  }
}
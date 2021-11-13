// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class LargeRectangularButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final Function()? onTap;
  final bool? isBorder;
  
  const LargeRectangularButton({Key? key,
  required this.backgroundColor,
  required this.textColor,
  required this.text,
  this.onTap,
  this.isBorder=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        height: 60,
        width: MediaQuery.of(context).size.width-60,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
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
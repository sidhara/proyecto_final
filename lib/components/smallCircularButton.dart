// ignore_for_file: file_names
import 'package:flutter/material.dart';

class SmallCircularButtonCustom extends StatelessWidget {
  final Color backgroundColor;
  final Function()? onTap;
  final bool? isBorder;
  final String type;
  final Color? iconColor;
  const SmallCircularButtonCustom({Key? key,
  required this.backgroundColor,
  this.onTap,
  this.isBorder=false, 
  required this.type, 
  this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(type=='go_back'){
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 25,bottom: 5),
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
          child: Center(
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: iconColor,
            ),
          )
        ),
      );
    }else if(type=='update'){
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 20,top: 5),
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
          child: Center(
            child: Icon(
              Icons.update,
              size: 30,
              color: iconColor,
            ),
          )
        ),
      );
    }else if(type=='humidity_analysis'){
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width-75,top: 5),
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
          child: Center(
            child: Icon(
              Icons.water_damage,
              size: 30,
              color: iconColor,
            ),
          )
        ),
      );
    }else{
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width-75,top: 5),
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
          child: Center(
            child: Icon(
              Icons.dark_mode,
              size: 30,
              color: iconColor,
            ),
          )
        ),
      );
    }
  }
}
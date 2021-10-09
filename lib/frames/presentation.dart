import 'package:flutter/material.dart';
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeRectangularButton.dart';

class Presentation extends StatefulWidget {
  Presentation({Key? key}) : super(key: key);

  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  @override
  Widget build(BuildContext context) {

    double heigth=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        height: heigth,
        child: Stack(
          children: [
            layout()
          ]
        )
      )
    );
  }

  layout(){
    return Container(
      child: Stack(
        children: [
          mainBackground(),
          logo(),
          startButton()
        ],
      ),
    );
  }

  mainBackground(){
    return Positioned(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/fondo1.png"
            )
          )
        ),
      )
    );
  }
  
  logo(){
    return Positioned(
      left: MediaQuery.of(context).size.width/6,
      top: 150,
      child: Container(
        //alignment: Alignment.center,
        height: 300,
        width: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(
            scale: 0.8,
            image: AssetImage(
              "assets/images/Logo1.png"
            )
          )
        ),
      )
    );
  }

  startButton(){
    return Positioned(
      bottom: 20,
      child: LargeRectangularButton(
        backgroundColor: AppColor.green, 
        textColor: AppColor.fonts, 
        text: "start"
      )
    );
  }
}
import 'package:flutter/material.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeRectangularButton.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
import 'package:proyecto_final/frames/login.dart';

class Presentation extends StatefulWidget {
  Presentation({Key? key}) : super(key: key);

  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {

  @override
  void initState(){//se controla la orientacion del frame para bloquearla verticalmente
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
  }

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
          logo(150),
          startButton(20)
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
              "assets/images/Fondo.png"
            )
          )
        ),
      )
    );
  }
  
  logo(double distanceFromTop){
    return Positioned(
      left: MediaQuery.of(context).size.width/6,
      top: distanceFromTop,
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

  startButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: LargeRectangularButton(
        backgroundColor: AppColor.green, 
        textColor: AppColor.fonts, 
        text: "start",
        onTap: onPressed
      )
    );
  }

  onPressed(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}
import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeCircularButton.dart';
import 'package:proyecto_final/components/largeRectangularButton.dart';
import 'package:proyecto_final/components/backButton.dart';
import 'package:proyecto_final/frames/humidity.dart';
import 'package:proyecto_final/frames/ph.dart';
import 'package:proyecto_final/frames/temperature.dart';
import 'package:proyecto_final/frames/water.dart';

class Control extends StatefulWidget {
  Control({Key? key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {

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
          text('Control'),
          tray(300),
          humidityButton(320),
          phButton(400),
          temperatureButton(480),
          waterButton(20),
          goBackButton(20)
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
  
  text(String text){
    return Positioned(
      top: 50,
      width: 200,
      left: (MediaQuery.of(context).size.width-200)/2,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: AppColor.fonts
        ),
      ) 
    );
  }

  tray(double distanceFromTop){
    return Positioned(
      top: distanceFromTop,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height-distanceFromTop,
        width: MediaQuery.of(context).size.width,
        decoration: 
          BoxDecoration(
            color: AppColor.green,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft:  Radius.circular(30)
            ) 
          ),
      ),
    );
  }

  humidityButton(double distanceFromTop){
    return Positioned(
      top: distanceFromTop,
      child: LargeRectangularButton(
        backgroundColor: AppColor.blue, 
        textColor: AppColor.fonts, 
        text: "Humidity",
        onTap: () => onPressed(0)
      )
    );
  }

  phButton(double distanceFromTop){
    return Positioned(
      top: distanceFromTop,
      child: LargeRectangularButton(
        backgroundColor: AppColor.lightGreen, 
        textColor: AppColor.fonts, 
        text: "PH",
        onTap: () => onPressed(1)
      )
    );
  }  

  temperatureButton(double distanceFromTop){
    return Positioned(
      top: distanceFromTop,
      child: LargeRectangularButton(
        backgroundColor: AppColor.lightRed, 
        textColor: AppColor.fonts, 
        text: "Temperature",
        onTap: () => onPressed(2)
      )
    );
  }  

  waterButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: LargeCircularButton(
        backgroundColor: Colors.white, 
        textColor: AppColor.fonts, 
        text: "WATER",
        onTap: () => onPressed(3)
      )
    );
  }  

  goBackButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: BackButtonCustom(
        backgroundColor: Colors.white, 
        onTap: () => onPressed(4)
      )
    );
  }  

  onPressed(int type){
    if(type==0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Humidity()),
      );    
    }else if(type==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Ph()),
      );    
    }else if(type==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Temperature()),
      );    
    }else if(type==3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Water()),
      );    
    }else{
      Navigator.pop(context);
    }
  }
}
import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/backButton.dart';
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeCircularButton.dart';

class Water extends StatefulWidget {
  Water({Key? key}) : super(key: key);

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {

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
          text('Water'),
          tray(300),
          waterIcon(320),
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

  waterIcon(double distanceFromTop){
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
              "assets/images/Rain.png"
            )
          )
        ),
      )
    );
  }

  waterButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: LargeCircularButton(
        backgroundColor: AppColor.blue, 
        textColor: AppColor.fonts, 
        text: "Irrigate",
        onTap: () => onPressed(0)
      )
    );
  }  

  goBackButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: BackButtonCustom(
        backgroundColor: Colors.white, 
        onTap: () => onPressed(1)
      )
    );
  }  

  onPressed(int type){
    if(type==0){
      irrigate();
    }else{
      Navigator.pop(context);
    }
  }

  final snackBar = const SnackBar(content: Text('Irrigation succesful!'));

  irrigate(){
    //code here
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
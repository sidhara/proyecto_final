import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/backButton.dart';

class Ph extends StatefulWidget {
  Ph({Key? key}) : super(key: key);

  @override
  _PhState createState() => _PhState();
}

class _PhState extends State<Ph> {

  @override
  void initState(){//se controla la orientacion del frame para bloquearla verticalmente
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
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
              "assets/images/FondoHorizontal.png"
            )
          )
        ),
      )
    );
  }

  goBackButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: BackButtonCustom(
        backgroundColor: Colors.white, 
        onTap: () => onPressed()
      )
    );
  }  

  onPressed(){
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
    ]);
    Navigator.pop(context);
  }
}
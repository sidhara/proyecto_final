import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/smallCircularButton.dart';
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeCircularButton.dart';
import 'package:proyecto_final/settings/settings.dart';

class Water extends StatefulWidget {
  const Water({Key? key}) : super(key: key);

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  bool darkmode=false;

  @override
  void initState(){
    super.initState();

    SystemChrome.setPreferredOrientations([//se controla la orientacion del frame para bloquearla verticalmente
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);

    loadDarkModeSetting();
  }

  loadDarkModeSetting()async{
    final prefereredSetting=PreferencesService();
    DarkmodeSetting setting=await prefereredSetting.getDarkmodeSettings();
    setState(() {
      if(setting.darkmode==null) {
        darkmode=false;
      } else {
        darkmode=setting.darkmode!;
      }   
    }); 
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
    if(darkmode){
      return Positioned(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/FondoDark.png"
              )
            )
          ),
        )
      );
    }else{
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
    if(darkmode){
      return Positioned(
        bottom: distanceFromBottom,
        child: LargeCircularButton(
          backgroundColor: AppColor.darkModeGrey, 
          textColor: Colors.white, 
          text: "Irrigate",
          onTap: () => onPressed(0)
        )
      );
    }else{
      return Positioned(
        bottom: distanceFromBottom,
        child: LargeCircularButton(
          backgroundColor: Colors.white, 
          textColor: AppColor.fonts, 
          text: "Irrigate",
          onTap: () => onPressed(0)
        )
      );
    }
  }  

  goBackButton(double distanceFromBottom){
    if(darkmode){
      return Positioned(
        bottom: distanceFromBottom,
        child: SmallCircularButtonCustom(
          backgroundColor: AppColor.darkModeGrey, 
          onTap: () => onPressed(1),
          type: 'go_back',
          iconColor: Colors.white,
        )
      );
    }else{
      return Positioned(
        bottom: distanceFromBottom,
        child: SmallCircularButtonCustom(
          backgroundColor: Colors.white, 
          onTap: () => onPressed(1),
          type: 'go_back',
        )
      );
    }
  }  

  onPressed(int type){
    if(type==0){
      irrigate();
    }else{
      Navigator.pop(context);//se navega al frame anterior
    }
  }

  final snackBar = const SnackBar(content: Text('Irrigation succesful!'));//muestra un mensaje en la pantalla del dispositivo

  irrigate(){//en desarrollo
    //code para downlink de riego
    ScaffoldMessenger.of(context).showSnackBar(snackBar);//muestra un mensaje en la pantalla del dispositivo
  }
}
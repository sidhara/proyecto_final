import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeCircularButton.dart';
import 'package:proyecto_final/components/largeRectangularButton.dart';
import 'package:proyecto_final/components/smallCircularButton.dart';
//import para la navegacion entre frames
import 'package:proyecto_final/frames/humidity.dart';
import 'package:proyecto_final/frames/ph.dart';
import 'package:proyecto_final/frames/temperature.dart';
import 'package:proyecto_final/frames/water.dart';
//import para la persistencia de datos de configuracion en el sistema
import 'package:proyecto_final/settings/settings.dart';

class Control extends StatefulWidget {
  const Control({Key? key}) : super(key: key);
  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
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
      // ignore: sized_box_for_whitespace
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
    return Stack(
      children: [
        mainBackground(),
        text('Control'),
        tray(300),
        humidityButton(320),
        phButton(400),
        temperatureButton(480),
        waterButton(20),
        switchMode(20)
      ],
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
            borderRadius: const BorderRadius.only(
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
    if(darkmode){
      return Positioned(
        bottom: distanceFromBottom,
        child: LargeCircularButton(
          backgroundColor: AppColor.darkModeGrey, 
          textColor: Colors.white, 
          text: "WATER",
          onTap: () => onPressed(3)
        )
      );
    }else{
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
  }  

  switchMode(double distanceFromBottom){
    if(darkmode){
      return Positioned(
        bottom: distanceFromBottom,
        child: SmallCircularButtonCustom(
          backgroundColor: AppColor.darkModeGrey, 
          onTap: () => onPressed(4),
          type: 'darkmode',
          iconColor: Colors.white,
        )
      );
    }else{
      return Positioned(
        bottom: distanceFromBottom,
        child: SmallCircularButtonCustom(
          backgroundColor: Colors.white, 
          onTap: () => onPressed(4),
          type: 'darkmode',
          iconColor: AppColor.fonts,
        )
      );
    }
  }

  goBackButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: SmallCircularButtonCustom(
        backgroundColor: Colors.white, 
        onTap: () => onPressed(4),
        type: 'go_back',
      )
    );
  }  

  onPressed(int type){//se maneja la navegacion a cada uno de los frames siguientes
    if(type==0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Humidity()),
      );    
    }else if(type==1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Ph()),
      );    
    }else if(type==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Temperature()),
      );    
    }else if(type==3){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Water()),
      );    
    }else if(type==4){
      setState(() {
        darkmode=!darkmode;
        saveSettings();
      });
    }
  }

  saveSettings()async{
    PreferencesService setSettings=PreferencesService();
    setSettings.saveDarkmodeSettings(
      DarkmodeSetting(darkmode: darkmode)
    );
  }

}
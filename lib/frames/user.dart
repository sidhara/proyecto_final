import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeCircularButton.dart';
import 'package:proyecto_final/components/smallCircularButton.dart';
import 'package:proyecto_final/frames/presentation.dart';
//import para la persistencia de datos de configuracion en el sistema
import 'package:proyecto_final/settings/settings.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  bool darkmode=false;

  @override
  void initState(){
    super.initState();
    
    SystemChrome.setPreferredOrientations([//se controla la orientacion del frame para bloquearla verticalmente
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);

    loadDarkModeSetting();
    loadCredentials();
  }

  loadCredentials() async {
    final prefereredSetting=PreferencesService();
    LoginSettings savedLoginSettings=await prefereredSetting.getLoginSettings();
    setState(() {
      username=savedLoginSettings.username!;
      email=savedLoginSettings.email!;
    });
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

  String username="",
    email="";

  layout(){
    return Stack(
      children: [
        mainBackground(),
        tray(300),
        text('Personal info',40,200,36),
        text(username, 350,MediaQuery.of(context).size.width-20,40),
        text(email, 400,MediaQuery.of(context).size.width-20,30),
        goBackButton(5),
        logOffButton(20)
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

  text(String text,double top,double width,double fontSize){
    return Positioned(
      top: top,
      width: width,
      left: (MediaQuery.of(context).size.width-width)/2,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: AppColor.fonts
        ),
      ) 
    );
  }

  logOffButton(double distanceFromBottom){
    if(darkmode){
      return Positioned(
        bottom: distanceFromBottom,
        child: LargeCircularButton(
          backgroundColor: AppColor.darkModeGrey, 
          textColor: Colors.white, 
          text: "Log Off",
          onTap: () => onPressed(1)
        )
      );
    }else{
      return Positioned(
        bottom: distanceFromBottom,
        child: LargeCircularButton(
          backgroundColor: Colors.white, 
          textColor: AppColor.fonts, 
          text: "Log Off",
          onTap: () => onPressed(1)
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
          onTap: () => onPressed(0),
          type: 'go_back',
          iconColor: Colors.white,
        )
      );
    }else{
      return Positioned(
        bottom: distanceFromBottom,
        child: SmallCircularButtonCustom(
          backgroundColor: Colors.white, 
          onTap: () => onPressed(0),
          type: 'go_back',
        )
      );
    }
  }  

  onPressed(int type){//se maneja la navegacion a cada uno de los frames siguientes
    if(type==0){
      Navigator.pop(context);//se navega al frame anterior
    }else if(type==1){
      PreferencesService settings=PreferencesService();
      settings.deleteLoginSettings();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Presentation()),
        (route) => false
      );    
    }
  }

}
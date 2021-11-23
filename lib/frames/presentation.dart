import 'package:flutter/material.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeRectangularButton.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
import 'package:proyecto_final/frames/control.dart';
//import para la navegacion entre frames
import 'package:proyecto_final/frames/login.dart';
//import para la persistencia de datos de configuracion en el sistema
import 'package:proyecto_final/settings/settings.dart';

class Presentation extends StatefulWidget {
  const Presentation({Key? key}) : super(key: key);

  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {

  bool darkmode=false;

  @override
  void initState(){
    loadDarkModeSetting();

    super.initState();

    SystemChrome.setPreferredOrientations([//se controla la orientacion del frame para bloquearla verticalmente
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    
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

    double heigth=MediaQuery.of(context).size.height;//MediaQuery.of(context).size.width es el alto de la pantalla del dispositivo
    
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
        logo(150),
        text('Plantzilla'),
        startButton(20)
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
    if(darkmode){
      return Positioned(
        top: 400,
        width: 200,
        left: (MediaQuery.of(context).size.width-200)/2,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.white
          ),
        ) 
      );
    }else{
      return Positioned(
        top: 400,
        width: 200,
        left: (MediaQuery.of(context).size.width-200)/2,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.black54
          ),
        ) 
      );
    }
  }

  logo(double distanceFromTop){
    return Positioned(
      left: (MediaQuery.of(context).size.width-300)/2,//MediaQuery.of(context).size.width es el ancho de la pantalla del dispositivo 
      top: distanceFromTop,
      child: Container(
        height: 300,
        width: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(
            scale: 0.8,
            image: AssetImage(
              "assets/images/Logo.ico"
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

  onPressed()async{
    final prefereredSetting=PreferencesService();
    LoginSettings savedLoginSettings=await prefereredSetting.getLoginSettings();

    if(await hasCredentials(savedLoginSettings)){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Control()),
        (route) => false
      );    
    }else{
      Navigator.push(//navega al frame de login
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  Future<bool> hasCredentials(LoginSettings settings)async{
      if(settings.email==null || settings.password==null){
        return false;
      }
    return true;
  }
}
import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeRectangularButton.dart';
import 'package:proyecto_final/components/textField.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
            layout(),
            logo(),
            tray(370),
            loginInputs(390),
            loginButton()
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
  
  logo(){
    return Positioned(
      left: MediaQuery.of(context).size.width/6,
      top: 100,
      child: Container(
        //alignment: Alignment.center,
        height: 300,
        width: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(
            scale: 0.8,
            image: AssetImage(
              "assets/images/Logo.png"
            )
          )
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

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  loginInputs(double distanceFromTop){
    double extension=MediaQuery.of(context).size.width-60;
    return Positioned(
      top: distanceFromTop,
      width: extension,
      left: (MediaQuery.of(context).size.width-extension)/2,
      child: Column(
        children: [
          TextFieldCustom(//textfield para email
            text: 'E-mail', 
            controller: emailTextController, 
            password: false),
          const SizedBox(//espaciado entre textfields
            height: 20,
          ),
          TextFieldCustom(//textfield para contraseñas
            password: true,
            controller: passwordTextController,
            text: 'Password',
          )
        ],
      )
    );
  }

  loginButton(){
    return Positioned(
      bottom: 20,
      child: LargeRectangularButton(
        backgroundColor: Colors.white, 
        textColor: AppColor.fonts, 
        text: "login",
        onTap: onPressed
      )
    );
  }

  onPressed(){
    String email=emailTextController.text,
    password=passwordTextController.text;
  }
}
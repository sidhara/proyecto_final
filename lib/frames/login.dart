import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/colors.dart';
import 'package:proyecto_final/components/largeRectangularButton.dart';
import 'package:proyecto_final/components/textField.dart';
//import para la conexion al sql
import 'package:http/http.dart' as http;
import 'dart:convert';
//import para la navegacion entre frames
import 'package:proyecto_final/frames/control.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String url='https://naturemonitorsoftware.000webhostapp.com/getLogin.php';//url del servicio que continene los datos de las credenciales de inicio de sesion para consumir | https://naturemonitorsoftware.000webhostapp.com/getLogin.php | http://3.220.8.74/getLogin.php

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([//se controla la orientacion del frame para bloquearla verticalmente
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    getData(url);//se obtienen los datos inicialmente y se cargan las estructuras de datos y validaciones
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
            layout(),
          ]
        )
      )
    );
  }

  layout(){
    return Stack(
      children: [
        mainBackground(),
        text('Welcome'),
        logo(),
        tray(470),
        loginInputs(300),
        loginButton(20)
      ],
    );
  }

  mainBackground(){
    return Positioned(
      //top: 1,
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

  tray(double size){
    return Positioned(
      bottom: 0,
      child: Container(
        alignment: Alignment.center,
        height: size,
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

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  loginInputs(double distanceFromBottom){
    double extension=MediaQuery.of(context).size.width-60;
    return Positioned(
      bottom: distanceFromBottom,
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

  loginButton(double distanceFromBottom){
    return Positioned(
      bottom: distanceFromBottom,
      child: LargeRectangularButton(
        backgroundColor: Colors.white, 
        textColor: AppColor.fonts, 
        text: "login",
        onTap: () => onPressed()
      )
    );
  }

  onPressed(){
      if(validation()){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Control()),
          (route) => false
        );    
      }
  }

  late List<LoginCredential>loginCredentials;
  final snackBar = const SnackBar(content: Text('Error, the credential does not exist!'));//muestra un mensaje en la pantalla del dispositivo

  bool validation(){
    String email=emailTextController.text,
    password=passwordTextController.text;

    for(LoginCredential credential in loginCredentials){
      if(email==credential.email){
        if(password==credential.password){
          return true;
        }
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);//muestra un mensaje en la pantalla del dispositivo
    return false;
  }

  Future getData(String url) async {//funcion para recibir la informacion del servidor sobre los logins, la formatea y la guarda en estructuras de datos necesarias
    loginCredentials=<LoginCredential>[];

    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
      if(response.body.isNotEmpty){
        if(response.statusCode==200){
          List credentials=json.decode(response.body);//{id: 1, email: example@gmail.com, password: example}
          List<Text> credentialInfo;
          for(dynamic crendential in credentials){
            credentialInfo=crendential.toString().split(', ').map((String text) => Text(text)).toList();
            loginCredentials.add(
              LoginCredential(
                int.parse(credentialInfo[0].data!.substring(5)), 
                credentialInfo[1].data!.substring(7), 
                credentialInfo[2].data!.substring(10,credentialInfo[2].data!.length-1)
              )
            );
          }
        }
      }
  }
}

class LoginCredential{
  late int id;
  late String email;
  late String password;

  LoginCredential(this.id,this.email,this.password);
}
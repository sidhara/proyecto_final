import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/backButton.dart';
//import para la conexion al sql
import 'package:http/http.dart' as http;
import 'dart:convert';

class Humidity extends StatefulWidget {
  Humidity({Key? key}) : super(key: key);

  @override
  _HumidityState createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {

  @override
  void initState(){//se controla la orientacion del frame para bloquearla verticalmente
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
    ]);
    getData();
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
      ),
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

  List<DatoHumedad> datosHumedad=<DatoHumedad>[];

  Future getData()async{

    Uri url=Uri.parse('https://naturemonitorsoftware.000webhostapp.com/show.php');
    http.Response response=await http.get(url);
    if(response.body.isNotEmpty) {
        if (response.statusCode == 200)
        {
          List data=json.decode(response.body);//{id: 2, humidity: 70, date: 2021-10-18 07:00:40}
          List<Text> valores;
          for(dynamic dato in data){
            valores=dato.toString().split(', ').map((String text) => Text(text)).toList();
            
            //DateTime fix
            List<Text> fecha=valores[2].data!.substring(6).split(' ').map((String text) => Text(text)).toList();
            String fechaArreglada=fecha[0].data!+"T"+fecha[1].data!.substring(0,8);

            datosHumedad.add(
              new DatoHumedad(
                int.parse(valores[0].data!.substring(5)), 
                double.parse(valores[1].data!.substring(10)), 
                DateTime.parse(fechaArreglada))
              );
          }
        }
    }
  }
}

class DatoHumedad{
  late int id;
  late double humedad;
  late DateTime fecha;

  DatoHumedad(this.id,this.humedad,this.fecha);
}
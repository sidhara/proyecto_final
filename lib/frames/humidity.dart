import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/backButton.dart';
import 'package:proyecto_final/components/colors.dart';
//import para la conexion al sql
import 'package:http/http.dart' as http;
import 'dart:convert';
//import para la grafica
import 'package:charts_flutter/flutter.dart' as charts;

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
          goBackButton(20),
          chart(15),
          text(10,15,'Humidity'),
          text(10,400,serieHumedad[serieHumedad.length-1].humidity.toString()),
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

  chart(double distanceFromTop){
    List<charts.Series<HumiditySeries, String>> series = [
      charts.Series(
        id: "Humidity",
        data: serieHumedad,
        domainFn: (HumiditySeries series, _) => series.date.toString().split(" ")[1],
        measureFn: (HumiditySeries series, _) => series.humidity,
        colorFn: (HumiditySeries series, _) => series.barColor
      )
    ];

    return Positioned(
      top: distanceFromTop,
      left: 100,
      child: SizedBox(
        width: MediaQuery.of(context).size.width-200,
        height: 300.0,
        child: charts.BarChart(series,animate: true)
      )
    ); 
  }

  text(double distanceFromBottom, double distanceFromRight, String text){
    return Positioned(
      bottom: distanceFromBottom,
      width: 200,
      right: distanceFromRight,
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

  late List<DatoHumedad> datosHumedad;
  late List<HumiditySeries> serieHumedad;

  Future getData()async{
    datosHumedad=<DatoHumedad>[];
    serieHumedad=<HumiditySeries>[];

    Uri url=Uri.parse('http://44.198.26.182/get.php');
    http.Response response=await http.get(url);
    if(response.body.isNotEmpty) {
      if (response.statusCode == 200)
      {
        List data=json.decode(response.body);//{humidity: 91, id: 28, d1: 2021-10-14 19:54:44}
        List<Text> valores;
        for(dynamic dato in data){
          valores=dato.toString().split(', ').map((String text) => Text(text)).toList();

          //DateTime fix
          List<Text> fecha=valores[2].data!.substring(4).split(' ').map((String text) => Text(text)).toList();
          String fechaArreglada=fecha[0].data!+"T"+fecha[1].data!.substring(0,8);
          if(datosHumedad.length<5){
            datosHumedad.add(
              DatoHumedad(
                int.parse(valores[1].data!.substring(4)), 
                double.parse(valores[0].data!.substring(11)), 
                DateTime.parse(fechaArreglada)
              )
            );
            serieHumedad.add(
              HumiditySeries(
                date: DateTime.parse(fechaArreglada), 
                humidity: double.parse(valores[0].data!.substring(10)), 
                barColor: charts.ColorUtil.fromDartColor(Colors.green)
              )
            );
          }
        }
        //sort();
      }
    }
  }

  /*sort(){
    int len=serieHumedad.length;
    for(int i=0;i<len-1;i++){
      int j_min=i;
      for(int j=i+1;j<len;j++){
        if(serieHumedad[j].date.isBefore(serieHumedad[j_min].date)){
          j_min=j;
        }
      }
      if(j_min!=i){
        swap(i,j_min);
      }
    }
  }

  swap(int i,int j){
    HumiditySeries temp=serieHumedad[i];
    serieHumedad[i]=serieHumedad[j];
    serieHumedad[j]=temp;
  }*/
}

class DatoHumedad{
  late int id;
  late double humedad;
  late DateTime fecha;

  DatoHumedad(this.id,this.humedad,this.fecha);
}

class HumiditySeries {
  final DateTime date;
  final double humidity;
  final charts.Color barColor;

  HumiditySeries(
    {
      required this.date,
      required this.humidity,
      required this.barColor
    }
  );
}
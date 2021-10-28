import 'package:flutter/material.dart';
//import para controlar la orientacion del frame
import 'package:flutter/services.dart';
//import para los componentes importados de la biblioteca componentes
import 'package:proyecto_final/components/smallCircularButton.dart';
import 'package:proyecto_final/components/colors.dart';
//import para la conexion al sql
import 'package:http/http.dart' as http;
import 'dart:convert';
//import para la grafica
import 'package:charts_flutter/flutter.dart' as charts;

class Humidity extends StatefulWidget {
  const Humidity({Key? key}) : super(key: key);

  @override
  _HumidityState createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {

  String url='http://3.220.8.74/getHumidity.php';//url del servicio que continene los datos de la humedad para consumir | https://naturemonitorsoftware.000webhostapp.com/getHumidity.php | http://3.220.8.74/getHumidity.php

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([//se controla la orientacion del frame para bloquearla horizontalmente
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
    ]);
    getData(url);//se obtienen los datos inicialmente y se cargan las estructuras de datos y charts
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([//se controla la orientacion del frame para bloquearla verticalmente al salir del frame actual
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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
      ),
    );
  }

  layout(){
    return Stack(
      children: [
        mainBackground(),
        goBackButton(20),
        updateButton(30),
        analyticsButton(30),
        chart(15),
        text(10,15,'Humidity'),
        text(10,400,latestHumidity),
      ],
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
      child: SmallCircularButtonCustom(
        backgroundColor: Colors.white, 
        onTap: () => onPressed(0),
        type: 'go_back',
      )
    );
  }  

  updateButton(double distanceFromTop){
    return Positioned(
      top: distanceFromTop,
      child: SmallCircularButtonCustom(
        backgroundColor: AppColor.green, 
        onTap: () => onPressed(1),
        type: 'update',
        iconColor: AppColor.fonts,
      )
    );
  }  

  analyticsButton(double distanceFromTop){
    return Positioned(
      top: distanceFromTop,
      child: SmallCircularButtonCustom(
        backgroundColor: AppColor.green, 
        onTap: () => onPressed(2),
        type: 'humidity_analysis',
        iconColor: AppColor.fonts,
      )
    );
  }  

  onPressed(int option){
    if(option==0){
      Navigator.pop(context);//se navega al frame anterior
    }if(option==1){
      getData(url);//se actualiza el frame y la informacion
    }if(option==2){
      analyse();//se analiza el estado de la humedad y se toman acciones acorde a los resultados
    }
  }
  
  analyse(){
    double humidityAverage=0,
      humidityLastFiveSamplesAverage=0;
    int i=0;
      
      for(HumidityData data in humidityData){
        humidityAverage+=data.humidity;    
        i++;
      }
    humidityAverage=humidityAverage/i;
    
    i=0;
      for(HumiditySerie series in humiditySeries){
        humidityLastFiveSamplesAverage+=series.humidity;
        i++;
      }
    humidityLastFiveSamplesAverage=humidityLastFiveSamplesAverage/i;
    
    List<int>x=<int>[humidityData.length];
    //condiciones de peligro para la humedad

    
    //code para downlink de riego
  }

  chart(double distanceFromTop){
    List<charts.Series<HumiditySerie, String>> series = [
      charts.Series(
        id: "Humidity",
        data: humiditySeries,
        domainFn: (HumiditySerie series, _) => series.date.toString().split(" ")[1],
        measureFn: (HumiditySerie series, _) => series.humidity,
        colorFn: (HumiditySerie series, _) => series.barColor
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

  late List<HumidityData> humidityData;
  late List<HumiditySerie> humiditySeries;
  String latestHumidity='';

  Future getData(String url)async{//funcion para recibir la informacion del servidor sobre la humedad, la formatea y la guarda en estructuras de datos necesarias para su display
    humidityData=<HumidityData>[];
    humiditySeries=<HumiditySerie>[];
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    if(response.body.isNotEmpty) {
      if (response.statusCode == 200){
        List data=json.decode(response.body);//{humidity: 91, id: 28, d1: 2021-10-14 19:54:44}
        List<Text> values;
        for(dynamic dato in data){
          values=dato.toString().split(', ').map((String text) => Text(text)).toList();

          //Arreglo del formato del Datetime
          List<Text> date=values[2].data!.substring(4).split(' ').map((String text) => Text(text)).toList();
          String fixedDate=date[0].data!+"T"+date[1].data!.substring(0,8);

            humidityData.add(
              HumidityData(
                int.parse(values[1].data!.substring(4)), 
                double.parse(values[0].data!.substring(11)), 
                DateTime.parse(fixedDate)
              )
            );
        }
        sort();//se ordena la serie de datos

        int n=6;//numero de barras/puntos a mostrar en la grafica
        for(int i=humidityData.length-n;i<humidityData.length;i++){
          print(humidityData[i].date.toString());
          humiditySeries.add(
            HumiditySerie(
              date: humidityData[i].date, 
              humidity: humidityData[i].humidity, 
              barColor: charts.ColorUtil.fromDartColor(AppColor.blue)//color de la grafica
            )
          );
        }
        latestHumidity=humiditySeries[humiditySeries.length-1].humidity.toString();
      }
    }
    setState(() {});
  }

  sort(){//algoritmo de ordenamiento por fecha a la mas cercana
    int len=humidityData.length;
    for(int i=0;i<len-1;i++){
      int jMin=i;
      for(int j=i+1;j<len;j++){
        if(humidityData[j].date.isBefore(humidityData[jMin].date)){
          jMin=j;
        }
      }
      if(jMin!=i){
        swap(i,jMin);
      }
    }
  }
  swap(int i,int j){//parte del algoritmo de ordenamiento por fecha a la mas cercana
    HumidityData temp=humidityData[i];
    humidityData[i]=humidityData[j];
    humidityData[j]=temp;
  }
}

class HumidityData{
  late int id;
  late double humidity;
  late DateTime date;

  HumidityData(this.id,this.humidity,this.date);
}

class HumiditySerie {
  final DateTime date;
  final double humidity;
  final charts.Color barColor;

  HumiditySerie(
    {
      required this.date,
      required this.humidity,
      required this.barColor
    }
  );
}
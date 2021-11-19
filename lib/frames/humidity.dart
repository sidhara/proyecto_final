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
//import para el analisis
import 'dart:math';
//import para la persistencia de datos de configuracion en el sistema
import 'package:proyecto_final/settings/settings.dart';

class Humidity extends StatefulWidget {
  const Humidity({Key? key}) : super(key: key);

  @override
  _HumidityState createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {

  String url='naturemonitorsoftware.000webhostapp.com',path='/getHumidity.php';//url del servicio que continene los datos de la humedad para consumir | https://naturemonitorsoftware.000webhostapp.com/getHumidity.php | http://3.220.8.74/getHumidity.php

  bool darkmode=false;

  @override
  void initState(){
    super.initState();

    SystemChrome.setPreferredOrientations([//se controla la orientacion del frame para bloquearla horizontalmente
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
    ]);

    getData(url,path);//se obtienen los datos inicialmente y se cargan las estructuras de datos y charts
    
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
  void dispose() {
    // ignore: todo
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
    if(darkmode){
      return Positioned(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/FondoHorizontalDark1.png"
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
                "assets/images/FondoHorizontal.png"
              )
            )
          ),
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

  updateButton(double distanceFromTop){
    if(darkmode){
      return Positioned(
        top: distanceFromTop,
        child: SmallCircularButtonCustom(
          backgroundColor: Colors.white, 
          onTap: () => onPressed(1),
          type: 'update',
          iconColor: AppColor.darkModeGrey,
        )
      );
    }else{
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
  }  

  analyticsButton(double distanceFromTop){
    if(darkmode){
      return Positioned(
        top: distanceFromTop,
        child: SmallCircularButtonCustom(
          backgroundColor: Colors.white, 
          onTap: () => onPressed(2),
          type: 'humidity_analysis',
          iconColor: AppColor.darkModeGrey,
        )
      );
    }else{
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
  }  

  onPressed(int option){
    if(option==0){
      Navigator.pop(context);//se navega al frame anterior
    }if(option==1){
      getData(url,path);//se actualiza el frame y la informacion
    }if(option==2){
      analyse();//se analiza el estado de la humedad y se toman acciones acorde a los resultados
    }
  }
  
  double m=0,b=0;
  double f(int x){return b+m*x;}

  analyse(){//funcion de analisis de los datos
    //regresion lineal
    int n=humidityData.length;
    
    List<int>x=<int>[];
    List<double>y=<double>[];

    double sumX=0,
      sumY=0,
      sumPowX=0,
      sumXY=0;

    for(HumidityData data in humidityData){
      x.add(data.id);
      y.add(data.humidity);

      sumX+=data.id;
      sumY+=data.humidity;
      sumPowX+=pow(data.id,2);
      sumXY+=(data.id*data.humidity);
    }

    m=(sumXY/n-(sumX/n)*(sumY/n))/(sumPowX/n-pow(sumX/n,2));//pendiente b1
    b=sumY/n-m*(sumX/n);//intercepto b0

    //'errores' de la ultima medicion
    double yEstimated=f(humidityData[n-1].id),
      yReal=humidityData[n-1].humidity,
      
      absoluteError=(yReal-yEstimated).abs(),
      relativeError=(absoluteError/yReal)*100;

    //'error' cuadratico
    double cuadraticError=0;
    
    for(int i=0; i<x.length;i++){
      cuadraticError+=pow(y[i]-f(x[i]),2);//Mean Squared Error (MSE) funcion de costo
    }

    cuadraticError=cuadraticError/n;
    
    //determinacion de la pendiente de la humedad
    String humiditySlope;
    if(m>1) humiditySlope='moistening';
    if(m<0) {
      humiditySlope='drying up';
    } else {
      humiditySlope='steady';
    }

    //muestra en pantalla la info sobre el analisis de los datos y toma la decision
    createAlertDialog(context, sumY/n, relativeError, cuadraticError, yReal, humiditySlope);
  }

  createAlertDialog(BuildContext context, double yAverage, double relativeError, double cuadraticError, double latestHumidity, String humiditySlope){//display del analisis y toma de decision de riego
    return showDialog(
      context: context,
      builder: (context){
        if(humiditySlope=='steady' || humiditySlope=='moistening'){
          return AlertDialog(
            title: const Text('Analytics based on linear regression models'),
            content: Text('Average historical humidity of the crop.............'+yAverage.toStringAsPrecision(3)+'\n'+
                          'Latest humidity sample.......................................'+latestHumidity.toStringAsPrecision(3)+'\n'+
                          'Relative error of last sample...............................'+relativeError.toStringAsPrecision(3)+'%'+'\n'+
                          'Cuadratic error of the model...............................'+cuadraticError.toStringAsPrecision(3)+'\n'+
                          'Humidity state of the crop...................................'+humiditySlope+'\n'+
                          'Moistening recomendation..................................not needed'
            ),
          );
        }else{
          return AlertDialog(
            title: const Text('Analytics based on linear regression models'),
            content: Text('Average historical humidity of the crop.............'+yAverage.toStringAsPrecision(3)+'\n'+
                          'Latest humidity sample.......................................'+latestHumidity.toStringAsPrecision(3)+'\n'+
                          'Relative error of last sample...............................'+relativeError.toStringAsPrecision(3)+'%'+'\n'+
                          'Cuadratic error of the model...............................'+cuadraticError.toStringAsPrecision(3)+'\n'+
                          'Humidity state of the crop...................................'+humiditySlope+'\n'+
                          'Moistening recomendation..................................IRRIGATE'
            ),
            actions: [
              MaterialButton(
                child: const Text('Irrigate'),
                onPressed: (){
                  irrigate();
                }
              )
            ],
          );
        }
      }
    );
  }
  
  final snackBarIrrigation = const SnackBar(content: Text('Irrigation succesful!'));//muestra un mensaje en la pantalla del dispositivo

  irrigate(){//en desarrollo
    //codigo para el downlink de riego
    ScaffoldMessenger.of(context).showSnackBar(snackBarIrrigation);//muestra un mensaje en la pantalla del dispositivo
    Navigator.of(context).pop();
  }

  chart(double distanceFromTop){
    List<charts.Series<HumiditySeries, String>> series = [
      charts.Series(
        id: "Humidity",
        data: humiditySeries,
        domainFn: (HumiditySeries series, _) => series.date.toString().split(" ")[1],
        measureFn: (HumiditySeries series, _) => series.humidity,
        colorFn: (HumiditySeries series, _) => series.barColor!
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
    if(darkmode){
      return Positioned(
        bottom: distanceFromBottom,
        width: 200,
        right: distanceFromRight,
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
  }

  late List<HumidityData> humidityData;
  late List<HumiditySeries> humiditySeries;
  String latestHumidity='';

  final snackBarData = const SnackBar(content: Text('Not enough data! at least 5 samples are needed to work'));//muestra un mensaje en la pantalla del dispositivo

  Future getData(String url,String path)async{//funcion para recibir la informacion del servidor sobre la humedad, la formatea y la guarda en estructuras de datos necesarias para su display

    humidityData=<HumidityData>[];
    humiditySeries=<HumiditySeries>[];

    final prefereredSetting=PreferencesService();//obtencion de los datos guardados
    LoginSettings savedLoginSettings=await prefereredSetting.getLoginSettings();
    String? username=savedLoginSettings.username;
    
    final queryParameters = {
      'username': username,
    };
    Uri uri=Uri.http(url,path,queryParameters);
    http.Response response=await http.get(uri);

    if(response.body.isNotEmpty) {
      if (response.statusCode == 200){
        List data=json.decode(response.body);//{payload: 91, id: 28, d1: 2021-10-14 19:54:44, username: example}
        if(data.isNotEmpty && data.length>=5){
          List<Text> values;
          for(dynamic dato in data){
            values=dato.toString().split(', ').map((String text) => Text(text)).toList();

            //Arreglo del formato del Datetime
            List<Text> date=values[2].data!.substring(4).split(' ').map((String text) => Text(text)).toList();
            String fixedDate=date[0].data!+"T"+date[1].data!;

              humidityData.add(
                HumidityData(
                  int.parse(values[1].data!.substring(4)), 
                  double.parse(values[0].data!.substring(10)), 
                  DateTime.parse(fixedDate)
                )
              );
          }
          sort();//se ordena la serie de datos

          double avgHumidity=0;
          for(HumidityData data in humidityData){
            avgHumidity+=data.humidity;
          }
          avgHumidity=avgHumidity/humidityData.length;
          double thirtyPercent=(avgHumidity/100)*30;

          int n=5;//numero de barras/puntos a mostrar en la grafica
          for(int i=humidityData.length-n;i<humidityData.length;i++){
            if(humidityData[i].humidity<=thirtyPercent){
              humiditySeries.add(
                HumiditySeries(
                  date: humidityData[i].date, 
                  humidity: humidityData[i].humidity,
                  barColor: charts.ColorUtil.fromDartColor(AppColor.lightRed)
                )
              );
            }else{
              humiditySeries.add(
                HumiditySeries(
                  date: humidityData[i].date, 
                  humidity: humidityData[i].humidity,
                  barColor: charts.ColorUtil.fromDartColor(AppColor.blue)
                )
              );
            }
          }
          latestHumidity=humiditySeries[humiditySeries.length-1].humidity.toString();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(snackBarData);//muestra un mensaje en la pantalla del dispositivo
        }
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

class HumiditySeries {
  final DateTime date;
  final double humidity;
  final charts.Color? barColor;

  HumiditySeries(
    {
      required this.date,
      required this.humidity,
      this.barColor
    }
  );
}
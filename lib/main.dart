import 'package:flutter/material.dart';
//import para la navegacion entre frames
import 'package:proyecto_final/frames/presentation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Presentation()
    );
  }
}

/*
nuevo codigo
*/

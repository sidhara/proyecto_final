import 'package:flutter/material.dart';
import 'package:proyecto_final/frames/presentation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Presentation()
    );
  }
}
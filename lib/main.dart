
import 'package:converter/pages/converter_page.dart';
import 'package:converter/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Converter App',
      home: ConverterPage(),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}

import 'package:absensi/views/SplashScreen.dart';
import 'package:absensi/views/home/HomeScreen.dart';
import 'package:absensi/views/login/LoginEmil.dart';
import 'package:absensi/views/login/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi',
      routes: {
        '/': (context) => Splashscreen(),
        '/nik': (context) => LoginScreen(),
        '/email': (context) => LoginEmail(),
        '/beranda': (context) => HomeScreen(),
      },
    );
  }
}

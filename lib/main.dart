import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
import 'package:pmsn20232/routes.dart';
import 'package:pmsn20232/screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.flagTheme,
      builder: (context,value,_) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const LoginScreen(),
          routes: getRoutes(),
          theme: value? StyleApp.darkTheme(context) : StyleApp.lightTheme(context)
        );
      }
    );
  }
}
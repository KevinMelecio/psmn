import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
import 'package:pmsn20232/routes.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool rememberMe = prefs.getBool('rememberMe') ?? false;
  runApp(MyApp(rememberMe: rememberMe));
}

// void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  final bool rememberMe;
  const MyApp({super.key, required this.rememberMe});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    GlobalValues().readTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: widget.rememberMe 
              ? DashboardScreen()
              : LoginScreen(),
              routes: getRoutes(),
              theme: value
                  ? StyleApp.darkTheme(context)
                  : StyleApp.lightTheme(context));
        });
  }
}

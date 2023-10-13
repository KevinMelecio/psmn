import 'package:flutter/material.dart';
import 'package:pmsn20232/screens/add_profesor.dart';
import 'package:pmsn20232/screens/add_tarea.dart';
import 'package:pmsn20232/screens/add_task.dart';
import 'package:pmsn20232/screens/carrera_screen.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/popular_screen.dart';
import 'package:pmsn20232/screens/profesor_screen.dart';
import 'package:pmsn20232/screens/tareas_screen.dart';
import 'package:pmsn20232/screens/task_screen.dart';

Map<String,WidgetBuilder> getRoutes(){
  return {
    '/dash': (BuildContext context) => DashboardScreen(),
    '/task': (BuildContext context) => TaskScreen(),
    '/add' : (BuildContext context) => AddTask(),
    '/addTarea' : (BuildContext context) => AddTarea(),
    '/addProfe' : (BuildContext context) => AddProfesor(),
    '/popular' : (BuildContext context) => PopularScreen(),
    '/tareas' : (BuildContext context) => TareasScreen(),
    '/carrera' : (BuildContext context) => CarreraScreen(),
    '/profesor' : (BuildContext context) => ProfesorScreen(),
  };
}
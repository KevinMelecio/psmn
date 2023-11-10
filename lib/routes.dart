import 'package:flutter/material.dart';
import 'package:pmsn20232/screens/add_carrera.dart';
import 'package:pmsn20232/screens/add_profesor.dart';
import 'package:pmsn20232/screens/add_tarea.dart';
import 'package:pmsn20232/screens/add_task.dart';
import 'package:pmsn20232/screens/carrera_screen.dart';
import 'package:pmsn20232/screens/clima_screen.dart';
import 'package:pmsn20232/screens/dashboard_screen.dart';
import 'package:pmsn20232/screens/detailmovie_screen.dart';
import 'package:pmsn20232/screens/favoritemovie_screen.dart';
import 'package:pmsn20232/screens/popular_screen.dart';
import 'package:pmsn20232/screens/profesor_screen.dart';
import 'package:pmsn20232/screens/register_screen.dart';
import 'package:pmsn20232/screens/tareas_screen.dart';
import 'package:pmsn20232/screens/task_screen.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/dash': (BuildContext context) => DashboardScreen(),
    '/task': (BuildContext context) => TaskScreen(),
    '/add': (BuildContext context) => AddTask(),
    '/addCarrera': (BuildContext context) => AddCarrera(),
    '/addProfe': (BuildContext context) => AddProfesor(),
    '/addTarea': (BuildContext context) => AddTarea(),
    '/popular': (BuildContext context) => PopularScreen(),
    '/favorites': (BuildContext context) => FavoriteMovieScreen(),
    '/tareas': (BuildContext context) => TareasScreen(),
    '/carrera': (BuildContext context) => CarreraScreen(),
    '/profesor': (BuildContext context) => ProfesorScreen(),
    '/detail': (BuildContext context) => DetailMovieScreen(),
    '/register': (BuildContext context) => RegisterScreen(),
    '/clima': (BuildContext context) => ClimaScreen(),
  };
}

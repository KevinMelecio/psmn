import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/tarea_model.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key});

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  TareaDB? tareaDB;

  List<TareaModel> tareas = [];
  DateTime today = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tareaDB = TareaDB();
    getTareasFromDB();
  }

  // void _oneDaySelected(DateTime day, DateTime focusedDay) {
  //   setState(() {
  //     today = day;
  //   });
  //   print("Selected Day = " + today.toString().split(" ")[0]);

  //   bool hasTarea = tareas.any((tarea) {
  //     if (tarea.fecExpiracion != null) {
  //       final fechaTarea = DateTime.parse(tarea.fecExpiracion!);
  //       return isSameDay(fechaTarea, day);
  //     }
  //     return false; // O maneja de otra manera los casos en los que la fecha es nula.
  //   });

  //   CalendarStyle calendarStyle = CalendarStyle(
  //     selectedDecoration: BoxDecoration(
  //       color: Colors.blue, // Color de fondo cuando se selecciona un día
  //     ),
  //     todayDecoration: BoxDecoration(
  //       color: Colors.red, // Color de fondo del día actual
  //     ),
  //     markersMaxCount: 1,
  //     markersAlignment: Alignment.bottomCenter,
  //     markerDecoration: BoxDecoration(
  //       color: hasTarea
  //           ? Colors.green
  //           : Colors
  //               .transparent, // Color de fondo de los días con tareas o transparente si no hay tareas
  //       shape: BoxShape.circle,
  //     ),
  //   );
  // }

  Future<void> getTareasFromDB() async {
    final tareasObtenidas = await tareaDB?.GETALLTAREAS();
    if (tareasObtenidas != null) {
      setState(() {
        tareas = tareasObtenidas;
      });
    }
  }

  bool hasTarea(DateTime day) {
    return tareas.any((tarea) {
      final fechaTarea = DateTime.parse(tarea.fecExpiracion!);
      return isSameDay(fechaTarea, day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        locale: 'en_US',
        rowHeight: 43,
        headerStyle:
            HeaderStyle(formatButtonVisible: false, titleCentered: true),
        availableGestures: AvailableGestures.all,
        selectedDayPredicate: (day) => isSameDay(day, today),
        focusedDay: today,
        firstDay: DateTime.utc(2015, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            today = selectedDay;
          });
          print("Selected Day = " + today.toString().split(" ")[0]);
        },
        calendarBuilders: CalendarBuilders(
          // markerBuilder:(context, day, events) {
          //   if(hasTarea(day)){
          //     return [
          //       Container(
          //         width: 5,
          //         height: 5,
          //         margin: EdgeInsets.all(2),
          //         decoration: BoxDecoration(
          //           color: Colors.green,
          //           shape: BoxShape.circle,
          //         ),
          //       ),
          //     ];
          //   }
          //   return [];
          // },
        ),
        // onDaySelected: _oneDaySelected,
      ),
    );
  }
}

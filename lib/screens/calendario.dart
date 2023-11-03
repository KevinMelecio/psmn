import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
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
  DateTime today = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tareaDB = TareaDB();
  }

  List<TareaModel> obtenerTareas(DateTime day, List<TareaModel> tareas) {
    return tareas
        .where((tarea) => isSameDay(DateTime.parse(tarea.fecExpiracion!), day))
        .toList();
  }

  void mostrar_fechas(DateTime day, List<TareaModel> tareas) {
    List<TareaModel> dias_tarea = obtenerTareas(day, tareas);

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            itemCount: dias_tarea.length,
            itemBuilder: (context, index) {
              return ValueListenableBuilder(
                  valueListenable: GlobalValues.flagTheme,
                  builder: (context, value, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12.0),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: value
                                  ? StyleApp.darkCard(context)
                                  : StyleApp.lightCard(context)),
                          child: Column(
                            children: [
                              Text(
                                dias_tarea[index].nomTarea!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                  'Descripcion ${tareas[index].desTarea}\nEstatus: ${tareas[index].realizada == 'C' ? 'Completado' : 'No Completado'}')
                            ],
                          )),
                    );
                  });
            },
          );
        });
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    return day;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return Scaffold(
            body: FutureBuilder<List<TareaModel>>(
              future: tareaDB!.GETALLTAREAS(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TableCalendar(
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: value ? StyleApp.darkCard(context).withBlue(250)
                        : StyleApp.lightCard(context).withOpacity(0.5)
                      )
                    ),
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    focusedDay: today,
                    firstDay: DateTime.utc(2015, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    eventLoader: (day) {
                      return obtenerTareas(day, snapshot.data!);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          today = focusedDay;
                          mostrar_fechas(selectedDay, snapshot.data!);
                        });
                      }
                    },
                    calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, day, focusedDay) =>
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: value
                                      ? StyleApp.darkCard(context)
                                      : StyleApp.lightCard(context),
                                  shape: BoxShape.circle),
                              child: Text(
                                formatDate(day),
                              ),
                            ),
                        markerBuilder: (context, day, events) {
                          if (events.isNotEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                color: value
                                    ? StyleApp.darkCard(context)
                                    : StyleApp.lightCard(context),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              width: 15.0,
                              height: 15.0,
                              child: Center(
                                child: Text(
                                  events.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Ocurrio un error'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        });
  }
}

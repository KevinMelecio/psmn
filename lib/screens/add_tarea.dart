import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/tarea_model.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddTarea extends StatefulWidget {
  AddTarea({super.key, this.tareaModel});

  TareaModel? tareaModel;

  @override
  State<AddTarea> createState() => _AddTareaState();
}

class _AddTareaState extends State<AddTarea> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TextEditingController txtConNomTarea = TextEditingController();
  TextEditingController txtConFExp = TextEditingController();
  TextEditingController txtConFRec = TextEditingController();
  TextEditingController txtConDesTarea = TextEditingController();
  List<String> dropDownValues = ['Completado', 'No Completado'];
  String dropDownValue = 'No Completado';
  String? selectedProfe;
  List<String> profesores = [];
  DateTime _dateExp = DateTime.now();
  DateTime _dateRec = DateTime.now();

  TareaDB? tareaDB;

  @override
  void initState() {
    super.initState();
    tareaDB = TareaDB();
    if (widget.tareaModel != null) {
      txtConNomTarea.text =
          widget.tareaModel != null ? widget.tareaModel!.nomTarea! : '';

      String fechaExpiracionStr = widget.tareaModel!.fecExpiracion ?? '';
      List<String> parts = fechaExpiracionStr.split('-');
      if (parts.length == 3) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);
        _dateExp = DateTime(year, month, day);
      } else {
        // Manejo de error, la cadena no tiene el formato esperado
      }

      String fechaRecordatorioStr = widget.tareaModel!.fecRecordatorio ?? '';
      List<String> part = fechaRecordatorioStr.split('-');
      if (part.length == 3) {
        int year = int.parse(part[0]);
        int month = int.parse(part[1]);
        int day = int.parse(part[2]);
        _dateRec = DateTime(year, month, day);
      } else {
        // Manejo de error, la cadena no tiene el formato esperado
      }

      txtConDesTarea.text =
          widget.tareaModel != null ? widget.tareaModel!.desTarea! : '';
      switch (widget.tareaModel!.realizada) {
        case 'C':
          dropDownValue = 'Completado';
          break;
        case 'N':
          dropDownValue = 'No Completado';
          break;
      }
      selectedProfe = widget.tareaModel!.nomProfe;

      var initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      var initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }

    tareaDB!.GETALLPROFESOR().then((value) {
      setState(() {
        profesores = value
            .where((profesor) => profesor.nomProfe != null)
            .map((profesor) => profesor.nomProfe ?? 'Nombre Desconocido')
            .toList();
      });
    });
  }

  void _showDatePicker(bool isDateExp) {
    showDatePicker(
            context: context,
            initialDate: isDateExp == true ? _dateExp : _dateRec,
            firstDate: DateTime(2015),
            lastDate: DateTime(2025))
        .then(
      (value) {
        setState(() {
          if (isDateExp) {
            _dateExp = value!;
          } else {
            _dateRec = value!;
          }
        });
      },
    );
  }

  Future<void> showNotification(
      String tarea, String descripcion, String fecExpiracion) async {
    var androidP = AndroidNotificationDetails(
      'Your_chanenel_id',
      'Tareas',
      importance: Importance.high,
      priority: Priority.high,
    );

    var plataforma = NotificationDetails(android: androidP);

    await flutterLocalNotificationsPlugin.show(
        0,
        'Tarea: ${txtConNomTarea.text}      Fecha de Vencimiento: $fecExpiracion',
        '$descripcion',
        plataforma);
  }

  Future<void> scheduleNotification(String tarea, String descripcion,
      String fechaExp, String fechaRec) async {
    var androidP = AndroidNotificationDetails(
      'Your_chanenel_id',
      'Tareas',
      importance: Importance.high,
      priority: Priority.high,
    );

    var plataforma = NotificationDetails(android: androidP);
    DateTime fechaRecordatorioDATE = DateTime.parse(fechaRec);
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Mexico_City');
    tz.TZDateTime fechaRecordatorio =
        tz.TZDateTime.from(fechaRecordatorioDATE, location);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Tarea: ${txtConNomTarea.text}      Fecha de Vencimiento: $fechaExp',
        '$descripcion',
        fechaRecordatorio,
        plataforma,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: 'Custom_Sound',
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  String formatDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final txtNomTarea = TextFormField(
      decoration: const InputDecoration(
          label: Text('Tarea'), border: OutlineInputBorder()),
      controller: txtConNomTarea,
    );

    final space = SizedBox(
      height: 12,
    );

    final objFechaExp = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
          onPressed: () => _showDatePicker(true),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Fecha de Expiracion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          color: Colors.blue,
        ),
        SizedBox(
          width: 10,
        ),
        Text(formatDate(_dateExp), style: TextStyle(fontSize: 20.0)),
      ],
    );

    final objFechaRec = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MaterialButton(
          onPressed: () => _showDatePicker(false),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Fecha de Recordatorio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          color: Colors.blue,
        ),
        SizedBox(
          width: 10,
        ),
        Text(formatDate(_dateRec), style: TextStyle(fontSize: 20.0)),
      ],
    );

    final txtDesTarea = TextField(
      decoration: const InputDecoration(
          label: Text('Descripcion'), border: OutlineInputBorder()),
      maxLines: 6,
      controller: txtConDesTarea,
    );

    final DropdownButton dropdownRealizada = DropdownButton(
      value: dropDownValue,
      items: dropDownValues
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      onChanged: (value) {
        dropDownValue = value;
        setState(() {});
      },
    );

    final dropdownProfesor = DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            labelText: 'Profesor', border: OutlineInputBorder()),
        value: selectedProfe,
        items: profesores.map((profesor) {
          return DropdownMenuItem<String>(
            value: profesor,
            child: Text(profesor),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedProfe = newValue;
          });
        });

    final ElevatedButton btnGuardar = ElevatedButton(
        onPressed: () {
          showNotification(txtConNomTarea.text, txtConDesTarea.text,
              formatDate(_dateExp));
          scheduleNotification(txtConNomTarea.text, txtConDesTarea.text,
              formatDate(_dateExp), formatDate(_dateRec));
          if (selectedProfe != null) {
            tareaDB!.GETPROFESORID(selectedProfe!).then((idProfe) {
              if (idProfe != null) {
                final nuevaTarea = {
                  'nomTarea': txtConNomTarea.text,
                  'fecExpiracion': formatDate(_dateExp),
                  'fecRecordatorio': formatDate(_dateRec),
                  'desTarea': txtConDesTarea.text,
                  'realizada': dropDownValue!.substring(0, 1),
                  'idProfe': idProfe
                };
                if (widget.tareaModel == null) {
                  tareaDB!.INSERT('Tarea', nuevaTarea).then((value) {
                    var msj = (value > 0)
                        ? 'La inserción fue exitosa!'
                        : 'Ocurrió un error';
                    var snackbar = SnackBar(content: Text(msj));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pop(context);
                  });
                  print(nuevaTarea);
                } else {
                  final tarea = {
                    'idTarea': widget.tareaModel!.idTarea,
                    'nomTarea': txtConNomTarea.text,
                    'fecExpiracion': formatDate(_dateExp),
                    'fecRecordatorio': formatDate(_dateRec),
                    'desTarea': txtConDesTarea.text,
                    'realizada': dropDownValue!.substring(0, 1),
                    'idProfe': idProfe
                  };
                  tareaDB!.UPDATE_TAREA('Tarea', tarea).then((value) {
                    GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
                    var msj = (value > 0)
                        ? 'La actualización fue exitosa!'
                        : 'Ocurrió un error';
                    var snackbar = SnackBar(content: Text(msj));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pop(context);
                  });
                  print(tarea);
                }
              } else {
                var snackbar = const SnackBar(
                    content: Text('No se pudo encontrar el ID de la carrera'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            });
          }
        },
        child: Text('Save Task'));

    return Scaffold(
      appBar: AppBar(
        title: widget.tareaModel == null
            ? Text('Agregar Tarea')
            : Text('Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            txtNomTarea,
            space,
            objFechaExp,
            space,
            objFechaRec,
            space,
            txtDesTarea,
            space,
            dropdownRealizada,
            space,
            dropdownProfesor,
            space,
            btnGuardar
          ],
        ),
      ),
    );
  }
}

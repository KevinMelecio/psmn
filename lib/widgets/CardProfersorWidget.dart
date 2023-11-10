import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/profesor_model.dart';
import 'package:pmsn20232/screens/add_profesor.dart';

class CardProfesorWidget extends StatelessWidget {
  CardProfesorWidget(
      {super.key, required this.profesorModel, required this.tareaDB});

  TareaDB? tareaDB;
  ProfesorModel profesorModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: value
                      ? StyleApp.darkCard(context)
                      : StyleApp.lightCard(context)),
              margin: EdgeInsets.only(top: 0),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        profesorModel.nomProfe!,
                        style: TextStyle(
                            fontSize: 15,
                            color: value
                                ? StyleApp.darkLetter(context)
                                : StyleApp.lightLetter(context)),
                      ),
                      Text(
                        profesorModel.email!,
                        style: TextStyle(
                            fontSize: 15,
                            color: value
                                ? StyleApp.darkLetter(context)
                                : StyleApp.lightLetter(context)),
                      ),
                      Text(
                        profesorModel.nomCarrera!,
                        style: TextStyle(
                            fontSize: 15,
                            color: value
                                ? StyleApp.darkLetter(context)
                                : StyleApp.lightLetter(context)),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProfesor(
                                      profesorModel: profesorModel))),
                          icon: Icon(Icons.edit)),
                      // GestureDetector(
                      //   onTap: () => Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               AddProfesor(profesorModel: profesorModel))),
                      //   child: Image.asset(
                      //     'assets/strawberry.png',
                      //     height: 50,
                      //   ),
                      // ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Mensaje del sistema'),
                                    content: Text('¿Deseas borrar la tarea?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            tareaDB!
                                                .DELETE_CARRERA('Profesor',
                                                    profesorModel.idProfe!)
                                                .then((value) => {
                                                      Navigator.pop(context),
                                                      GlobalValues
                                                              .flagTask.value =
                                                          !GlobalValues
                                                              .flagTask.value
                                                    });
                                          },
                                          child: Text('Si')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('No'))
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.delete))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color.fromARGB(255, 48, 127, 62)),
        margin: EdgeInsets.only(top: 0),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Column(
              children: [
                Text(profesorModel.nomProfe!),
                Text(profesorModel.email!),
                Text(profesorModel.nomCarrera!)
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddProfesor(profesorModel: profesorModel))),
                  child: Image.asset(
                    'assets/strawberry.png',
                    height: 50,
                  ),
                ),
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
                                    onPressed:
                                    () {
                                      tareaDB!
                                          .DELETE_CARRERA('Profesor', profesorModel.idProfe!)
                                          .then((value) => {
                                                Navigator.pop(context),
                                                GlobalValues.flagTask.value =
                                                    !GlobalValues.flagTask.value
                                              });
                                    },
                                    child: Text('Si')),
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
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
  }
}

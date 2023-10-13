import 'package:flutter/material.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/carrera_model.dart';

class CardCarreraWidget extends StatelessWidget {
  CardCarreraWidget(
      {super.key, required this.carreraModel, required this.tareaDB});

  TareaDB? tareaDB;
  CarreraModel carreraModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue[300]),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            children: [Text(carreraModel.idCarrera!.toString()), Text(carreraModel.nomCarrera!)],
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => {},
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => AddTask(taskModel: taskModel))),
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
                                  onPressed: () {},
                                  // () {
                                  //   tareaDB!
                                  //       .DELETE('tblTareas', taskModel.idTask!)
                                  //       .then((value) => {
                                  //             Navigator.pop(context),
                                  //             GlobalValues.flagTask.value =
                                  //                 !GlobalValues.flagTask.value
                                  //           });
                                  // },
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
    );
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/tarea_model.dart';
import 'package:pmsn20232/screens/add_tarea.dart';

class CardTareasWidget extends StatefulWidget {
  CardTareasWidget(
      {super.key, required this.tareaModel, required this.tareaDB});

  TareaDB? tareaDB;
  TareaModel tareaModel;

  @override
  State<CardTareasWidget> createState() => _CardTareasWidgetState();
}

class _CardTareasWidgetState extends State<CardTareasWidget> {
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
                Text(widget.tareaModel.nomTarea!),
                Text(widget.tareaModel.fecExpiracion!.toString()),
              ],
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Checkbox(
                        value: widget.tareaModel.realizada == 'C',
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            setState(() {
                              widget.tareaModel.realizada =
                                  newValue ? 'C' : 'N';
                              widget.tareaDB!
                                  .UPDATE_TAREA_REALIZADA(widget.tareaModel);
                            });
                          }
                        }),
                    widget.tareaModel.realizada! == 'N'
                        ? Text('No Completado')
                        : Text('Completado')
                  ],
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddTarea(tareaModel: widget.tareaModel))),
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
                                    onPressed: () {
                                      widget.tareaDB!
                                          .DELETE_TAREA('Tarea',
                                              widget.tareaModel.idTarea!)
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

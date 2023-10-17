import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
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
                        widget.tareaModel.nomTarea!,
                        style: TextStyle(
                            fontSize: 15,
                            color: value
                                ? StyleApp.darkLetter(context)
                                : StyleApp.lightLetter(context)),
                      ),
                      Text(
                        widget.tareaModel.fecExpiracion!.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            color: value
                                ? StyleApp.darkLetter(context)
                                : StyleApp.lightLetter(context)),
                      ),
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
                                    widget.tareaDB!.UPDATE_TAREA_REALIZADA(
                                        widget.tareaModel);
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
                      IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddTarea(tareaModel: widget.tareaModel))),
                          icon: Icon(Icons.edit)),
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

import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/carrera_model.dart';

class AddCarrera extends StatefulWidget {
  AddCarrera({super.key, this.carreraModel});

  CarreraModel? carreraModel;

  @override
  State<AddCarrera> createState() => _AddCarreraState();
}

class _AddCarreraState extends State<AddCarrera> {
  TextEditingController txtConCarr = TextEditingController();

  TareaDB? tareaDB;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tareaDB = TareaDB();
    if(widget.carreraModel != null){
      txtConCarr.text = (widget.carreraModel != null 
      ? widget.carreraModel!.nomCarrera : '')!;
    }
  }

  @override
  Widget build(BuildContext context) {

    final txtNameCarrera = TextFormField(
      decoration: const InputDecoration(
        label: Text('Carrera'),
        border:OutlineInputBorder()
      ),
      controller: txtConCarr,
    );

    final space = SizedBox(height: 10,);

    final ElevatedButton btnGuardar = ElevatedButton(
      onPressed: (){
        if(widget.carreraModel == null){
          tareaDB!.INSERT('Carrera', {
            'nomCarrera' : txtConCarr.text
          }).then((value) {
            var msj = (value > 0)
                  ? 'La inserción fue exitosa!'
                  : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
          });
        } else {
          tareaDB!.UPDATE_CARRERA('Carrera', {
            'idCarrera' : widget.carreraModel!.idCarrera,
            'nomCarrera' : txtConCarr.text,
          }).then((value) {
            GlobalValues.flagTask.value= !GlobalValues.flagTask.value;
              var msj = (value > 0)
                  ? 'La actualización fue exitosa!'
                  : 'Ocurrió un error';
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
          });
        }
      }, 
      child: Text('Guardar Carrera'));


    return Scaffold(
      appBar: AppBar(
        title: widget.carreraModel == null 
        ? Text('Add Carrera')
        : Text('Update Carrera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            txtNameCarrera,
            space,
            btnGuardar
          ],
        ),
        ),
    );
  }
}

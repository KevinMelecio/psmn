import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/profesor_model.dart';

class AddProfesor extends StatefulWidget {
  AddProfesor({super.key, this.profesorModel});

  ProfesorModel? profesorModel;

  @override
  State<AddProfesor> createState() => _AddProfesorState();
}

class _AddProfesorState extends State<AddProfesor> {
  TextEditingController txtConNomProfe = TextEditingController();
  TextEditingController txtConEmail = TextEditingController();
  String? selectedCarrera;
  List<String> carreras = [];

  TareaDB? tareaDB;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tareaDB = TareaDB();

    if (widget.profesorModel != null) {
      txtConNomProfe.text = widget.profesorModel!.nomProfe ?? '';
      txtConEmail.text = widget.profesorModel!.nomProfe ?? '';
      selectedCarrera = widget.profesorModel!.nomCarrera;
    }

    tareaDB!.GETALLCARRERA().then((value) {
      setState(() {
        carreras = value
            .where((carrera) => carrera.nomCarrera != null)
            .map((carrera) => carrera.nomCarrera ?? 'Nombre Desconocido')
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final txtNomProfe = TextFormField(
      decoration: const InputDecoration(
          label: Text('Nombre Profesor'), border: OutlineInputBorder()),
      controller: txtConNomProfe,
    );

    final txtEmail = TextFormField(
      decoration: const InputDecoration(
          label: Text('Email'), border: OutlineInputBorder()),
      controller: txtConEmail,
    );

    final space = SizedBox(
      height: 10,
    );

    final dropdownCarrera = DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Carrera',
          border: OutlineInputBorder(),
        ),
        value: selectedCarrera,
        items: carreras.map((carrera) {
          return DropdownMenuItem<String>(
            value: carrera,
            child: Text(carrera),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCarrera = newValue;
          });
        });

    final ElevatedButton btnGuardar = ElevatedButton(
        onPressed: () {
          if (selectedCarrera != null) {
            tareaDB!.GETCARRERAID(selectedCarrera!).then((idCarrera) {
              if (idCarrera != null) {
                final nuevoprofesor = {
                  'nomProfe': txtConNomProfe.text,
                  'email': txtConEmail.text,
                  'idCarrera': idCarrera
                };

                if (widget.profesorModel == null) {
                  tareaDB!.INSERT('Profesor', nuevoprofesor).then((value) {
                    var msj = (value > 0)
                        ? 'La inserción fue exitosa!'
                        : 'Ocurrió un error';
                    var snackbar = SnackBar(content: Text(msj));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pop(context);
                  });
                } else {
                  final profesor = {
                  'idProfe': widget.profesorModel!.idProfe,
                  'nomProfe': txtConNomProfe.text,
                  'email': txtConEmail.text,
                  'idCarrera': idCarrera
                };
                  tareaDB!.UPDATE_PROFESOR('Profesor', profesor).then((value) {
                    GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
                    var msj = (value > 0)
                        ? 'La actualización fue exitosa!'
                        : 'Ocurrió un error';
                    var snackbar = SnackBar(content: Text(msj));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pop(context);
                  });
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
        title: widget.profesorModel == null
            ? Text('Agregar Profesor')
            : Text('Editar Profesor'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              txtNomProfe,
              space,
              txtEmail,
              space,
              dropdownCarrera,
              space,
              btnGuardar,
            ],
          )),
    );
  }
}

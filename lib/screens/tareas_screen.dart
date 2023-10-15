import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/tarea_model.dart';
import 'package:pmsn20232/widgets/CardTareaWidget.dart';
import 'package:pmsn20232/widgets/CardTaskWidget.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  TareaDB? tareaDB;
  String selectedFilter = 'Todas las Tareas';
  @override
  void initState() {
    super.initState();
    tareaDB = TareaDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas'),
        actions: [
          DropdownButton<String>(
            value: selectedFilter,
            onChanged:(newValue) {
              setState(() {
                selectedFilter = newValue!;
              });
            },
            items: ['Todas las Tareas', 'Completados', 'No Completados']
            .map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
                );
            }).toList(),
          ),
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/addTarea').then((value) {
                    setState(() {});
                  }),
              icon: Icon(Icons.task))
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagTask,
        builder: (context, value, _) {
          return FutureBuilder<List<TareaModel>>(
            future: tareaDB!.GETALLTAREAS(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TareaModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    //filtro
                    final tareaModel = snapshot.data![index];
                    if(selectedFilter == 'Todas las Tareas' || 
                      (selectedFilter == 'Completados' && tareaModel.realizada == 'C') ||
                      (selectedFilter == 'No Completados' && tareaModel.realizada == 'N')){
                        return CardTareasWidget(
                        tareaModel: snapshot.data![index], tareaDB: tareaDB);
                      } else {
                        return Container();
                      };
                    
                  },
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something was wrong!!'),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }
            },
          );
        },
      ),
    );
  }
}

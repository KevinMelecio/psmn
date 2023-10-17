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
  TextEditingController _searchController = TextEditingController();
  List<TareaModel> filteredTareas = [];
  String selectedFilter = 'Todas las Tareas';
  @override
  void initState() {
    super.initState();
    tareaDB = TareaDB();
  }

  Future<List<TareaModel>> _filterTarea(String query) async {
    print("Filtrando tarea con query: $query");
    List<TareaModel> allTarea = await tareaDB!.GETALLTAREAS();

    List<TareaModel> filteredTareas = allTarea
        .where((tareas) =>
            tareas.nomTarea!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    filteredTareas.forEach((tarea) {
      print("ID: ${tarea.idTarea}, Nombre: ${tarea.nomTarea}");
    });
    return filteredTareas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas'),
        actions: [
          DropdownButton<String>(
            value: selectedFilter,
            onChanged: (newValue) {
              setState(() {
                selectedFilter = newValue!;
              });
            },
            items: ['Todas las Tareas', 'Completados', 'No Completados']
                .map<DropdownMenuItem<String>>((String value) {
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextField(
              controller: _searchController,
              onChanged: (query) async {
                List<TareaModel> filtered = await _filterTarea(query);
                setState(() {
                  filteredTareas = filtered;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Buscar Tarea',
                  suffix: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        filteredTareas = [];
                      });
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: GlobalValues.flagTask,
              builder: (context, value, _) {
                return FutureBuilder<List<TareaModel>>(
                  future: tareaDB!.GETALLTAREAS(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TareaModel>> snapshot) {
                    if (snapshot.hasData) {
                      final tareas = filteredTareas.isEmpty
                          ? snapshot.data!
                          : filteredTareas;
                      return ListView.builder(
                        itemCount: tareas.length,
                        itemBuilder: (context, index) {
                          //filtro
                          final tareaModel = tareas[index];
                          if (selectedFilter == 'Todas las Tareas' ||
                              (selectedFilter == 'Completados' &&
                                  tareaModel.realizada == 'C') ||
                              (selectedFilter == 'No Completados' &&
                                  tareaModel.realizada == 'N')) {
                            return CardTareasWidget(
                                tareaModel: tareas[index], tareaDB: tareaDB);
                          } else {
                            return Container();
                          }
                          // if(selectedFilter == 'Todas las Tareas' ||
                          //   (selectedFilter == 'Completados' && tareaModel.realizada == 'C') ||
                          //   (selectedFilter == 'No Completados' && tareaModel.realizada == 'N')){
                          //     return CardTareasWidget(
                          //     tareaModel: snapshot.data![index], tareaDB: tareaDB);
                          //   } else {
                          //     return Container();
                          //   };
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
          ),
        ],
      ),
    );
  }
}

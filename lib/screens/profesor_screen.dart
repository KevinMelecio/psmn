import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/models/profesor_model.dart';
import 'package:pmsn20232/widgets/CardProfersorWidget.dart';

class ProfesorScreen extends StatefulWidget {
  const ProfesorScreen({super.key});

  @override
  State<ProfesorScreen> createState() => _ProfesorScreenState();
}

class _ProfesorScreenState extends State<ProfesorScreen> {
  TareaDB? tareaDB;
  TextEditingController _searchController = TextEditingController();
  List<ProfesorModel> filteredProfes = [];

  @override
  void initState() {
    super.initState();
    tareaDB = TareaDB();
  }

  Future<List<ProfesorModel>> _filterProfe(String query) async {
    print("Filtrando profe con query: $query");
    List<ProfesorModel> allProfes = await tareaDB!.GETALLPROFESOR();

    List<ProfesorModel> filteredProfes = allProfes
        .where((profes) =>
            profes.nomProfe!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    filteredProfes.forEach((profe) {
      print("ID: ${profe.idCarrera}, Nombre: ${profe.nomCarrera}");
    });
    return filteredProfes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profesor'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/addProfe').then((value) {
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
                List<ProfesorModel> filtered = await _filterProfe(query);
                setState(() {
                  filteredProfes = filtered;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Buscar Profe',
                  suffix: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        filteredProfes = [];
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
                  return FutureBuilder<List<ProfesorModel>>(
                    future: tareaDB!.GETALLPROFESOR(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ProfesorModel>> snapshot) {
                      if (snapshot.hasData) {
                        final profes = filteredProfes.isEmpty
                            ? snapshot.data!
                            : filteredProfes;
                        return ListView.builder(
                          itemCount: profes.length,
                          itemBuilder: (context, index) {
                            return CardProfesorWidget(
                                profesorModel: profes[index], tareaDB: tareaDB);
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
                }),
          ),
        ],
      ),
    );
  }
}

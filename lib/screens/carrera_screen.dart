import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/tareadb.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/widgets/CardCarreraWidget.dart';

class CarreraScreen extends StatefulWidget {
  const CarreraScreen({super.key});

  @override
  State<CarreraScreen> createState() => _CarreraScreenState();
}

class _CarreraScreenState extends State<CarreraScreen> {
  TareaDB? tareaDB;
  TextEditingController _searchController = TextEditingController();
  List<CarreraModel> filteredCarreras = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tareaDB = TareaDB();
  }

  Future<List<CarreraModel>> _filterCarreras(String query) async {
    print("Filtrando carreras con query: $query");
    List<CarreraModel> allCarreras = await tareaDB!.GETALLCARRERA();

    List<CarreraModel> filteredCarreras = allCarreras
        .where((carrera) =>
            carrera.nomCarrera!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    filteredCarreras.forEach((carrera) {
      print("ID: ${carrera.idCarrera}, Nombre: ${carrera.nomCarrera}");
    });
    return filteredCarreras;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrera'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/addCarrera').then((value) {
                    setState(() {});
                  }),
              icon: Icon(Icons.task))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: TextField(
                controller: _searchController,
                onChanged: (query) async {
                  List<CarreraModel> filtered = await _filterCarreras(query);
                  setState(() {
                    filteredCarreras = filtered;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Buscar Carreras',
                    suffix: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          filteredCarreras = [];
                        });
                      },
                      icon: Icon(Icons.clear),
                    )),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: GlobalValues.flagTask,
                builder: (context, value, _) {
                  return FutureBuilder(
                      future: tareaDB!.GETALLCARRERA(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CarreraModel>> snapshot) {
                        if (snapshot.hasData) {
                          //Filtro
                          final carreras = filteredCarreras.isEmpty
                              ? snapshot.data!
                              : filteredCarreras;
                          return ListView.builder(
                              itemCount: carreras.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CardCarreraWidget(
                                    carreraModel: carreras[index],
                                    tareaDB: tareaDB);
                              });
                        } else {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Something was wrong!!'),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }
                      });
                }),
          )
        ],
      ),
    );
  }
}

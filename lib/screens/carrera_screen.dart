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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tareaDB = TareaDB();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrera'),
        actions: [
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
            return FutureBuilder(
                future: tareaDB!.GETALLCARRERA(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CarreraModel>> snapshot) {
                      if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardCarreraWidget(
                        carreraModel: snapshot.data![index], 
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
              }
            );
          }),
    );
  }
}
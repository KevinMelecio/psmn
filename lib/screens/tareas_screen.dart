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
          IconButton(
              onPressed: () => {},
              // Navigator.pushNamed(context, '/add').then((value) {
              //   setState(() {});
              // }),
              icon: Icon(Icons.task))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: GlobalValues.flagTask,
          builder: (context, value, _) {
            return FutureBuilder(
                future: tareaDB!.GETALLTAREAS(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<TareaModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardTareasWidget(
                            tareaModel: snapshot.data![index],
                            tareaDB: tareaDB);
                      },
                    );
                  } else {
                    if(snapshot.hasError){
                      return const Center(
                        child: Text('Error!'),
                        );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }
                });
          }),
    );
  }
}

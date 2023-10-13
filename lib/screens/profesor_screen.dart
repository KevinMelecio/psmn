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
  @override
  void initState() {
    super.initState();
    tareaDB = TareaDB();
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
      body: ValueListenableBuilder(
          valueListenable: GlobalValues.flagTask,
          builder: (context, value, _) {
            return FutureBuilder<List<ProfesorModel>>(
              future: tareaDB!.GETALLPROFESOR(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ProfesorModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return CardProfesorWidget(
                          profesorModel: snapshot.data![index],
                          tareaDB: tareaDB);
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
    );
  }
}

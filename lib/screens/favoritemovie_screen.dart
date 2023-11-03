import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/popular_model.dart';
import 'package:pmsn20232/network/api_popular.dart';
import 'package:pmsn20232/screens/detailmovie_screen.dart';
import 'package:pmsn20232/widgets/ItemMovieWidget.dart';

class FavoriteMovieScreen extends StatefulWidget {
  const FavoriteMovieScreen({super.key});

  @override
  State<FavoriteMovieScreen> createState() => _FavoriteMovieScreenState();
}

class _FavoriteMovieScreenState extends State<FavoriteMovieScreen> {
  ApiPopular? apiPopular;
  List<int> movieIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiPopular = ApiPopular();
    MoviesIdsDB();
  }

  Future<void> MoviesIdsDB() async {
    final db = AgendaDB();
    final favoritesMovies = await db.GETALLFAVORITES();
    setState(() {
      movieIds = favoritesMovies
          .where((favMovie) => favMovie.pelicula != null)
          .map((favMovie) => favMovie.pelicula!)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Movies'),
      ),
      body: ValueListenableBuilder(
        valueListenable: GlobalValues.flagTask,
        builder: (context, value, _) {
          return FutureBuilder(
            future: apiPopular!.getMoviesFavorites(movieIds),
            builder: (BuildContext context,
                AsyncSnapshot<List<PopularModel>?> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // print(snapshot.data![index]!.backdropPath);
                    return itemMovieWidget(snapshot.data![index], context);
                  },
                );
              } else {
                if (snapshot.hasError) {
                  return Center(child: Text('Algo salió mal :()'));
                } else {
                  return CircularProgressIndicator();
                }
              }
            },
          );
        }
      ),
    );
  }
}

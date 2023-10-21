import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/favmovie_model.dart';
import 'package:pmsn20232/models/popular_model.dart';
import 'package:pmsn20232/network/api_popular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  PopularModel? movie;
  ApiPopular? apiPopular;
  AgendaDB? agendaDB;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    agendaDB = AgendaDB();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final db = await agendaDB!.database;
    final result = await db!
        .query('Favoritos', where: 'pelicula = ?', whereArgs: [movie!.id]);
    setState(() {
      _isFavorite = result.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)?.settings.arguments as PopularModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(movie!.title ?? 'Movie Detail'),
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 5 / 9,
                child: Image.network(
                  'http://image.tmdb.org/t/p/w500${movie!.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              //     Container(
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: NetworkImage(
              //             'http://image.tmdb.org/t/p/w500${movie!.posterPath}'),,
              //         fit: BoxFit.cover),
              //   ),
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              //     child: Container(
              //       color: Colors.black.withOpacity(0.4),
              //     ),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie!.title ?? 'Movie Title',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          children: [
                            RatingBar.builder(
                              initialRating: movie!.voteAverage ?? 0.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemSize: 20,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {},
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Column(
                          children: [
                            ButtonTheme(
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(150.0, 60),
                                        primary: Colors.amber,
                                        elevation: 0.0),
                                    icon: Icon(
                                      _isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                    label: const Text('I like it',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      if (_isFavorite) {
                                        final deletedRows = await agendaDB!
                                            .DELETE_FAV(movie!.id!)
                                            .then((value) {
                                          var msj = (value > 0)
                                              ? 'Se elimino de favoritos!!'
                                              : 'Ocurrió un error';
                                          var snackbar =
                                              SnackBar(content: Text(msj));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                          setState(() {
                                            _isFavorite = false;
                                          });
                                        });

                                        if (deletedRows > 0) {
                                          setState(() {
                                            _isFavorite = false;
                                          });
                                        }
                                      } else {
                                        final favMovie =
                                            FavMoviesModel(pelicula: movie!.id);
                                        final inserteId = await agendaDB!
                                            .INSERT(
                                                'Favoritos', favMovie.toMap())
                                            .then((value) {
                                          var msj = (value > 0)
                                              ? 'Se añadio a favoritos!!'
                                              : 'Ocurrió un error';
                                          var snackbar =
                                              SnackBar(content: Text(msj));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                          setState(() {
                                            _isFavorite = true;
                                          });
                                        });
                                        if (inserteId != null) {
                                          setState(() {
                                            _isFavorite = true;
                                          });
                                        }
                                      }
                                    })),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    FutureBuilder<String?>(
                      future: apiPopular!.getVideo(movie!.id!.toString()),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || snapshot.data == '') {
                          return const Text(
                            'error al cargar',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          );
                        } else {
                          return YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: snapshot.data!,
                              flags: const YoutubePlayerFlags(
                                autoPlay: false,
                                mute: false,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      movie!.overview ?? 'Sin Descripcion',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('Actors',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 8),
                    FutureBuilder(
                        future: apiPopular!.castMovie(movie!.id!),
                        builder:
                            (context, AsyncSnapshot<List<dynamic>?> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == null) {
                              return Container(
                                height: 200,
                                child: const Center(
                                  child: Text('No hay datos'),
                                ),
                              );
                            } else {
                              return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 150,
                                    width: 350,
                                    child: PageView.builder(
                                        itemCount: 10,
                                        controller: PageController(
                                            viewportFraction:
                                                0.6), // Añade esta línea
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Colors.amber,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${snapshot.data![index]['name']}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Cursive'),
                                                ),
                                                Text(
                                                  '${snapshot.data![index]['character']}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  width:
                                                      100.0, // Ajusta este valor según tus necesidades
                                                  height:
                                                      100.0, // Ajusta este valor según tus necesidades
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image.network(
                                                      'https://image.tmdb.org/t/p/w500/${snapshot.data![index]['profile_path']}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ));
                            }
                          } else {
                            return Container(
                              height: 200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

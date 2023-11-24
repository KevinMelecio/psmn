import 'package:flutter/material.dart';
import 'package:pmsn20232/models/favmovie_model.dart';
import 'package:pmsn20232/models/popular_model.dart';
import 'package:pmsn20232/screens/detailmovie_screen.dart';

Widget itemMovieWidget(PopularModel movie, BuildContext context) {
  return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie),
      child: FadeInImage(
        fit: BoxFit.fill,
        fadeInDuration: const Duration(milliseconds: 500),
        placeholder: const AssetImage('assets/giphy.gif'),
        image:
            NetworkImage('https://image.tmdb.org/t/p/w500${movie.posterPath}'),
      ));
}





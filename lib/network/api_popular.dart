import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmsn20232/models/popular_model.dart';

class ApiPopular {
  Uri link = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=759124af8786e8a0ada6893e90db607c&language=es-MX&page=1');

  Future<List<PopularModel>?> getAllPopular() async {
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['results'] as List;
      return jsonResult
          .map((popular) => PopularModel.fromMap(popular))
          .toList();
    }
    return null;
  }

  Future<List<PopularModel>?> getMoviesFavorites(List<int> movieIds) async {
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['results'] as List;
      var popularMovies =
          jsonResult.map((popular) => PopularModel.fromMap(popular)).toList();
      var filteredMovies =
          popularMovies.where((movie) => movieIds.contains(movie.id)).toList();
      return filteredMovies;
    }
    return null;
  }

  Future<String> getVideo(String id) async {
    Uri video = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=759124af8786e8a0ada6893e90db607c');
    var response = await http.get(video);
    var jsonResult = jsonDecode(response.body)['results'] as List;
    if (response.statusCode == 200) {
      return jsonResult[0]['key'];
    } else {
      return '';
    }
  }

  Future<List<dynamic>?> castMovie(int id) async {
    Uri cast = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=759124af8786e8a0ada6893e90db607c');
    var response = await http.get(cast);
    var jsonResult = jsonDecode(response.body)['cast'] as List;
    if (response.statusCode == 200) {
      return jsonResult;
    }
    return null;
  }
}

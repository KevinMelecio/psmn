class FavMoviesModel {
  int? idFav;
  int? pelicula;

  FavMoviesModel({this.idFav, this.pelicula});

  Map<String, dynamic> toMap() {
    return {
      'idFav': idFav,
      'pelicula': pelicula,
    };
  }

  factory FavMoviesModel.fromMap(Map<String, dynamic> map) {
    return FavMoviesModel(idFav: map['idFav'], pelicula: map['pelicula']);
  }
}

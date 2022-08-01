import 'dart:convert';

//fue tomado de NowPlayinhResponse, aca se encuntran todas las carcatesristcas de una plicula 
class Movie {
  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  String? heroId;

//obtener la imagen para las pleiculas en cartelera en cine
//Las imagenes de las peliculas populares, clasificadas
//y si no existe se pone otra imagen
  get fullPosterImg {
    if (this.posterPath != null)
      return 'https://image.tmdb.org/t/p/w500${this.posterPath}';

    return 'https://i.stack.imgur.com/GNhxO.png';
  }

   

//obtener la imagne para la descripcion de la peli
  get fullbckdropPath {
    if (this.backdropPath != null)
      return 'https://image.tmdb.org/t/p/w500${this.backdropPath}';

    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  factory Movie.fromJson(String str) => Movie.fromMap(json.decode(str));

//Todos los datos que podemos obtener sobre las pleiculas
//Aca toma cada una de sus propiedades de la pelicla y las asigna a cada una de las propiedades de la clase
  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        adult           : json["adult"],
        backdropPath    : json["backdrop_path"],
        genreIds        : List<int>.from(json["genre_ids"].map((x) => x)),
        id              : json["id"],
        originalLanguage: json["original_language"],
        originalTitle   : json["original_title"],
        overview        : json["overview"],
        popularity      : json["popularity"].toDouble(),
        posterPath      : json["poster_path"],
        releaseDate     : json["release_date"],
        title           : json["title"],
        video           : json["video"],
        voteAverage     : json["vote_average"].toDouble(),
        voteCount       : json["vote_count"],
      );
}

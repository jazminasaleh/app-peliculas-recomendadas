import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/rated_response.dart';
import 'package:peliculas/models/search_movies_response.dart';

//esta clase se hace para obtener la infromacion de las peliculas, las peliculas populares, actores pelculcas clasificadas ....
//la pagina donde se vana consumir https://www.themoviedb.org/
//ChangeNotifier es una clase simple incluida en el SDK de flutter que proporciona notificaciones de cambio a sus oyentes
class MoviesProvider extends ChangeNotifier {
  //clave
  String _apiKey = 'caf74066cb62c8e8a8b564fceb62459a';
  //el ptincipio del link hasta llegr a org
  String _baseUrl = 'api.themoviedb.org';
  //el idimoa español es
  String _language = 'es-Es';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> ratedMovies = [];

//el int sera el id de la pelicula es el key llave
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;
  int _ratedPage = 0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));
  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;
  //constructor
  MoviesProvider() {
    print('MoviesProvider inicializado');
    getOnDisplayMovies();
    getPopularMovies();
    getRatedMovies();
  }

  Future<String> _getJsonData(String endPoint, [int page = 1]) async {
    //Peticion https Uri.https
    //dominio,
    //segmento el cual es la segunda parte del link, hasta antes de la clave
    //parametros del query llave, lenguaje y la pagina
    final url = Uri.https(_baseUrl, endPoint,
        {'api_key': _apiKey, 
        'language': _language, 
        'page': '$page'
        });
    //url de donde vamos a consumir las peliculas
    final response = await http.get(url);

    //este widget sirve para re dibujarlos a todos los que han cambaido la informacion
    notifyListeners();
    return response.body;
  }

//Las peliculas que se muestras en el card grande en el home
  Future getOnDisplayMovies() async {
    final jsonDat = await this._getJsonData('3/movie/now_playing');
    //se obtienen los datos de la pelicula
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonDat);
    //para imprimir el error
    //if (response.statusCode != 200) return print('error');
    //pasar un json a un map
    //print(nowPlayingResponse.results[0].originalTitle);
    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }
//obtener las peliculas populares
  getPopularMovies() async {
    _popularPage++;
    final jsonDat = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonDat);
    //se se cambia de numero de pagina se mantengan las peliculas
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

//obtener las peliculas clasificadas
  getRatedMovies() async {
    _ratedPage++;
    final jsonDat = await _getJsonData('3/movie/top_rated', _ratedPage);
    final ratedResponse = RatedResponse.fromJson(jsonDat);
    //se se cambia de numero de pagina se mantengan las peliculas
    ratedMovies = [...ratedMovies, ...ratedResponse.results];
    notifyListeners();
  }

//async convierte cuqluier retorno en futture
//para imprimir los actores
  Future<List<Cast>> getMovieCast(int movieId) async {
    //solo hacer la petiicon una vez ya de resto esta en memeoria
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    final jsonDat = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonDat);
    moviesCast[movieId] = creditsResponse.cast;
    print(creditsResponse.cast);
    return creditsResponse.cast;
  }

//mostrar las pleiculas con la lupa de home
  Future<List<Movie>> sarchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

//cada vez que la persona espicha una tecla se manda a llamar
  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.sarchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => timer.cancel());
  }
}

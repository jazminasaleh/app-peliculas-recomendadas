import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    //listen es para redibujarse
    //Lo que se esta diciendo es que vaya al arobol de widgets traiga la instancia de 
    //MoviesProviders y almacenrala en moviesProviders
    final moviesProvider = Provider.of<MoviesProvider>(context);

    print(moviesProvider.onDisplayMovies);
    return Scaffold(
      appBar: AppBar(
        title:const Text('Películas recomendadas'),
        //la sombra que tare en la parte de arriba
        elevation: 5,
        actions: [
          //el icono de lupa de busqueda
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon: Icon(Icons.search_outlined
            ))
        ],
      ),
      //permite hacer scroll
      body: SingleChildScrollView(
        child: Column(
          children: [
            //tarejtas principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            //Slider de peliculas populares
            //se traen las peliculas populares
            MoviesSlider(
              movies: moviesProvider.popularMovies, 
              title: 'Populares',
              onNextPage: () =>{
                moviesProvider.getPopularMovies()
              },),
            //slider de peliculas clasificadas
            MoviesSlider(
              movies: moviesProvider.ratedMovies, 
              title: 'Clasificados',
              onNextPage: () =>{
                moviesProvider.getRatedMovies()
              },),
          ],
        ),
      ),
    );
  }
}

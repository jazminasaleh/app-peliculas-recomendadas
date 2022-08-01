import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:peliculas/models/models.dart';

import '../widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //instancia de la pelicula
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    print(movie.title);

    return Scaffold(
      //nos sirev para hacer scroll
      body: CustomScrollView(
        //tiene cierto compoartmennto re programado cuando se hace sroll en el contenido
        //lo que esta dentro del slivers debe ser widget y slivers
        slivers: [
          //crea el appbar
          _CustomAppBar(movie),
          SliverList(
              //para colcar widget normales que no sean sliverlist
              delegate: SliverChildListDelegate([
            _PosterAndTitle(movie),
             SizedBox(
                height: 5,
              ),
            _Overview(movie),
            _Adult(movie),
             SizedBox(height: 25,),
            CastingCards(movie.id)
          ]))
        ],
      ),
    );
  }
}

//Toda la parte del appBar
class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar(this.movie);
  @override
  Widget build(BuildContext context) {
    //con este se puede controlar el ancho largo ... del appbar
    return SliverAppBar(
      backgroundColor: Colors.orange,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      //permite cambiar la altuar del appbar
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        //le quita al titulo el padding
        titlePadding: EdgeInsets.all(0),
        title: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          width: double.infinity,
          child: Text(
            movie.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
            placeholder: AssetImage('assets/loading.gif'),
            image: NetworkImage(movie.fullbckdropPath),
            //Es para qeu se pueda expander la imagne sin perder sus dimensiones
            fit: BoxFit.cover),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextTheme textThem = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Hero(
          tag: movie.heroId!,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullbckdropPath),
                //height: 150,
                width: 120,
              )
              ),
        ),
        SizedBox(
          width: 20,
        ),
        //para que no salgan las lines amarillas y negras cuando haya mucho texto
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 180),
          child: Column(
            //para que queden alineados al principio
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Text(
                movie.title,
                style: textThem.subtitle1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),*/
              SizedBox(
                height: 5,
              ),
              //para el subtitulo
              Text(
                movie.originalTitle,
                style: textThem.subtitle1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star_outline,
                    size: 15,
                    color: Colors.grey,
                  ),
                   SizedBox(width: 3,),
                  Text('${movie.voteAverage}'),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 15,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                 
                  if (movie.originalLanguage != 'ja' &&
                      movie.originalLanguage != 'es' &&
                      movie.originalLanguage != 'en')
                    Text('${movie.originalLanguage}'),
                   if (movie.originalLanguage == 'en') Text('Ingles'),
                  if (movie.originalLanguage == 'ja') Text('Japones'),
                  if (movie.originalLanguage == 'es') Text('Español'),
                ],
              ),
               SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                   SizedBox(width: 5,),
                  Text('${movie.popularity}'),
                ],
              ),
               SizedBox(
                height: 7,
              ),
              Row(
                children: [
                  Icon(
                    Icons.date_range_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5,),
                  Text('${movie.releaseDate}'),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}

//el texto acerca de la pelicula
class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

class _Adult extends StatelessWidget {
  final Movie movie;

  const _Adult(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          if (movie.adult == true)
            Text(
              'Esta pelicula es para mayores de 18 años.' ,
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          if (movie.adult == false)
            Text(
              'Esta pelicula es apta para niños.',
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.subtitle1,
            ),
        ],
      ),
    );
  }
}

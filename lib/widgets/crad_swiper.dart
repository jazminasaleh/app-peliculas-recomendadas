import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
//Muestra las peliculas en el home las que estan en cartelera 
class CardSwiper extends StatelessWidget {
  //Tarer las carcateristicas de las peliculas, de la cle Movie
  final List<Movie> movies;

  const CardSwiper({super.key, required this.movies});

//en context sabe todo acerca del arbol de widgets que hay antes
  @override
  Widget build(BuildContext context) {
     //saber el tamaño de alto y ancho del dispostivo
    final size = MediaQuery.of(context).size;
    return Container(
     //tomar todo el ancho posible de acuerdo al padre
      width: double.infinity,
      height: size.height /2,
      //para mover las imagenes de manera horizontal
      child: Swiper(
        //cantidad de tarjetas
        itemCount: movies.length,
        // la froma en la que se vana a mover las imagenes
        layout: SwiperLayout.STACK,
        //el tamaño de las tarjetas
        itemWidth: size.width * 0.7,
        itemHeight: size.height * 0.45,
        itemBuilder: (_, int index) {
          final movie = movies[index];
          movie.heroId = 'swiper-${movie.id}';
          //este se coloca para saber que hacer cuando se hace el ontap
          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                    placeholder: AssetImage('assets/loading.gif'),
                    image: NetworkImage(movie.fullPosterImg),
                    //adpatar la imagen al tamño que tiene el contendor padre
                    fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}

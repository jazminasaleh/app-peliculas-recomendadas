import 'package:flutter/material.dart';

import '../models/models.dart';

//esta clase es para las peliculas populatres y clasificadas que haparecen en la parte de abajo del home
class MoviesSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MoviesSlider(
      {super.key, required this.movies, this.title, required this.onNextPage});

  @override
  State<MoviesSlider> createState() => _MoviesSliderState();
}

class _MoviesSliderState extends State<MoviesSlider> {
  //para determinar en que parte del croll estamos
  final ScrollController scrollController = new ScrollController();
  //primero ejecua el initState y luego si el retso de codigo
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //cuando el widget va a hacer destruido
  //primero se ejecuta el codigo y luego si el dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      child: Column(
        //el titulo quede al principuo
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           //si no hay titulo no debe paarcer este widget
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.widget.title!,
                style: TextStyle(
                  fontSize: 20,
                  //negrita
                  fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          //toma todo el tamapo que queda disposible
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              //el scroll haciando donde se quiere vertical o horizontañ
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) {
                final movie = widget.movies[index];
                return _MoviePoster(
                    widget.movies[index], '${widget.title}-${index}-${widget.movies[index].id}');
              },
            ),
          ),
        ],
      ),
    );
  }
}

//_antes del nombre quiere decir privado
class _MoviePoster extends StatelessWidget {
  final Movie movi;
  final String heroId;
  const _MoviePoster(this.movi, this.heroId);

  @override
  Widget build(BuildContext context) {
    movi.heroId = heroId;
    return Container(
        width: 130,
        height: 190,
        //hace separacion entre los cards
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movi),
              child: Hero(
                tag: movi.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:Image(
                    image: NetworkImage(movi.fullPosterImg),
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Text(movi.originalTitle,
                maxLines: 2,
                //si hay mas texto deja los tres puntos al finalizar ...
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/screens.dart';
import 'package:provider/provider.dart';
void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //un peoveedor que fusiona varios proveedores en un unico arbol de widgets lineal
    return MultiProvider(
      providers: [
        //cuando el notificador de cambios obtiene valores actualizados, puede llamar a un método llamado 'notifyListeners()', 
        //y luego cualquiera de sus oyentes responderá con una acción. La escucha de un notificador de cambios se realiza registrando 
        //una devolución de llamada, que se llama cuando notifyListenersse invoca.
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          //tan pornto se crea el widget lo amnda llamar ejemplo getOnDisplayMovies
          //que se encientra dentro de la clase moviesProvider
          lazy: false,
        )

      ],
      child: MyApp(),
      );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      //la ruta inicial
      initialRoute: 'home',
      //las rutas
      routes: {
        'home': ( _ ) => HomeScreen(),
        'details': ( _ )  => DetailsScreen(),
      },
      //a todos los appbar se les cambia el color
      //copyWith es una copia del tema 
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.orangeAccent
        )
      ),
    );
  }
}
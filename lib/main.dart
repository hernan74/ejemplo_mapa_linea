import 'package:ejemplo_mapa_linea/bloc/mapa/mapa_bloc.dart';
import 'package:ejemplo_mapa_linea/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:ejemplo_mapa_linea/pages/acceso_gps_page.dart';
import 'package:ejemplo_mapa_linea/pages/loading_page.dart';
import 'package:ejemplo_mapa_linea/pages/mapa_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MiUbicacionBloc()),
        BlocProvider(create: (_) => MapaBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: ' Titulo',
        initialRoute: '/',
        routes: {
          '/': (_) => LoadingPage(),
          'home': (_) => MapaPage(),
          'acceso_gps': (_) => AccesoGpsPage(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polyline/polyline.dart' as Poly;

import 'package:ejemplo_mapa_linea/services/traffic_service.dart';
import 'package:ejemplo_mapa_linea/bloc/mapa/mapa_bloc.dart';
import 'package:ejemplo_mapa_linea/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:ejemplo_mapa_linea/models/reverse_query_response.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            buildWhen: (previous, current) => current.existeUbicacion,
            builder: (_, state) => _crearMapa(state),
          ),
        ],
      ),
    );
  }

  Widget _crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion)
      return Center(
        child: Text('Ubicando...'),
      );
    final posisionInicial =
        new CameraPosition(target: state.ubicacion, zoom: 15);

    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    _crearRuta();
    return BlocBuilder<MapaBloc, MapaState>(
      builder: (_, state) {
        return GoogleMap(
          initialCameraPosition: posisionInicial,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: mapaBloc.initMapa,
          polylines: mapaBloc.state.polylines.values.toSet(),
          markers: mapaBloc.state.markers.values.toSet(),
        );
      },
    );
  }

  void _crearRuta() async {
    final mapaBloc = context.read<MapaBloc>();
    final TrafficService trafficService = new TrafficService();
    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = LatLng(-27.352388, -55.902860);

    //Obtener informacion del destino
    ReverseQueryResponse reverseQueryResponse =
        await trafficService.getCoordenadasInfo(destino);

    final drivingResponse =
        await trafficService.getCoordsInicioYFin(inicio, destino);
    //LatLong codificados
    final geometry = drivingResponse.routes[0].geometry;
    final duration = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;
    final nombreDestino = reverseQueryResponse.features[0].placeNameEs;
    //Decodificar los puntos del geometry
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    print('========================');
    print('LatLong Codificados : $geometry');
    print('========================');
    final List<LatLng> rutaCoors = points.map((point) {
      print('Punto para el mapa: ${LatLng(point[0], point[1])}');
      return LatLng(point[0], point[1]);
    }).toList();
    print('Nro de LatLong: ${rutaCoors.length}');
    print('========================');

    mapaBloc.add(
        OnCrearRutaInicioDestino(rutaCoors, distance, duration, nombreDestino));
  }
}

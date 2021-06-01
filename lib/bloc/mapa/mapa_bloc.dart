import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ejemplo_mapa_linea/theme/uber_map_theme.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

//Controlador del mapa
  GoogleMapController _mapController;

  Polyline _rutaDestino = new Polyline(
      polylineId: PolylineId('ruta_destino'),
      width: 4,
      color: Colors.blueAccent);

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapaListoEvent());
    }
  }

  void moverCamara(LatLng destino) {
    final camaraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(camaraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapaListoEvent) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnCrearRutaInicioDestino) {
      yield* _onCrearRutaInicioDestino(event);
    }
  }

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event) async* {
    this._rutaDestino =
        this._rutaDestino.copyWith(pointsParam: event.rutaCoordenadas);

    final currentPolylines = state.polylines;
    currentPolylines['ruta_destino'] = this._rutaDestino;

    final Marker markerInicio = new Marker(
        markerId: MarkerId('inicio'),
        anchor: Offset(0.05, 0.8),
        position: event.rutaCoordenadas[0]);
    final Marker markerFin = new Marker(
        markerId: MarkerId('fin'),
        anchor: Offset(0.05, 0.78),
        position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1]);
    print('Ubicacion inicio : ${event.rutaCoordenadas[0]}');
    print(
        'Ubicacion fin : ${event.rutaCoordenadas[event.rutaCoordenadas.length - 1]}');
    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['fin'] = markerFin;

    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }
}

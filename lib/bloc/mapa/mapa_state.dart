part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final LatLng ubicacionCentral;
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
  MapaState({
    this.mapaListo = false,
    this.ubicacionCentral,
    Map<String, Polyline> polylines,
    Map<String, Marker> markers,
  })  : this.polylines = polylines ?? new Map(),
        this.markers = markers ?? new Map();

  MapaState copyWith(
          {bool mapaListo,
          LatLng ubicacionCentral,
          Map<String, Polyline> polylines,
          Map<String, Marker> markers}) =>
      MapaState(
        mapaListo: mapaListo ?? this.mapaListo,
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );
}

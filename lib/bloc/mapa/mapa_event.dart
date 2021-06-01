part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListoEvent extends MapaEvent {}

class OnCrearRutaInicioDestino extends MapaEvent {
  final List<LatLng> rutaCoordenadas;
  final double distancia;
  final double duracion;
  final String nombreDestino;

  OnCrearRutaInicioDestino(
      this.rutaCoordenadas, this.distancia, this.duracion, this.nombreDestino);
}

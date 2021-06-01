part of 'mi_ubicacion_bloc.dart';

@immutable
abstract class MiUbicacionEvent {}

class OnUbicacionCambioEvent extends MiUbicacionEvent {
  final LatLng ubicacion;

  OnUbicacionCambioEvent(this.ubicacion);
}

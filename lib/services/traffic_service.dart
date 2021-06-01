import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ejemplo_mapa_linea/helpers/debouncer.dart';
import 'package:ejemplo_mapa_linea/models/driving_response.dart';
import 'package:ejemplo_mapa_linea/models/reverse_query_response.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrafficService {
  static final TrafficService _instancia = new TrafficService.internal();

  factory TrafficService() {
    return _instancia;
  }

  TrafficService.internal();

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 500));

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey =
      'pk.eyJ1IjoiaGVybmFuNzQiLCJhIjoiY2tvazFiOTB0MHptcjJ2cTR4MjFtZ3RvOCJ9.xZxMnzUfpzPdivXKzBfIrQ';
  Future<DrivingResponse> getCoordsInicioYFin(
      LatLng inicio, LatLng destino) async {
    final coordsString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this._baseUrlDir}/mapbox/driving/$coordsString';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'language': 'es',
      'access_token': this._apiKey
    });
    final data = DrivingResponse.fromJson(resp.data);
    return data;
  }

  Future<ReverseQueryResponse> getCoordenadasInfo(LatLng destino) async {
    final url =
        '${this._baseUrlGeo}/mapbox.places/${destino.longitude},${destino.latitude}.json';

    final resp = await this._dio.get(url,
        queryParameters: {'language': 'es', 'access_token': this._apiKey});
    final data = reverseQueryResponseFromJson(resp.data);
    return data;
  }
}

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ejemplo_mapa_linea/helpers/helpers.dart';
import 'package:ejemplo_mapa_linea/pages/acceso_gps_page.dart';
import 'package:ejemplo_mapa_linea/pages/mapa_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navegarMapaFadeIn(context, LoadingPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: checkGpsLocation(context),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.data),
              );
            } else {
              return CircularProgressIndicator(
                strokeWidth: 2,
              );
            }
          },
        ),
      ),
    );
  }

  Future checkGpsLocation(BuildContext context) async {
    //PermisoGPS
    final persimoGPS = await Permission.location.isGranted;
    //GPS esta activo
    final gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (persimoGPS && gpsActivo) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, MapaPage()));
      return '';
    } else if (!persimoGPS) {
      Navigator.pushReplacement(
          context, navegarMapaFadeIn(context, AccesoGpsPage()));
      return 'Es necesario el permiso de GPS';
    } else if (!gpsActivo) {
      return 'Active el GPS';
    }
  }
}

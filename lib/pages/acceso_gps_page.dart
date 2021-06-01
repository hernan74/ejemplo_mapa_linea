import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:ejemplo_mapa_linea/helpers/helpers.dart';
import 'package:ejemplo_mapa_linea/pages/loading_page.dart';
import 'package:ejemplo_mapa_linea/pages/mapa_page.dart';

class AccesoGpsPage extends StatefulWidget {
  @override
  _AccesoGpsPageState createState() => _AccesoGpsPageState();
}

class _AccesoGpsPageState extends State<AccesoGpsPage>
    with WidgetsBindingObserver {
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
      if (await Permission.location.isGranted) {
        Navigator.pushReplacement(
            context, navegarMapaFadeIn(context, LoadingPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Es necesario el GPS para usar esta app'),
            MaterialButton(
                child: Text(
                  'Solicitar Acceso',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                shape: StadiumBorder(),
                onPressed: () async {
                  final status = await Permission.location.request();

                  accesoGPS(status);
                })
          ],
        ),
      ),
    );
  }

  void accesoGPS(
    PermissionStatus status,
  ) {
    switch (status) {
      case PermissionStatus.granted:
        Navigator.pushReplacement(
            context, navegarMapaFadeIn(context, MapaPage()));
        break;
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
      case PermissionStatus.denied:
        openAppSettings();
        break;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
    }
  }
}

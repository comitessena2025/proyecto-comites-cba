import 'package:comites/Dashboard/dashboard/funciones/estadisticas.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainEstadisticas extends StatefulWidget {
  const MainEstadisticas({super.key, required List solicitudes});

  @override
  State<MainEstadisticas> createState() => _MainEstadisticasState();
}

class _MainEstadisticasState extends State<MainEstadisticas> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Estadisticas',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const SideMenu(),
      body: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: EstadisticasPage(solicitudes: [],), // Aquí integras la página de estadísticas
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:comites/Dashboard/dashboard/funciones/citarejecutor.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainCitacionEjecutor extends StatefulWidget {
  const MainCitacionEjecutor({super.key});

  @override
  State<MainCitacionEjecutor> createState() => _MainCitacionEjecutorState();
}

class _MainCitacionEjecutorState extends State<MainCitacionEjecutor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Citar a Comité Ejecutor', // Título del AppBar
        scaffoldKey: _scaffoldKey, // Pasa la key para abrir el menú
      ),
      drawer: const SideMenu(), // Drawer para el menú lateral
      body: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eliminamos la lógica para mostrar el SideMenu directamente
            Expanded(
              flex: 5,
              child: CitacionEjecutor(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

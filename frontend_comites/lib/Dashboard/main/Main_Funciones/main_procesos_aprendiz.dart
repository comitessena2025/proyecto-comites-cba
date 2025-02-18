import 'package:comites/Dashboard/dashboard/funciones/procesos_aprendiz.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainProcesosAprendiz extends StatefulWidget {
  const MainProcesosAprendiz({super.key});

  @override
  State<MainProcesosAprendiz> createState() => _MainProcesosAprendizState();
}

class _MainProcesosAprendizState extends State<MainProcesosAprendiz> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Tus Procesos', // Título del AppBar
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
              child: ProcesosAprendiz(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

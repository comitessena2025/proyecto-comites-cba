import 'package:comites/Dashboard/dashboard/funciones/procesos_realizados.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainProcesosRealizados extends StatefulWidget {
  const MainProcesosRealizados({super.key});

  @override
  State<MainProcesosRealizados> createState() => _MainProcesosRealizadosState();
}

class _MainProcesosRealizadosState extends State<MainProcesosRealizados> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Procesos Realizados', // Título del AppBar
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
              child: ProcesosRealizados(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

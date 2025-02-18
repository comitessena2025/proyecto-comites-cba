import 'package:comites/Dashboard/dashboard/funciones/llamadoatencion2.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainLllamadoatencion2 extends StatefulWidget {
  const MainLllamadoatencion2({super.key});

  @override
  State<MainLllamadoatencion2> createState() => _MainLllamadoatencion2State();
}

class _MainLllamadoatencion2State extends State<MainLllamadoatencion2> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Realizar Segundo Llamado atencion', // Título del AppBar
        scaffoldKey: _scaffoldKey, // Pasa la key para abrir el menú
      ),
      drawer:
          const SideMenu(), // Drawer para el menú lateral (no se muestra por defecto)
      body: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // El menú lateral solo se muestra cuando se usa el botón hamburguesa
            // En dispositivos móviles no se mostrará automáticamente
            Expanded(
              flex: 5,
              child: LlamadoatencionForm2(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

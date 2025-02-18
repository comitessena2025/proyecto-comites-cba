import 'package:comites/Dashboard/dashboard/funciones/llamadoatencion.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainLllamadoatencion extends StatefulWidget {
  const MainLllamadoatencion({super.key});

  @override
  State<MainLllamadoatencion> createState() => _MainLllamadoatencionState();
}

class _MainLllamadoatencionState extends State<MainLllamadoatencion> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Realizar Llamado atencion', // Título del AppBar
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
              child: LlamadoatencionForm(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

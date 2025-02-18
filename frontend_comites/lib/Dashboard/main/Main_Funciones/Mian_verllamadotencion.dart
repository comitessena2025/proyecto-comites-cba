import 'package:comites/Dashboard/dashboard/funciones/ver_llamadoatencion.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainVerLLamadosatencion extends StatefulWidget {
  const MainVerLLamadosatencion({super.key});

  @override
  State<MainVerLLamadosatencion> createState() =>
      _MainVerLLamadosatencionState();
}

class _MainVerLLamadosatencionState extends State<MainVerLLamadosatencion> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title:
            'ver llamados de atencion y generar el segundo ', // Título del AppBar
        scaffoldKey: _scaffoldKey, // Pasa la key para abrir el menú
      ),
      drawer: const SideMenu(), // Drawer para el menú lateral
      body: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eliminamos la verificación para mostrar el SideMenu directamente
            Expanded(
              flex: 5,
              child: LlamadoAtencionPage(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

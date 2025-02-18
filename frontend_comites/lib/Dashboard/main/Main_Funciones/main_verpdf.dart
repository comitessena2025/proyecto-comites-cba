import 'package:comites/Dashboard/dashboard/funciones/verpdfs.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainRadicacionesPDF extends StatefulWidget {
  const MainRadicacionesPDF({super.key});

  @override
  State<MainRadicacionesPDF> createState() => _MainRadicacionesPDFState();
}

class _MainRadicacionesPDFState extends State<MainRadicacionesPDF> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'ver Radicaciones', // Título del AppBar
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
              child: ListaDePDFs(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

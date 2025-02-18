import 'package:comites/Dashboard/dashboard/funciones/citacionform.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainCitaciones extends StatefulWidget {
  const MainCitaciones({super.key});

  @override
  State<MainCitaciones> createState() => _MainCitacionesState();
}

class _MainCitacionesState extends State<MainCitaciones> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Citar Comités', // Título del AppBar
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
              child: CitacionesForm(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

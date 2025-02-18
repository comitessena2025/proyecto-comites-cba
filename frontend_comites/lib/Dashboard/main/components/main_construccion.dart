import 'package:comites/Dashboard/dashboard/dashboard_construccion.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainConstruccion extends StatefulWidget {
  const MainConstruccion({super.key});

  @override
  State<MainConstruccion> createState() => _MainConstruccionState();
}

class _MainConstruccionState extends State<MainConstruccion> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'En Construcción', // Título del AppBar
        scaffoldKey: _scaffoldKey, // Pasa la key para abrir el menú desde el ícono
      ),
      drawer: const SideMenu(), // Drawer para acceder al menú lateral
      body: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eliminamos el SideMenu del cuerpo para mostrarlo solo a través del drawer
            Expanded(
              flex: 5,
              child: DashboardConstruccion(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

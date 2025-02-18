import 'package:comites/Dashboard/dashboard/funciones/solicitu_comite_directo.dart';
import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainComitenormal_Directo extends StatefulWidget {
  const MainComitenormal_Directo({super.key});

  @override
  State<MainComitenormal_Directo> createState() =>
      _MainComitenormal_DirectoState();
}

class _MainComitenormal_DirectoState extends State<MainComitenormal_Directo> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key para controlar el menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Realizar Solicitudes Directas ', // Título del AppBar
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
              child: ComiteDirectoForm(), // Contenido principal
            ),
          ],
        ),
      ),
    );
  }
}

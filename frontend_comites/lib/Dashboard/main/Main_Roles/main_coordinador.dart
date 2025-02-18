import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainCoordinador extends StatefulWidget {
  const MainCoordinador({super.key});

  @override
  State<MainCoordinador> createState() => _MainCoordinadorState();
}

class _MainCoordinadorState extends State<MainCoordinador> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Panel Coordinador',
        scaffoldKey: _scaffoldKey, // Pasa la key al AppBar
      ),
      drawer: const SideMenu(), // Asocia el SideMenu al botón hamburguesa
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '¡Bienvenido, Coordinador!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'En este sistema puedes realizar las siguientes acciones:',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  '- Realizar solicitudes\n'
                  '- Subir planes de mejoramiento\n'
                  '- Calificar planes de mejoramiento\n'
                  '- Ver estadísticas de tus procesos',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
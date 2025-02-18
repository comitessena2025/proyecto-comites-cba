import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:flutter/material.dart';

class MainRadicacion extends StatefulWidget {
  const MainRadicacion({super.key});

  @override
  State<MainRadicacion> createState() => _MainRadicacionState();
}

class _MainRadicacionState extends State<MainRadicacion> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Panel Radicacion',
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
                  '¡Bienvenido, Usuario!',
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
                  '- Realizar Radicaciones\n',
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

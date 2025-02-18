import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/provider.dart';
import 'package:flutter/material.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:provider/provider.dart';

class MainAprendiz extends StatefulWidget {
  const MainAprendiz({super.key});

  @override
  State<MainAprendiz> createState() => _MainAprendizState();
}

class _MainAprendizState extends State<MainAprendiz> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

     final appState = Provider.of<AppState>(context);

    if (appState.isLoading) {
      return const Center(child: CircularProgressIndicator());  // Mostrar indicador de carga
    }

    final nombreUsuario = appState.usuarioAutenticado?.nombres ?? 'Invitado';
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Panel Aprendiz',
        scaffoldKey: _scaffoldKey, // Pasa la key al AppBar
      ),
      drawer: const SideMenu(), // Menú lateral
      body:  SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '¡Bienvenido, Aprendiz $nombreUsuario!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'En este sistema puedes realizar las siguientes acciones:',
                        style: TextStyle(fontSize: 20, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '- Ver los procesos en los que estás involucrado\n'
                        '- Subir planes de mejoramiento\n',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

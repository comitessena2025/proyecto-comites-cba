import 'package:comites/Dashboard/main/components/appbar.dart';
import 'package:comites/Dashboard/main/components/side_menu.dart';
import 'package:comites/constantsDesign.dart';
import 'package:comites/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainBienvenida extends StatefulWidget {
  const MainBienvenida({super.key});
  

  @override
  State<MainBienvenida> createState() => _MainBienvenidaState();
}

class _MainBienvenidaState extends State<MainBienvenida> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key para el Scaffold

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
        title: 'Bienvenido, $nombreUsuario',
        scaffoldKey: _scaffoldKey,  // Pasa la key para el menú lateral
      ),
      drawer: const SideMenu(), // Definimos el SideMenu como drawer, pero no lo mostramos directamente
      body: SafeArea(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 5,
        child: BienvenidaContent(scaffoldKey: _scaffoldKey), // Pasa la key aquí
      ),
    ],
  ),
),

    );
  }
}

class BienvenidaContent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BienvenidaContent({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido a ComitApp el Sistema de Comités Académicos!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Este aplicativo está diseñado para gestionar los comités académicos realizados en el CBA de Mosquera. Aquí podrás realizar varios procesos dependiendo de tu rol dentro del centro de formación.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer(); // Abre el SideMenu
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Color del botón
              ),
              child: const Text(
                'Explorar el Sistema',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

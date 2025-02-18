//Codigo reutilizado de los compañeros Diego Jaimes y William Garzon

// ignore_for_file: must_be_immutable
// Ignora la advertencia sobre clases que deben ser inmutables

import 'package:provider/provider.dart'; // Paquete para manejar el estado de la aplicación
import 'package:comites/Splash/page/SplashScreen.dart'; // Pantalla de carga inicial de la aplicación
import 'constantsDesign.dart'; // Archivo con constantes de diseño
import 'package:flutter/material.dart'; // Paquete principal de Flutter
import 'provider.dart'; // Archivo que proporciona el proveedor de estado de la aplicación
import 'package:supabase_flutter/supabase_flutter.dart';

// Punto de entrada principal de la aplicación
void main() async {
  await Supabase.initialize(
    url: 'https://uwrugmhbvoujzbsudrta.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3cnVnbWhidm91anpic3VkcnRhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI3NTk3NDMsImV4cCI6MjA0ODMzNTc0M30.VfVFQepjX82SlqFZ6XWRXI58dsxBiieevAT8qF2fChc',
  );
  // Ejecuta la aplicación directamente con `MyApp`
  runApp(const MyApp());
}

// Clase principal de la aplicación que extiende StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState =
        AppState(); // Crea una instancia de AppState, que maneja el estado de la aplicación

    // Proporciona `AppState` como ChangeNotifierProvider a los widgets hijos
    return ChangeNotifierProvider<AppState>(
      create: (context) => appState,
      child: MaterialApp(
        theme: lightTheme, // Establece el tema de la aplicación
        debugShowCheckedModeBanner: false, // Oculta el banner de modo debug
        home: const SplashScreen(), // Establece la pantalla de inicio
      ),
    );
  }
}

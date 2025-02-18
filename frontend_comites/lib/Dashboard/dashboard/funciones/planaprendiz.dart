// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:comites/Models/SolicitudModel.dart';
import 'package:comites/Widgets/animacionSobresaliente.dart';
import 'package:comites/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart'; // Importa el paquete para seleccionar archivos
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa Supabase
import 'package:provider/provider.dart' as provider;

class PlanMejoramientoAprendiz extends StatefulWidget {
  const PlanMejoramientoAprendiz({super.key});

  @override
  _PlanMejoramientoAprendizState createState() =>
      _PlanMejoramientoAprendizState();
}

class _PlanMejoramientoAprendizState extends State<PlanMejoramientoAprendiz> {
  late Future<List<SolicitudModel>> futureSolicitudes;

  @override
  void initState() {
    super.initState();
    _loadSolicitudes(); // Cargar las solicitudes filtradas por el ID del instructor
  }

  // Función para cargar las solicitudes del instructor autenticado
  Future<void> _loadSolicitudes() async {
    final userId =
        provider.Provider.of<AppState>(context, listen: false).userId;
    if (userId != null) {
      setState(() {
        futureSolicitudes = getSolicitudesByUser(userId);
      });
    } else {
      setState(() {
        futureSolicitudes = Future.error('Usuario no autenticado');
      });
    }
  }

  // Función para obtener las solicitudes según el ID del usuario
  Future<List<SolicitudModel>> getSolicitudesByUser(int userId) async {
    List<SolicitudModel> todasLasSolicitudes = await getSolicitud();
    return todasLasSolicitudes
        .where((solicitud) =>
            solicitud.planmejoramiento == true &&
            solicitud.responsable.contains(userId))
        .toList();
  }

  // Función para subir el plan de mejoramiento
  Future<void> _subirPlanMejoramiento(SolicitudModel solicitud) async {
    // Usamos file_picker para seleccionar el archivo
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Si el usuario seleccionó un archivo, subimos el archivo a Supabase
      PlatformFile file = result.files.first;

      final supabase = Supabase.instance.client;
      final fileName = file.name
          .replaceAll(RegExp(r'\s+'), '_')
          .replaceAll(RegExp(r'[^a-zA-Z0-9_\.]'), '');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = 'plan_mejoramiento/${solicitud.id}/$timestamp$fileName';

      try {
        // Subir el archivo a Supabase Storage
        final uploadResponse = await supabase.storage
            .from('uploads')
            .uploadBinary(filePath, file.bytes!);

        if (uploadResponse.error == null) {
          // Obtener la URL pública del archivo
          final publicUrlResponse =
              supabase.storage.from('uploads').getPublicUrl(filePath);

          if (publicUrlResponse.error == null) {
            final publicUrl = publicUrlResponse.data;
            print('Archivo subido correctamente. URL pública: $publicUrl');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Archivo subido correctamente.')),
            );
            // Aquí puedes asociar la URL con la solicitud o realizar alguna acción adicional.
          } else {
            print(
                'Error al obtener URL pública: ${publicUrlResponse.error!.message}');
          }
        } else {
          print('Error al subir el archivo: ${uploadResponse.error!.message}');
        }
      } catch (e) {
        print('Error inesperado al subir el archivo: $e');
      }
    } else {
      // El usuario canceló la selección del archivo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se seleccionó ningún archivo.')),
      );
    }
  }

  // Función para construir la cuadrícula de los cards
  Widget _buildGrid(List<SolicitudModel> solicitudes) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        spacing: 20.0, // Espacio entre las columnas
        runSpacing: 20.0, // Espacio entre las filas
        alignment: WrapAlignment.center, // Alineación de los elementos
        children: solicitudes.map((solicitud) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: AnimacionSobresaliente(
              scaleFactor: 1.07,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Solicitud: ${DateFormat('yyyy-MM-dd').format(solicitud.fechallamadoatencion)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Descripción: ${solicitud.descripcion}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _subirPlanMejoramiento(solicitud),
                            child: const Text("Subir Plan de Mejoramiento"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SolicitudModel>>(
        future: futureSolicitudes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay solicitudes con plan de mejoramiento para este instructor.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final solicitudesFiltradas = snapshot.data!;
            return _buildGrid(
                solicitudesFiltradas); // Llamar a la función de la cuadrícula
          }
        },
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:comites/Models/SolicitudModel.dart';
import 'package:comites/Widgets/animacionSobresaliente.dart';
import 'package:comites/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

class SubirPlanAprendiz extends StatefulWidget {
  const SubirPlanAprendiz({super.key});

  @override
  _SubirPlanAprendizState createState() => _SubirPlanAprendizState();
}

class _SubirPlanAprendizState extends State<SubirPlanAprendiz> {
  late Future<List<SolicitudModel>> futureSolicitudes;

  @override
  void initState() {
    super.initState();
    _loadSolicitudes(); // Cargar las solicitudes filtradas por el ID del aprendiz
  }

  // Función para cargar las solicitudes del aprendiz autenticado
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

  // Función para obtener las solicitudes según el ID del aprendiz
  Future<List<SolicitudModel>> getSolicitudesByUser(int userId) async {
    List<SolicitudModel> todasLasSolicitudes = await getSolicitud();
    return todasLasSolicitudes
        .where((solicitud) =>
            solicitud.planmejoramiento == true &&
            solicitud.aprendiz.contains(
                userId)) // Filtra las solicitudes que involucran al aprendiz
        .toList();
  }

  // Función para construir la cuadrícula de los cards
  Widget _buildGrid(List<SolicitudModel> solicitudes) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        alignment: WrapAlignment.center,
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
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Plan de mejoramiento cargado",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.green,
                            ),
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
                "No hay solicitudes con plan de mejoramiento disponibles.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final solicitudesFiltradas = snapshot.data!;
            return _buildGrid(solicitudesFiltradas);
          }
        },
      ),
    );
  }
}

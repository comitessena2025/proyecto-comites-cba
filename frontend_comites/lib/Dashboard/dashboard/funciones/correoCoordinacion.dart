// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:comites/Models/AprendizModel.dart';
import 'package:comites/Models/CitacionModel.dart';
import 'package:comites/Models/CoordinadorModel.dart';
import 'package:comites/Models/SolicitudModel.dart';
import 'package:comites/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CitacionesPendientesCorreos extends StatefulWidget {
  const CitacionesPendientesCorreos({super.key});

  @override
  _CitacionesPendientesCorreosState createState() =>
      _CitacionesPendientesCorreosState();
}

class _CitacionesPendientesCorreosState
    extends State<CitacionesPendientesCorreos> {
  List<CitacionModel> citacionesRadicadas = [];

  @override
  void initState() {
    super.initState();
    // Cargar las citaciones radicadas y filtradas por coordinación
    _loadCitacionesRadicadasPorCoordinacion();
  }

  // Método para cargar las citaciones radicadas y filtrar por coordinación
  Future<void> _loadCitacionesRadicadasPorCoordinacion() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userId = appState.userId;

    if (userId != null) {
      try {
        // Obtener la coordinación del usuario actual
        final coordinador = await getCoordinador().then(
            (coordinadores) => coordinadores.firstWhere((c) => c.id == userId));
        final coordinacionActual = coordinador.coordinacion;

        // Obtener todos los aprendices
        final todosLosAprendices = await getAprendiz();

        // Filtrar los aprendices por la misma coordinación
        final aprendicesMismaCoordinacion = todosLosAprendices
            .where((aprendiz) => aprendiz.coordinacion == coordinacionActual)
            .toList();

        // Obtener todas las solicitudes
        final todasLasSolicitudes = await getSolicitud();

        // Filtrar las solicitudes que corresponden a aprendices de la coordinación
        final solicitudesDeCoordinacion = todasLasSolicitudes
            .where((solicitud) => solicitud.aprendiz.any((idAprendiz) =>
                aprendicesMismaCoordinacion.any((aprendiz) =>
                    aprendiz.id == idAprendiz))) // Relación por aprendiz
            .toList();

        // Obtener todas las citaciones
        final todasLasCitaciones = await getCitacion();

        // Filtrar las citaciones radicadas y que pertenezcan a solicitudes válidas
        final citacionesFiltradas = todasLasCitaciones.where((citacion) {
          return citacion.radicado == true &&
              citacion.actarealizada == false &&
              solicitudesDeCoordinacion
                  .any((solicitud) => solicitud.id == citacion.solicitud);
        }).toList();

        // Actualizar el estado solo si el widget está montado
        if (mounted) {
          setState(() {
            citacionesRadicadas = citacionesFiltradas;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            citacionesRadicadas = []; // Limpiar en caso de error
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar las citaciones: $e')),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          citacionesRadicadas = []; // Limpiar si no hay usuario autenticado
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: citacionesRadicadas.isEmpty
          ? const Center(
              child: Text(
                "No hay citaciones radicadas.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  alignment: WrapAlignment.start,
                  children: citacionesRadicadas.map((citacion) {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                      ),
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
                              // Título de la citación
                              Text(
                                "Citación ID: ${citacion.id}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Fecha de la citación
                              Text(
                                "Fecha: ${DateFormat('yyyy-MM-dd').format(citacion.diacitacion)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),

                              // Hora de inicio y fin
                              Text(
                                "Hora: ${citacion.horainicio} - ${citacion.horafin}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),

                              // Filtro para Lugar o Enlace
                              Row(
                                children: [
                                  if (citacion.lugarcitacion !=
                                      "No aplica") ...[
                                    const Icon(Icons.location_on,
                                        color: Colors.green, size: 20),
                                    const Text('Lugar:'),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        citacion.lugarcitacion,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ] else ...[
                                    const Icon(Icons.link,
                                        color: Colors.green, size: 20),
                                    const Text('Enlace:'),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _openLink(citacion.enlacecitacion);
                                        },
                                        child: Text(
                                          citacion.enlacecitacion,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Número de radicado
                              Text(
                                "Radicado N°: ${citacion.numeroderadicado}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),

                              // Botón para enviar correo
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () => {},
                                  icon: const Icon(Icons.email,
                                      color: Colors.blueAccent),
                                  label: const Text(
                                    "Enviar Correo",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  void _openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }
}

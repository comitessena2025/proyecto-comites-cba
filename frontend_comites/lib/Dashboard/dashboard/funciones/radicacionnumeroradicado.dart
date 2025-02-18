// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:comites/Models/CitacionModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CitacionesNumeroRadicado extends StatefulWidget {
  const CitacionesNumeroRadicado({super.key});

  @override
  _CitacionesNumeroRadicadoState createState() =>
      _CitacionesNumeroRadicadoState();
}

class _CitacionesNumeroRadicadoState extends State<CitacionesNumeroRadicado> {
  List<CitacionModel> citacionesNoRadicadas = [];
  bool _isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    _loadCitaciones();
  }

  /// Cargar las citaciones con `radicado = false`.
  Future<void> _loadCitaciones() async {
    try {
      List<CitacionModel> citaciones = await getCitacion();
      setState(() {
        citacionesNoRadicadas =
            citaciones.where((citacion) => !citacion.radicado).toList();
        _isLoading = false; // Cambiar estado de carga
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar las citaciones: $e")),
      );
    }
  }

  /// Actualizar una citación manualmente.
  Future<void> _updateCitacion(
      CitacionModel citacion, String nuevoRadicado) async {
    try {
      final url = "http://127.0.0.1:8000/api/Citacion/${citacion.id}/";
      final body = jsonEncode({
        "radicado": true,
        "numeroderadicado": nuevoRadicado,
      });

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          citacion.radicado = true;
          citacion.numeroderadicado = nuevoRadicado;
          citacionesNoRadicadas.remove(citacion);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Citación actualizada correctamente.")),
        );
      } else {
        throw Exception("Error en el backend: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar la citación: $e")),
      );
    }
  }

  /// Mostrar un modal para radicación automática.
  void _showRadicacionAutomaticaModal() {
    showDialog(
      context: context,
      builder: (context) {
        Map<int, String> radicados = {};

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Radicación Automática"),
              content: SingleChildScrollView(
                child: Column(
                  children: citacionesNoRadicadas.map((citacion) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Número de Radicado - ${citacion.id}",
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            radicados[citacion.id] = value;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (radicados.values.any((value) => value.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Todos los campos deben estar llenos."),
                        ),
                      );
                      return;
                    }

                    for (var citacion in citacionesNoRadicadas) {
                      _updateCitacion(citacion, radicados[citacion.id]!);
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Radicación completada.")),
                    );
                  },
                  child: const Text("Radicar Todas"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Mostrar un modal para radicación manual.
  void _showRadicacionManualModal(CitacionModel citacion) {
    final TextEditingController radicadoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Radicación Manual"),
          content: TextField(
            controller: radicadoController,
            decoration: const InputDecoration(
              labelText: "Número de Radicado",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (radicadoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("El número de radicado no puede estar vacío."),
                    ),
                  );
                  return;
                }

                _updateCitacion(citacion, radicadoController.text);
                Navigator.pop(context);
              },
              child: const Text("Actualizar"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(height: 20, width: 25),
                SizedBox(height: 10),
                SkeletonLoader(height: 15, width: 80),
                SizedBox(height: 10),
                SkeletonLoader(height: 15, width: 100),
                SizedBox(height: 10),
                SkeletonLoader(height: 15, width: 60),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: _isLoading
        ? _buildSkeletonLoader()
        : citacionesNoRadicadas.isEmpty
            ? const Center(
                child: Text(
                  "No hay citaciones pendientes.",
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
                    children: citacionesNoRadicadas.map((citacion) {
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
                                // Encabezado de la citación
                                Text(
                                  "Citación ID: ${citacion.id}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Filtro de lugar o enlace
                                Row(
                                  children: [
                                    if (citacion.lugarcitacion != "No aplica") ...[
                                      const Icon(Icons.location_on,
                                          color: Colors.green, size: 20),
                                      const Text('Lugar:'),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          citacion.lugarcitacion,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ] else ...[
                                      const Icon(Icons.link,
                                          color: Colors.blue, size: 20),
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

                                // Fecha y hora de la citación
                                Text(
                                  "Fecha: ${DateFormat('yyyy-MM-dd').format(citacion.diacitacion)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "Hora: ${citacion.horainicio} - ${citacion.horafin}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),

                                // Botón de acciones
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.green),
                                    onPressed: () => _showRadicacionManualModal(citacion),
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
    floatingActionButton: FloatingActionButton(
      onPressed: _showRadicacionAutomaticaModal,
      backgroundColor: Colors.green,
      child: const Icon(Icons.auto_mode, color: Colors.white),
    ),
  );
}

/// Método para abrir enlaces en el navegador
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

class SkeletonLoader extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const SkeletonLoader({
    super.key,
    this.height = 20.0,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

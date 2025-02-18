// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:comites/Widgets/animacionSobresaliente.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:comites/Models/CitacionModel.dart';
import 'package:comites/source.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart'; // Ajusta la ruta según tu estructura

class CitacionesParaRadicar extends StatefulWidget {
  const CitacionesParaRadicar({super.key});

  @override
  _CitacionesParaRadicarState createState() => _CitacionesParaRadicarState();
}

class _CitacionesParaRadicarState extends State<CitacionesParaRadicar> {
  late Future<List<CitacionModel>> _citaciones;

  @override
  void initState() {
    super.initState();
    _citaciones = getCitacionesNoRadicadas();
  }

  Future<List<CitacionModel>> getCitacionesNoRadicadas() async {
    final url = "$sourceApi/api/Citacion/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      print(decodedData); // Imprimir la respuesta para verificar los datos
      return decodedData
          .map((data) => CitacionModel.fromJson(data))
          .where((c) => !c.radicado)
          .toList();
    } else {
      throw Exception('Error al cargar las citaciones');
    }
  }

  Future<void> generarPdf(CitacionModel citacion) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Detalles de la Citación',
                  style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('ID de la Citación: ${citacion.id}'),
              pw.Text('Solicitud ID: ${citacion.solicitud}'),
              pw.Text('Fecha de Citación: ${citacion.diacitacion}'),
              pw.Text('Hora de Inicio: ${citacion.horainicio}'),
              pw.Text('Hora de Fin: ${citacion.horafin}'),
              pw.Text('Lugar: ${citacion.lugarcitacion}'),
              pw.Text('Enlace: ${citacion.enlacecitacion}'),
              pw.Text(
                  'Acta Realizada: ${citacion.actarealizada ? 'Sí' : 'No'}'),
              pw.Text('Radicado: ${citacion.radicado ? 'Sí' : 'No'}'),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/citacion_${citacion.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF generado y guardado en ${file.path}')));
  }

  Future<void> radicarCitacion(int citacionId) async {
    try {
      // Verificar si Supabase está inicializado
      final supabase = Supabase.instance.client;

      // Selección del archivo PDF
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final archivo = result.files.single;

        // Validar que el archivo seleccionado es un PDF
        if (archivo.bytes == null || archivo.extension != 'pdf') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Por favor selecciona un archivo PDF válido')),
          );
          return;
        }

        // Reemplazar espacios y caracteres especiales en el nombre del archivo
        final fileName = archivo.name
            .replaceAll(RegExp(r'\s+'), '_')
            .replaceAll(RegExp(r'[^a-zA-Z0-9_\.]'), '');

        // Generar un nombre único para el archivo utilizando un timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath =
            'citaciones/citacion_${citacionId}_$timestamp _$fileName';

        // Subir el archivo a Supabase
        final response = await supabase.storage
            .from('uploads')
            .uploadBinary(filePath, archivo.bytes!);

        if (response.error == null) {
          // Obtener la URL pública del archivo subido
          final publicUrlResponse =
              supabase.storage.from('uploads').getPublicUrl(filePath);

          if (publicUrlResponse.error != null) {
            throw Exception(
                'Error al obtener la URL pública del archivo: ${publicUrlResponse.error!.message}');
          }

          final publicUrl = publicUrlResponse.data;

          print('Archivo subido correctamente: $publicUrl');

          // Realizar la primera solicitud POST para guardar el archivo
          final urlPost = "$sourceApi/api/ArchivoCitacion/";
          final backendResponsePost = await http.post(
            Uri.parse(urlPost),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "citacion": citacionId, // Enviar el ID de la citación
              "file": publicUrl, // Enviar la URL pública del archivo
              "archivo_url": publicUrl, // Enviar la URL pública del archivo
            }),
          );

          if (backendResponsePost.statusCode != 201) {
            throw Exception(
                'Error al enviar los datos de la citación al backend: ${backendResponsePost.body}');
          }

          // Realizar la segunda solicitud PATCH para actualizar el campo "radicado"
          final urlPatch = "$sourceApi/api/Citacion/$citacionId/";
          final backendResponsePatch = await http.patch(
            Uri.parse(urlPatch),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "radicado": true,
              "archivo_url": publicUrl, // Enviar la URL pública
            }),
          );

          if (backendResponsePatch.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Archivo subido y citación radicada correctamente')),
            );

            // Actualizar el estado de las citaciones
            setState(() {
              _citaciones = getCitacionesNoRadicadas();
            });
          } else {
            throw Exception(
                'Error al actualizar la citación: ${backendResponsePatch.body}');
          }
        } else {
          throw Exception(
              'Error al subir archivo a Supabase: ${response.error!.message}');
        }
      } else {
        debugPrint('No se seleccionó ningún archivo.');
      }
    } catch (e) {
      debugPrint('Error al radicar la citación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al radicar la citación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CitacionModel>>(
        future: _citaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay citaciones para radicar',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          final citaciones = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determina cuántas columnas mostrar según el ancho de la pantalla
                final crossAxisCount =
                    (constraints.maxWidth ~/ 300).clamp(1, 4);

                return MasonryGridView.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: citaciones.length,
                  itemBuilder: (context, index) {
                    final citacion = citaciones[index];
                    return _buildCitacionCard(citacion);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCitacionCard(CitacionModel citacion) {
    return AnimacionSobresaliente(
      scaleFactor: 1.07,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: IntrinsicHeight(
          // Ajusta el alto al contenido
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fecha de la Citación
                Text(
                  'Citación: ${DateFormat('yyyy-MM-dd').format(citacion.diacitacion)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),

                // Lugar de la Citación
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
                              fontSize: 15, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else ...[
                      const Icon(Icons.link, color: Colors.green, size: 20),
                      const Text('Enlace:'),
                      const SizedBox(width: 5),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Abre el enlace en el navegador
                            _openLink(citacion.enlacecitacion);
                          },
                          child: Text(
                            citacion.enlacecitacion,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const Divider(thickness: 1.5, color: Colors.grey),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón para generar PDF
                    TextButton.icon(
                      onPressed: () => generarPdf(citacion),
                      icon: const Icon(Icons.picture_as_pdf,
                          color: Colors.blueAccent),
                      label: const Text(
                        'Generar PDF',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),

                    // Botón para radicar citación
                    TextButton.icon(
                      onPressed: () => radicarCitacion(citacion.id),
                      icon: const Icon(Icons.upload, color: Colors.green),
                      label: const Text(
                        'Radicar',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

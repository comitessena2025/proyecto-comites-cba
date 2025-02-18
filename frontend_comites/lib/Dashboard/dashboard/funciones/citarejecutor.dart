// ignore_for_file: library_private_types_in_public_api

import 'package:comites/Models/Llamadoatencion2_model.dart';
import 'package:comites/source.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CitacionEjecutor extends StatefulWidget {
  const CitacionEjecutor({super.key});

  @override
  _CitacionEjecutorState createState() => _CitacionEjecutorState();
}

class _CitacionEjecutorState extends State<CitacionEjecutor> {
  late Future<List<LlamadoatencionModel2>> _llamadosFuture;

  @override
  void initState() {
    super.initState();
    _llamadosFuture = getLlamadoatencion2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<LlamadoatencionModel2>>(
        future: _llamadosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error al cargar los llamados: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay llamados de atención.'));
          }

          // Mostrar los llamados en tarjetas (cards)
      return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 12, // Espacio horizontal entre tarjetas
                  runSpacing: 12, // Espacio vertical entre filas
                  alignment: WrapAlignment.center, // Centra las tarjetas
                  children: snapshot.data!.map((llamado) {
                    return SizedBox(
                      width: constraints.maxWidth > 600 ? 280 : constraints.maxWidth / 2 - 14, 
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID: ${llamado.id}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text('Fecha: ${llamado.fechallamadoatencion.toLocal()}'),
                              Text('Descripción: ${llamado.descripcion}'),
                              Text('Observaciones: ${llamado.observaciones}'),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  llamado.llamadodeatencion ? Icons.warning : Icons.check_circle,
                                  color: llamado.llamadodeatencion ? Colors.red : Colors.green,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        );


        },
      ),
    );
  }
}

/// Método para obtener los datos de los llamados de atención desde la API.
Future<List<LlamadoatencionModel2>> getLlamadoatencion2() async {
  final url = Uri.parse('$sourceApi/api/llamadoAtenciond/');
  print('Realizando solicitud GET a: $url');
  final response = await http.get(url);

  print('Respuesta de la API recibida con código: ${response.statusCode}');

  if (response.statusCode == 200) {
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    print('Datos decodificados: $responseBodyUtf8');
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);
    return decodedData.map((json) {
      print('Procesando elemento JSON: $json');
      return LlamadoatencionModel2.fromJson(json);
    }).toList();
  } else {
    throw Exception('Error al cargar los llamados de atención');
  }
}

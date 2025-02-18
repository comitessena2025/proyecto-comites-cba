// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ListaDePDFs extends StatefulWidget {
  const ListaDePDFs({super.key});

  @override
  _ListaDePDFsState createState() => _ListaDePDFsState();
}

class _ListaDePDFsState extends State<ListaDePDFs> {
  late Future<List<dynamic>> _pdfs;

  @override
  void initState() {
    super.initState();
    _pdfs = obtenerPDFs();
  }

  Future<List<dynamic>> obtenerPDFs() async {
    const url =
        "http://127.0.0.1:8000/api/ArchivoCitacion"; // URL de tu API en Django
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Devuelve la lista de archivos con URL
    } else {
      throw Exception('Error al cargar los PDFs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archivos PDF Subidos')),
      body: FutureBuilder<List<dynamic>>(
        future: _pdfs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay PDFs disponibles'));
          }

          final pdfs = snapshot.data!;
          return ListView.builder(
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              final pdfName = pdf['file'] ?? 'Nombre no disponible';
              final pdfUrl = pdf['archivo_url']; // URL pública del PDF

              return ListTile(
                title: Text(pdfName),
                subtitle: const Text('Archivo disponible'),
                trailing: IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () async {
                    if (pdfUrl != null) {
                      // Abrir el PDF usando la URL pública
                      if (await canLaunch(pdfUrl)) {
                        await launch(pdfUrl);
                      } else {
                        throw 'No se puede abrir $pdfUrl';
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

/// Lista que almacena las citaciones obtenidas de la API.
List<CitacionModel> citaciones = [];

/// Clase que representa una citación en la aplicación.
class CitacionModel {
  final int id;
  final int solicitud; // Usamos el ID de la solicitud
  final DateTime diacitacion;
  final String horainicio;
  final String horafin;
  final String lugarcitacion;
  final String enlacecitacion;
  final bool actarealizada;
  String numeroderadicado;
  bool radicado;

  CitacionModel({
    required this.id,
    required this.solicitud,
    required this.diacitacion,
    required this.horainicio,
    required this.horafin,
    required this.lugarcitacion,
    required this.enlacecitacion,
    required this.actarealizada,
    required this.numeroderadicado,
    required this.radicado,
  });

  factory CitacionModel.fromJson(Map<String, dynamic> json) {
    return CitacionModel(
      id: json['id'] ?? 0, // Asignamos 0 si 'id' es null
      solicitud: json['solicitud'] ?? 0, // Asignamos 0 si 'solicitud' es null
      diacitacion: json['diacitacion'] != null
          ? DateTime.parse(json['diacitacion'])
          : DateTime.now(), // Usamos la fecha actual si es null
      horainicio:
          json['horainicio'] ?? '', // Asignamos vacío si 'horainicio' es null
      horafin: json['horafin'] ?? '', // Asignamos vacío si 'horafin' es null
      lugarcitacion: json['lugarcitacion'] ??
          '', // Asignamos vacío si 'lugarcitacion' es null
      enlacecitacion: json['enlacecitacion'] ??
          '', // Asignamos vacío si 'enlacecitacion' es null
      actarealizada: json['actarealizada'] ??
          false, // Asignamos false si 'actarealizada' es null
      numeroderadicado: json['numeroderadicado'] ?? "",
      radicado:
          json['radicado'] ?? false, // Asignamos false si 'radicado' es null
    );
  }
}

/// Método para obtener los datos de las citaciones desde la API.
Future<List<CitacionModel>> getCitacion() async {
  // URL para obtener las citaciones de la API
  String url = "$sourceApi/api/Citacion/";

  // Realizar una solicitud GET a la URL para obtener las citaciones
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    citaciones.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de citaciones con datos
    for (var citacionData in decodedData) {
      citaciones.add(
        CitacionModel.fromJson(citacionData),
      );
    }
    // Devolver la lista de citaciones
    return citaciones;
  } else {
    // Si el código de estado no es 200, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}

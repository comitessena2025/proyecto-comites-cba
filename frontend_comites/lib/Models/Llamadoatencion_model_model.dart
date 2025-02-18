// ignore_for_file: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

final fechaActual = DateTime.now();

// Formatea la fecha y hora en un solo String
final fechaYHora =
    '${fechaActual.toIso8601String().split('T')[0]} ${fechaActual.hour.toString().padLeft(2, '0')}:${fechaActual.minute.toString().padLeft(2, '0')}';

/// Lista que almacena las solicitudes obtenidas de la API.
List<LlamadoatencionModel> llamadoatencion = [];

/// Clase que representa una solicitud en la aplicación.

class LlamadoatencionModel {
  final int id;
  final List<dynamic> aprendiz;
  final DateTime fechallamadoatencion;
  final String descripcion;
  final String observaciones;
  final List<dynamic> responsable;
  final List<dynamic> reglamento;
  final bool llamadodeatencion;

  LlamadoatencionModel({
    required this.id,
    required this.aprendiz,
    required this.fechallamadoatencion,
    required this.descripcion,
    required this.observaciones,
    required this.responsable,
    required this.reglamento,
    required this.llamadodeatencion,
  });

  factory LlamadoatencionModel.fromJson(Map<String, dynamic> json) {
    return LlamadoatencionModel(
      id: json['id'],
      aprendiz: json['aprendiz'] ?? [],
      fechallamadoatencion: DateTime.parse(json['fechallamadoatencion']),
      descripcion: json['descripcion'] ?? '',
      observaciones: json['observaciones'] ?? '',
      responsable: json['responsable'] ?? [],
      reglamento: json['reglamento'] ?? [],
      llamadodeatencion: json['llamadodeatencion'] ?? false,
    );
  }
}

Future<List<LlamadoatencionModel>> getLlamadoatecionByUser(int userId) async {
  // URL para obtener todas las solicitudes
  final url = Uri.parse('http://127.0.0.1:8000/api/llamadoAtencion/');

  // Realizar la solicitud GET a la URL para obtener las solicitudes
  final response = await http.get(url);

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Decodificar la respuesta en UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    final List<dynamic> data = json.decode(responseBodyUtf8);

    // Mapear las solicitudes y filtrar donde el usuario sea aprendiz o responsable
    return data
        .map((json) => LlamadoatencionModel.fromJson(json))
        .where((solicitud) => solicitud.responsable.contains(userId))
        .toList();
  } else {
    throw Exception('Error al cargar las solicitudes');
  }
}

/// Método para obtener los datos de las solicitudes desde la API.
Future<List<LlamadoatencionModel>> getLlamadoatencion() async {
  // URL para obtener las solicitudes de la API
  String url = "$sourceApi/api/llamadoAtencion/";

  // Realizar una solicitud GET a la URL para obtener las solicitudes
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    llamadoatencion.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de solicitudes con datos
    for (var solicitudData in decodedData) {
      llamadoatencion.add(
        LlamadoatencionModel.fromJson(solicitudData),
      );
    }
    // Devolver la lista de solicitudes
    return llamadoatencion;
  } else {
    // Si el código de estado no es 200, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}

Future<LlamadoatencionModel> _getLllamadoatencionDetails(
    int solicitudId) async {
  // URL para obtener los detalles de una solicitud específica
  final url =
      Uri.parse('http://127.0.0.1:8000/api/llamadoAtencion/$solicitudId/');

  // Realizar la solicitud GET a la URL para obtener los detalles de la solicitud
  final response = await http.get(url);

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Decodificar la respuesta en UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> data = json.decode(responseBodyUtf8);

    // Retornar el objeto SolicitudModel con los datos obtenidos
    return LlamadoatencionModel.fromJson(data);
  } else {
    throw Exception('Error al obtener los detalles de la solicitud');
  }
}

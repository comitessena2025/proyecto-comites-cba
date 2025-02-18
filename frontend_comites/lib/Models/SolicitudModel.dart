// ignore_for_file: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

final fechaActual = DateTime.now();

// Formatea la fecha y hora en un solo String
final fechaYHora =
    '${fechaActual.toIso8601String().split('T')[0]} ${fechaActual.hour.toString().padLeft(2, '0')}:${fechaActual.minute.toString().padLeft(2, '0')}';

/// Lista que almacena las solicitudes obtenidas de la API.
List<SolicitudModel> solicitud = [];

/// Clase que representa una solicitud en la aplicación.
class SolicitudModel {
  final int id;
  List<dynamic> aprendiz; // Asumiendo que es una lista de IDs
  final DateTime fechallamadoatencion;
  final String descripcion;
  final String observaciones;
  List<dynamic> responsable; // Asumiendo que es una lista de IDs
  List<dynamic> reglamento; // Asumiendo que es una lista de IDs
  bool solicitudenviada;
  bool solicitudaceptada;
  bool coordinacionaceptada;
  bool solicitudrechazada;
  bool citacionenviada;
  bool comiteenviado;
  bool planmejoramiento;
  bool pmsubidoinstructor;
  bool pmsubidoaprendiz;
  bool desicoordinador;
  bool desiabogada;
  bool finalizado;
  String name_fildsolicitud1;
  String filesolicitud1;
  String name_fildsolicitud2;
  String filesolicitud2;
  String name_fildsolicitud3;
  String filesolicitud3;
  String name_fildsolicitud4;
  String filesolicitud4;

  SolicitudModel({
    required this.id,
    required this.aprendiz,
    required this.fechallamadoatencion,
    required this.descripcion,
    required this.observaciones,
    required this.responsable,
    required this.reglamento,
    required this.solicitudenviada,
    required this.solicitudaceptada,
    required this.coordinacionaceptada,
    required this.solicitudrechazada,
    required this.citacionenviada,
    required this.comiteenviado,
    required this.planmejoramiento,
    required this.pmsubidoaprendiz,
    required this.pmsubidoinstructor,
    required this.desicoordinador,
    required this.desiabogada,
    required this.finalizado,
    required this.name_fildsolicitud1,
    required this.filesolicitud1,
    required this.name_fildsolicitud2,
    required this.filesolicitud2,
    required this.name_fildsolicitud3,
    required this.filesolicitud3,
    required this.name_fildsolicitud4,
    required this.filesolicitud4,
  });

  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    return SolicitudModel(
      id: json['id'],
      aprendiz: json['aprendiz'] ?? [],
      fechallamadoatencion: DateTime.parse(json['fechasolicitud']),
      descripcion: json['descripcion'] ?? '',
      observaciones: json['observaciones'] ?? '',
      responsable: json['responsable'] ?? [],
      reglamento: json['reglamento'] ?? [],
      solicitudenviada: json['solicitudenviada'] ?? true,
      solicitudaceptada: json['solicitudaceptada'] ?? true,
      coordinacionaceptada: json['coordinacionaceptada'] ?? false,
      solicitudrechazada: json['solicitudrechazada'] ?? false,
      citacionenviada: json['citacionenviada'] ?? false,
      comiteenviado: json['comiteenviado'] ?? false,
      planmejoramiento: json['planmejoramiento'] ?? false,
      pmsubidoaprendiz: json['pmsubidoaprendiz'] ?? false,
      pmsubidoinstructor: json['pmsubidoinstructor'] ?? false,
      desicoordinador: json['desicoordinador'] ?? false,
      desiabogada: json['desiabogada'] ?? false,
      finalizado: json['finalizado'] ?? false,
      name_fildsolicitud1:
          json['name_fildsolicitud1'] ?? 'no hay', // Valor por defecto
      filesolicitud1: json['filesolicitud1'] ?? 'no hay', // Valor por defecto
      name_fildsolicitud2:
          json['name_fildsolicitud2'] ?? 'no hay', // Valor por defecto
      filesolicitud2: json['filesolicitud2'] ?? 'no hay', // Valor por defecto
      name_fildsolicitud3:
          json['name_fildsolicitud3'] ?? 'no hay', // Valor por defecto
      filesolicitud3: json['filesolicitud3'] ?? 'no hay', // Valor por defecto
      name_fildsolicitud4:
          json['name_fildsolicitud4'] ?? 'no hay', // Valor por defecto
      filesolicitud4: json['filesolicitud4'] ?? 'no hay', // Valor por defecto
    );
  }
}

Future<List<SolicitudModel>> getSolicitudesByUser(int userId) async {
  // URL para obtener todas las solicitudes
  final url = Uri.parse('http://127.0.0.1:8000/api/Solicitud/');

  // Realizar la solicitud GET a la URL para obtener las solicitudes
  final response = await http.get(url);

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Decodificar la respuesta en UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    final List<dynamic> data = json.decode(responseBodyUtf8);

    // Mapear las solicitudes y filtrar donde el usuario sea aprendiz o responsable
    return data
        .map((json) => SolicitudModel.fromJson(json))
        .where((solicitud) => solicitud.responsable.contains(userId))
        .toList();
  } else {
    throw Exception('Error al cargar las solicitudes');
  }
}

/// Método para obtener los datos de las solicitudes desde la API.
Future<List<SolicitudModel>> getSolicitud() async {
  // URL para obtener las solicitudes de la API
  String url = "$sourceApi/api/Solicitud/";

  // Realizar una solicitud GET a la URL para obtener las solicitudes
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    solicitud.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista de solicitudes con datos
    for (var solicitudData in decodedData) {
      solicitud.add(
        SolicitudModel.fromJson(solicitudData),
      );
    }
    // Devolver la lista de solicitudes
    return solicitud;
  } else {
    // Si el código de estado no es 200, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}

Future<SolicitudModel> _getSolicitudDetails(int solicitudId) async {
  // URL para obtener los detalles de una solicitud específica
  final url = Uri.parse('http://127.0.0.1:8000/api/Solicitud/$solicitudId/');

  // Realizar la solicitud GET a la URL para obtener los detalles de la solicitud
  final response = await http.get(url);

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Decodificar la respuesta en UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> data = json.decode(responseBodyUtf8);

    // Retornar el objeto SolicitudModel con los datos obtenidos
    return SolicitudModel.fromJson(data);
  } else {
    throw Exception('Error al obtener los detalles de la solicitud');
  }
}

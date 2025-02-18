// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../source.dart';

class RadicacionModel {
  final int id;
  final String nombres;
  final String apellidos;
  final String tipoDocumento;
  final String numeroDocumento;
  final String correoElectronico;
  final String rol1;
  final bool estado;

  RadicacionModel({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.correoElectronico,
    required this.rol1,
    required this.estado,
  });
}

List<RadicacionModel> radicacion = [];

// Método para obtener los datos de los usuarios
Future<List<RadicacionModel>> getradicacion() async {
  /// URL para obtener los datos de los usuarios de la API.
  ///
  /// Esta URL se utiliza para realizar una solicitud GET a la API y obtener los datos de los usuarios.
  String url = "";

  // Construir la URL de la API utilizando la variable de configuración [sourceApi]
  url = "$sourceApi/api/Radicacion/";

  // Realizar una solicitud GET a la URL para obtener los datos de los usuarios
  // El método [http.get] devuelve una promesa que se resuelve en una instancia de la clase [http.Response].
  // La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    radicacion.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
    for (var radicacionData in decodedData) {
      radicacion.add(
        RadicacionModel(
          id: radicacionData['id'] ?? 0,
          nombres: radicacionData['nombres'] ?? "",
          apellidos: radicacionData['apellidos'] ?? "",
          tipoDocumento: radicacionData['tipoDocumento'] ?? "",
          numeroDocumento: radicacionData['numeroDocumento'] ?? "",
          correoElectronico: radicacionData['correoElectronico'] ?? "",
          rol1: radicacionData['rol1'] ?? "",
          estado: radicacionData['estado'] ?? true,
        ),
      );
    }

    // Devolver la lista de usuarios
    return radicacion;
  } else {
    // Si la respuesta no fue exitosa, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}

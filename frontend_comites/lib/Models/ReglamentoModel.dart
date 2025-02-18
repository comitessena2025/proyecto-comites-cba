// ignore_for_file: file_names
import 'dart:convert';

import 'package:comites/source.dart';
import 'package:http/http.dart' as http;

class ReglamentoModel {
  final int id;
  final String capitulo;
  final String numeral;
  final String descripcion;
  final bool academico;
  final bool disciplinario;
  final String gravedad;

  ReglamentoModel({
    required this.id,
    required this.capitulo,
    required this.numeral,
    required this.descripcion,
    required this.academico,
    required this.disciplinario,
    required this.gravedad,
  });

  factory ReglamentoModel.fromJson(Map<String, dynamic> json) {
    return ReglamentoModel(
      id: json['id'] ?? 0,
      capitulo: json['capitulo'] != null
          ? utf8.decode(json['capitulo'].toString().runes.toList())
          : "",
      numeral: json['numeral'] != null
          ? utf8.decode(json['numeral'].toString().runes.toList())
          : "",
      descripcion: json['descripcion'] != null
          ? utf8.decode(json['descripcion'].toString().runes.toList())
          : "",
      academico: json['academico'] ?? false,
      disciplinario: json['disciplinario'] ?? false,
      gravedad: json['gravedad'] != null
          ? utf8.decode(json['gravedad'].toString().runes.toList())
          : "leve", // Valor por defecto
    );
  }

  // Get para obtener el tipo de falta
  String get tipoFalta {
    if (disciplinario) {
      return 'Disciplinario';
    } else if (academico) {
      return 'Académico';
    } else {
      return 'Desconocido'; // Si ambos son falsos muestra que es reglamento desconocido
    }
  }

  firstWhere(bool Function(dynamic r) param0, {required Null Function() orElse}) {}
}

List<ReglamentoModel> reglamentos1 = [];

Future<List<ReglamentoModel>> getReglamento() async {
  /// URL para obtener los datos de los usuarios de la API.
  ///
  /// Esta URL se utiliza para realizar una solicitud GET a la API y obtener los datos de los usuarios.
  String url = "";

  // Construir la URL de la API utilizando la variable de configuración [sourceApi]
  url = "$sourceApi/api/Reglamento/";

  // Realizar una solicitud GET a la URL para obtener los datos de los usuarios
  // El método [http.get] devuelve una promesa que se resuelve en una instancia de la clase [http.Response].
  // La respuesta de la solicitud se almacena en la variable [response].
  final response = await http.get(Uri.parse(url));

  // Verificar el código de estado de la respuesta
  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    reglamentos1.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Llenar la lista con los datos decodificados
    for (var reglamentoData in decodedData) {
      reglamentos1.add(
        ReglamentoModel(
          id: reglamentoData['id'] ?? 0,
          capitulo: reglamentoData['capitulo'] ?? "",
          numeral: reglamentoData['numeral'] ?? "",
          descripcion: reglamentoData['descripcion'] ?? "",
          academico: reglamentoData['academico'] ?? true,
          disciplinario: reglamentoData['disciplinario'] ?? true,
          gravedad: reglamentoData['gravedad'] ?? "",
        ),
      );
    }

    // Devolver la lista de usuarios
    return reglamentos1;
  } else {
    // Si la respuesta no fue exitosa, se lanza una excepción
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}

import 'dart:convert';
import 'package:comites/Models/AprendizModel.dart';
import 'package:comites/Models/CitacionModel.dart';
import 'package:comites/Models/CoordinadorModel.dart';
import 'package:comites/Models/SolicitudModel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<List<CitacionModel>> getCitaciones() async {
    final response = await http.get(Uri.parse('$baseUrl/Citacion/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => CitacionModel.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener citaciones");
    }
  }

  static Future<List<SolicitudModel>> getSolicitudes() async {
    final response = await http.get(Uri.parse('$baseUrl/Solicitud/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => SolicitudModel.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener solicitudes");
    }
  }

  static Future<List<UsuarioAprendizModel>> getAprendices() async {
    final response = await http.get(Uri.parse('$baseUrl/UsuarioAprendiz/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => UsuarioAprendizModel.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener aprendices");
    }
  }

  static Future<CoordinadorModel> getCoordinador(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Coordinador/$id'));
    if (response.statusCode == 200) {
      return CoordinadorModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Error al obtener coordinador");
    }
  }
}

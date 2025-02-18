// ENVIO DEL EMAIL FUTURE...
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../source.dart';

class VerificationService {
  final String _username = 'comitessenacba@gmail.com';
  final String _password = 'nyed musr acjd dlts';

  // Uso de una funcion en django para el envio de los correos.
  Future djangoSendEmail(String toEmail, String confirmationCode) async {
    String url = "";

    url = "$sourceApi/api/send-email/";
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'subject': 'Código de confirmación',
      'message': 'Tu código de confirmación es: $confirmationCode',
      'recipient_list': [toEmail],
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Correo electrónico enviado exitosamente');
    } else {
      print('Error al enviar correo electrónico: ${response.body}');
    }
  }

  Future djangoSendEmail2(String toEmail, String message) async {
    String url = "$sourceApi/api/send-email/";
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'subject': 'Solicitud Rechazada',
      'message': message, // Ahora utilizamos el mensaje dinámico
      'recipient_list': [toEmail], // Asegúrate de enviar una lista
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Correo electrónico enviado exitosamente a: $toEmail');
    } else {
      print('Error al enviar correo electrónico: ${response.body}');
    }
  }

  Future<void> djangoSendEmail3(
      String toEmail, String message, String base64Pdf) async {
    String url = "$sourceApi/api/send-email/";
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'subject': 'Solicitud Enviada correctamente',
      'message': message,
      'recipient_list': [toEmail], // Asegúrate de enviar una lista
      'attachment': base64Pdf, // Agregar el archivo adjunto
      'attachment_name':
          'solicitud_${DateTime.now().toIso8601String()}.pdf', // Nombre del archivo
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Correo electrónico enviado exitosamente a: $toEmail');
    } else {
      print('Error al enviar correo electrónico: ${response.body}');
    }
  }

  Future<void> djangoSendEmail4(
      String toEmail, String message, String base64Pdf) async {
    String url = "$sourceApi/api/send-email/";
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'subject': 'Solicitud Enviada correctamente',
      'message': message,
      'recipient_list': [toEmail], // Asegúrate de enviar una lista
      'attachment': base64Pdf, // Agregar el archivo adjunto
      'attachment_name':
          'solicitud_${DateTime.now().toIso8601String()}.pdf', // Nombre del archivo
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Correo electrónico enviado exitosamente a: $toEmail');
    } else {
      print('Error al enviar correo electrónico: ${response.body}');
    }
  }

// Uso de una dependencia de flutter( solo android e ios)      :(
  Future sendEmail(String toEmail, String confirmationCode) async {
    final smtpServer = gmail(
      _username,
      _password,
    );

    final message = Message()
      ..from = Address(_username, 'comite')
      ..recipients.add(toEmail)
      ..subject = 'Código de confirmación'
      ..text = 'Tu código de confirmación es: $confirmationCode'
      ..html = '<h1>Tu código de confirmación es: $confirmationCode</h1>';

    try {
      await send(message, smtpServer);
      print('Correo electrónico enviado correctamente');
    } catch (e) {
      print('Error al enviar el correo electrónico: $e');
    }
  }
}

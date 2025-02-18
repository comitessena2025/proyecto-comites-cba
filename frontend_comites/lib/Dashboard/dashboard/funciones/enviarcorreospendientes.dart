import 'package:comites/Models/CitacionModel.dart';
import 'package:comites/Models/SolicitudModel.dart';
import 'package:comites/Models/instructormodel.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> enviarCorreoCitacion(CitacionModel citacion,
    SolicitudModel solicitud, InstructorModel instructor) async {
  try {
    // Verificar si los datos son válidos
    if (solicitud.aprendiz.isEmpty) {
      print("No hay aprendices asociados a esta solicitud.");
      return;
    }

    // Configuración del servidor SMTP
    final smtpServer = gmail("comitessenacba@gmail.com",
        "ManuelyMarianax100"); // Cambia esto con tus credenciales

    // Crear el contenido del correo
    final mensajeParaAprendices = Message()
      ..from = const Address("tuCorreo@gmail.com", "Comités SENA")
      ..recipients.addAll(
          solicitud.aprendiz.map((aprendiz) => aprendiz.correoElectronico))
      ..subject = "Citación a Comité - ID: ${citacion.id}"
      ..text = "Hola,\n\nSe les informa que tienen una citación programada.\n"
          "Detalles:\n"
          "Fecha: ${DateFormat('yyyy-MM-dd').format(citacion.diacitacion)}\n"
          "Hora: ${citacion.horainicio} - ${citacion.horafin}\n"
          "Lugar/Enlace: ${citacion.lugarcitacion != "No aplica" ? citacion.lugarcitacion : citacion.enlacecitacion}\n\n"
          "Por favor, asistir puntualmente.\n\nSaludos,\nComités SENA";

    final mensajeParaInstructor = Message()
      ..from = const Address("tuCorreo@gmail.com", "Comités SENA")
      ..recipients.add(instructor.correoElectronico)
      ..subject = "Citación a Comité - ID: ${citacion.id} (Instructor)"
      ..text = "Hola ${instructor.nombres},\n\nSe le informa que tiene una citación programada para uno de sus aprendices.\n"
          "Detalles:\n"
          "Fecha: ${DateFormat('yyyy-MM-dd').format(citacion.diacitacion)}\n"
          "Hora: ${citacion.horainicio} - ${citacion.horafin}\n"
          "Lugar/Enlace: ${citacion.lugarcitacion != "No aplica" ? citacion.lugarcitacion : citacion.enlacecitacion}\n\n"
          "Saludos,\nComités SENA";

    // Enviar los correos
    await send(mensajeParaAprendices, smtpServer);
    await send(mensajeParaInstructor, smtpServer);

    print("Correos enviados exitosamente.");
  } catch (e) {
    print("Error al enviar los correos: $e");
  }
}

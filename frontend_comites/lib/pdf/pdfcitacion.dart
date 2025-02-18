import 'dart:io';
import 'package:comites/Models/CitacionModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generarPdf(CitacionModel citacion) async {
  // Crear un documento PDF
  final pdf = pw.Document();

  // Agregar una página al documento
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Citación ID: ${citacion.id}',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Solicitud ID: ${citacion.solicitud}'),
            pw.Text('Fecha de Citación: ${citacion.diacitacion.toString()}'),
            pw.Text(
                'Hora de Inicio: ${citacion.horainicio}'), // Asegúrate de formatear correctamente la hora
            pw.Text('Lugar de Citación: ${citacion.lugarcitacion}'),
            pw.Text('Enlace de Citación: ${citacion.enlacecitacion}'),
          ],
        );
      },
    ),
  );

  // Obtener el directorio donde guardar el archivo
  final output = await getExternalStorageDirectory();
  final file = File('${output!.path}/citacion_${citacion.id}.pdf');

  // Guardar el PDF en el directorio
  await file.writeAsBytes(await pdf.save());

  // Mostrar un mensaje de éxito
  print('PDF generado en: ${file.path}');
}

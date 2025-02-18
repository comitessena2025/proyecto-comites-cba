// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unused_element

import 'package:comites/Auth/source/verification.dart';
import 'package:comites/Models/AprendizModel.dart';
import 'package:comites/Models/CoordinadorModel.dart';
import 'package:comites/Models/SolicitudModel.dart';
import 'package:comites/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:comites/source.dart';
import 'package:comites/Models/ReglamentoModel.dart';
import 'package:comites/Models/instructormodel.dart';
import 'package:comites/Widgets/Cards.dart';
import 'package:comites/Widgets/animacionSobresaliente.dart';
import 'package:comites/Widgets/tooltip.dart';
import 'package:comites/constantsDesign.dart';
import 'package:comites/pdf/generar_pdf.dart';
// El archivo donde está AppState y la función getSolicitudesByUser
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class AceptarSolicitudes extends StatefulWidget {
  const AceptarSolicitudes({super.key});

  @override
  _AceptarSolicitudesState createState() => _AceptarSolicitudesState();
}

class _AceptarSolicitudesState extends State<AceptarSolicitudes> {
  Future<List<SolicitudModel>>? futureSolicitudes;
  List<InstructorModel> instructores = [];

  Future<void> cargarInstructores() async {
    try {
      instructores = await getIntructor();
    } catch (e) {
      print('Error al cargar instructores: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureSolicitudes = _loadSolicitudes();
    cargarInstructores();
  }

  Future<List<SolicitudModel>> _loadSolicitudes() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userId = appState.userId;

    if (userId != null) {
      try {
        // Obtener la coordinación del coordinador actual
        final coordinador = await getCoordinador().then(
            (coordinadores) => coordinadores.firstWhere((c) => c.id == userId));
        final coordinacionActual = coordinador.coordinacion;

        // Obtener todos los aprendices de la misma coordinación
        final aprendicesMismaCoordinacion = await getAprendiz().then(
            (aprendices) => aprendices
                .where((i) => i.coordinacion == coordinacionActual)
                .toList());

        // Obtener todas las solicitudes
        final todasLasSolicitudes = await getSolicitud();

        // Filtrar las solicitudes de los aprendices de la misma coordinación y que no estén rechazadas
        final solicitudesFiltradas = todasLasSolicitudes
            .where((solicitud) =>
                solicitud.solicitudenviada &&
                !solicitud
                    .solicitudrechazada && // Asegúrate de que la solicitud no esté rechazada
                aprendicesMismaCoordinacion.any(
                    (aprendiz) => solicitud.aprendiz.contains(aprendiz.id)))
            .toList();

        return solicitudesFiltradas;
      } catch (e) {
        throw Exception('Error al cargar las solicitudes: $e');
      }
    } else {
      throw Exception('Usuario no autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SolicitudModel>>(
        future: futureSolicitudes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay solicitudes disponibles'));
          } else {
            final solicitudes = snapshot.data!;
            return _buildGrid(solicitudes);
          }
        },
      ),
    );
  }

  Widget _buildGrid(List<SolicitudModel> solicitudes) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            spacing: 30.0,
            runSpacing: 20.0,
            alignment: WrapAlignment.center,
            children: solicitudes.map((solicitud) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                child: FutureBuilder<List<UsuarioAprendizModel>>(
                  future: Future.wait(
                    solicitud.aprendiz.map((id) => _getAprendizDetails(id)),
                  ),
                  builder: (context, aprendizSnapshot) {
                    if (aprendizSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SkeletonLoader();
                    } else if (aprendizSnapshot.hasError) {
                      return Text('Error: ${aprendizSnapshot.error}');
                    } else if (!aprendizSnapshot.hasData ||
                        aprendizSnapshot.data!.isEmpty) {
                      return const Text('No hay aprendices disponibles');
                    } else {
                      final aprendices = aprendizSnapshot.data!;
                      final nombresAprendices = aprendices
                          .map((a) => '${a.nombres} ${a.apellidos}')
                          .join(', ');

                      return FutureBuilder<List<ReglamentoModel>>(
                        future: Future.wait(
                          solicitud.reglamento
                              .map((id) => _getReglamentoDetails(id)),
                        ),
                        builder: (context, reglamentoSnapshot) {
                          if (reglamentoSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SkeletonLoader();
                          } else if (reglamentoSnapshot.hasError) {
                            return Text('Error: ${reglamentoSnapshot.error}');
                          } else if (!reglamentoSnapshot.hasData ||
                              reglamentoSnapshot.data!.isEmpty) {
                            return const Text('No hay reglamentos disponibles');
                          } else {
                            final reglamentos = reglamentoSnapshot.data!;

                            // Determine the card style based on gravedad
                            Widget selectedCardStyle;
                            if (reglamentos.any((reglamento) =>
                                reglamento.gravedad == "muy grave")) {
                              selectedCardStyle = CardMuyGrave.buildCard(
                                onTap: () {},
                                child: _buildCardContent(
                                    solicitud, nombresAprendices, reglamentos),
                              );
                            } else if (reglamentos.any((reglamento) =>
                                reglamento.gravedad == "grave")) {
                              selectedCardStyle = CardGrave.buildCard(
                                onTap: () {},
                                child: _buildCardContent(
                                    solicitud, nombresAprendices, reglamentos),
                              );
                            } else {
                              selectedCardStyle = CardStyle.buildCard(
                                onTap: () {},
                                child: _buildCardContent(
                                    solicitud, nombresAprendices, reglamentos),
                              );
                            }

                            return selectedCardStyle;
                          }
                        },
                      );
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(SolicitudModel solicitud) {
    // Reemplaza por tu lógica de construir las tarjetas
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Fecha: ${DateFormat('yyyy-MM-dd').format(solicitud.fechallamadoatencion)}'),
            Text('Descripción: ${solicitud.descripcion}'),
            ElevatedButton(
              onPressed: () {
                // Acción al aceptar la solicitud
              },
              child: const Text('Aceptar Solicitud'),
            ),
          ],
        ),
      ),
    );
  }

  Future<UsuarioAprendizModel> _getAprendizDetails(int id) async {
    final response =
        await http.get(Uri.parse('$sourceApi/api/UsuarioAprendiz/$id'));
    if (response.statusCode == 200) {
      return UsuarioAprendizModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load aprendiz details');
    }
  }

  Future<InstructorModel> _getInstructorDetails(int id) async {
    final response = await http.get(Uri.parse('$sourceApi/api/Instructor/$id'));
    if (response.statusCode == 200) {
      return InstructorModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load instructor details');
    }
  }

  Future<ReglamentoModel> _getReglamentoDetails(int id) async {
    final response = await http.get(Uri.parse('$sourceApi/api/Reglamento/$id'));
    if (response.statusCode == 200) {
      return ReglamentoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load reglamento details');
    }
  }

  Future<void> _generatePdf(SolicitudModel solicitud) async {
    // Cargar detalles
    List<UsuarioAprendizModel> aprendices = await Future.wait(
        solicitud.aprendiz.map((id) => _getAprendizDetails(id)));
    List<InstructorModel> responsables = await Future.wait(
        solicitud.responsable.map((id) => _getInstructorDetails(id)));
    List<ReglamentoModel> reglamentos = await Future.wait(
        solicitud.reglamento.map((id) => _getReglamentoDetails(id)));

    final pdfGenerator = PdfGenerator(
      solicitud: solicitud,
      aprendices: aprendices,
      responsables: responsables,
      reglamentos: reglamentos,
    );
    await pdfGenerator.generatePdf();
  }

  void showWorkFlowModal(BuildContext context, SolicitudModel solicitud) async {
    try {
      // Cargar detalles de aprendices
      List<UsuarioAprendizModel> aprendices = await Future.wait(
          solicitud.aprendiz.map((id) => _getAprendizDetails(id)));

      // Cargar detalles de responsables
      List<InstructorModel> responsables = await Future.wait(
          solicitud.responsable.map((id) => _getInstructorDetails(id)));

      // Cargar detalles de reglamentos
      List<ReglamentoModel> reglamentos = await Future.wait(
          solicitud.reglamento.map((id) => _getReglamentoDetails(id)));

      // Abrir el modal con los datos detallados
      _showWorkFlowModalWithDetails(
          context, solicitud, aprendices, responsables, reglamentos);
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar detalles: $e')),
      );
    }
  }

  void _showWorkFlowModalWithDetails(
    BuildContext context,
    SolicitudModel solicitud,
    List<UsuarioAprendizModel> aprendices,
    List<InstructorModel> responsables,
    List<ReglamentoModel> reglamentos,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'WorkFlow',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildLargeWorkFlowStep(
                    context,
                    solicitud.solicitudaceptada,
                    "Enviado",
                    solicitud.solicitudaceptada
                        ? "Fecha Solicitud: ${DateFormat('yyyy-MM-dd').format(solicitud.fechallamadoatencion)}\n"
                            "Instructor/es: ${responsables.map((r) => r.nombres).join(', ')}\n"
                            "Aprendices: ${aprendices.map((a) => a.nombres).join(', ')}"
                        : "El estado 'Enviado' aún no se ha completado.",
                  ),
                  _buildLargeWorkFlowStep(
                    context,
                    solicitud.citacionenviada,
                    "Citado",
                    solicitud.citacionenviada
                        ? "El comité ha sido citado para el día: FECHA"
                        : "Aún no se ha citado el comité",
                  ),
                  _buildLargeWorkFlowStep(
                    context,
                    solicitud.comiteenviado,
                    "Comité",
                    solicitud.comiteenviado
                        ? "El comité se ha realizado exitosamente"
                        : "El comité aún no se ha realizado",
                  ),
                  _buildLargeWorkFlowStep(
                    context,
                    solicitud.planmejoramiento,
                    "Plan",
                    solicitud.planmejoramiento
                        ? "El plan de mejoramiento ya fue calificado"
                        : "El plan de mejoramiento no se ha enviado o no se ha calificado",
                  ),
                  _buildLargeWorkFlowStep(
                    context,
                    solicitud.desicoordinador,
                    "Coordinador",
                    solicitud.desicoordinador
                        ? "Coordinación tomó la siguiente decisión: AAA"
                        : "Coordinación no ha dado respuesta",
                  ),
                  _buildLargeWorkFlowStep(
                    context,
                    solicitud.desiabogada,
                    "Abogado",
                    solicitud.desiabogada
                        ? "La abogada tomó la siguiente decisión: AAA"
                        : "La abogada no ha dado respuesta",
                  ),
                  _buildLargeWorkFlowStep(
                    context,
                    solicitud.finalizado,
                    "Finalizado",
                    solicitud.finalizado
                        ? "El proceso finalizó"
                        : "Aún no finaliza el proceso",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cerrar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLargeWorkFlowStep(
      BuildContext context, bool status, String label, String description) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Círculo
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: status
                      ? [Colors.green, Colors.lightGreenAccent]
                      : [Colors.grey, Colors.black26],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(
                status ? Icons.check : Icons.radio_button_unchecked,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            // Cuadro con el proceso
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: status
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: status ? Colors.green : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: status ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: status
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkFlow(
      List<bool> statuses, List<String> labels, SolicitudModel solicitud,
      {bool isModal = false}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = isModal ? (screenWidth > 400 ? 40.0 : 30.0) : 24.0;
    final double fontSize = isModal ? (screenWidth > 400 ? 16.0 : 14.0) : 12.0;

    return AnimacionSobresaliente(
      scaleFactor: 1.07, // Ajusta el factor de escala
      duration: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors
              .transparent, // Fondo transparente para que el tooltip funcione bien
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(statuses.length, (index) {
            return CustomTooltip(
              message: 'Ver WorkFlow Completo ',
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showWorkFlowModal(context, solicitud); // Llama al modal
                    },
                    child: Icon(
                      statuses[index]
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: statuses[index] ? Colors.green : Colors.grey,
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: TextStyle(fontSize: fontSize, color: Colors.black),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // cantidad de loaders
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1,
      ),
      itemCount: 1, // Número de skeletons que deseas mostrar
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(height: 20, width: 120), // Simula el título
                SizedBox(height: 10),
                SkeletonLoader(
                    height: 15, width: 80), // Simula una línea de descripción
                SizedBox(height: 10),
                SkeletonLoader(
                    height: 15, width: 100), // Simula otra línea de texto
                SizedBox(height: 10),
                SkeletonLoader(
                    height: 15, width: 60), // Simula un dato adicional
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSolicitudesList() {
    return FutureBuilder<List<SolicitudModel>>(
      future: futureSolicitudes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra el Skeleton Loader en lugar del SkeletonLoader
          return _buildSkeletonLoader();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay solicitudes disponibles'));
        } else {
          final solicitudes = snapshot.data!;
          return _buildGrid(solicitudes);
        }
      },
    );
  }

  Widget _buildCardContent(SolicitudModel solicitud, String nombresAprendices,
      List<ReglamentoModel> reglamentos) {
    final academicosCount = reglamentos.where((r) => r.academico).length;
    final disciplinariosCount =
        reglamentos.where((r) => r.disciplinario).length;
    final reglamentoInfo =
        reglamentos.map((a) => '${a.capitulo} ${a.numeral}').join(', ');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            icon: Icons.calendar_today,
            label:
                'Fecha: ${DateFormat('yyyy-MM-dd').format(solicitud.fechallamadoatencion)}',
            isHovered: false,
          ),
          const SizedBox(height: 10),
          _buildRow(
            icon: Icons.numbers,
            label:
                'Ficha: ${aprendices.isNotEmpty ? aprendices[0].ficha : 'No disponible'}',
            isHovered: false,
          ),
          const SizedBox(height: 10),
          Tooltip(
            message: nombresAprendices,
            child: _buildRow(
              icon: Icons.people,
              label: 'Aprendices: ${solicitud.aprendiz.length}',
              isHovered: false,
            ),
          ),
          const SizedBox(height: 10),
          Tooltip(
            message: reglamentoInfo,
            child: _buildRow(
              icon: Icons.book,
              label: 'Reglamentos Académicos: $academicosCount',
              isHovered: false,
            ),
          ),
          const SizedBox(height: 10),
          Tooltip(
            message: reglamentoInfo,
            child: _buildRow(
              icon: Icons.book,
              label: 'Reglamentos Disciplinarios: $disciplinariosCount',
              isHovered: false,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildWorkFlow(
                [
                  solicitud.solicitudaceptada,
                  solicitud.citacionenviada,
                  solicitud.comiteenviado,
                  solicitud.planmejoramiento,
                  solicitud.desicoordinador,
                  solicitud.desiabogada,
                  solicitud.finalizado,
                ],
                ["", "", "", "", "", "", ""],
                solicitud,
                isModal: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center, // Centra los botones en cada fila
            spacing: 12.0, // Espacio horizontal entre los botones
            runSpacing: 12.0, // Espacio vertical entre las filas
            children: [
              _buildButton(
                label: 'Aceptar Comité',
                icon: Icons.check_circle,
                color: Colors.green,
                onPressed: () {
                  _showConfirmationDialog(context, solicitud);
                },
              ),
              _buildButton(
                label: 'Rechazar',
                icon: Icons.cancel,
                color: Colors.red,
                onPressed: () {
                  modalObservaciones(context, solicitud);
                },
              ),
              _buildButton(
                label: 'Descargar Documento',
                icon: Icons.file_download,
                color: Colors.blue,
                onPressed: () async {
                  await _generatePdf(solicitud);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void modalObservaciones(BuildContext context, SolicitudModel solicitud) {
    TextEditingController observacionesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Observaciones'),
          content: TextField(
            controller: observacionesController,
            maxLines: 5,
            decoration:
                const InputDecoration(hintText: "Escribe tu observación aquí"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final observaciones = observacionesController.text.trim();
                if (observaciones.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Por favor, ingresa una observación.")),
                  );
                  return;
                }

                try {
                  // Primero, enviar el correo
                  await enviarCorreoObservaciones(solicitud, observaciones);

                  // Luego, marcar la solicitud como rechazada
                  await rechazarSolicitud(solicitud);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Solicitud rechazada y correo enviado.")),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> rechazarSolicitud(SolicitudModel solicitud) async {
    try {
      // Llamar a la API para marcar la solicitud como rechazada
      await rechazarSolicitudEnBackend(solicitud.id);

      // Actualizar la lista filtrada después del rechazo
      setState(() {
        futureSolicitudes = _loadSolicitudes();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al rechazar la solicitud: $e")),
      );
    }
  }

  Future<void> rechazarSolicitudEnBackend(int solicitudId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/Solicitud/$solicitudId/');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'solicitudrechazada': true}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la solicitud: ${response.body}');
    }
  }

  Future<void> actualizarEstadoSolicitud(SolicitudModel solicitud) async {
    try {
      // Asumiendo que la URL base de la API es correcta
      final url =
          "http://127.0.0.1:8000/api/actualizar-solicitud/${solicitud.id}/";
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'solicitudrechazada': true, // Actualizando el estado
      });

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("Solicitud actualizada correctamente.");
      } else {
        throw Exception("Error al actualizar la solicitud: ${response.body}");
      }
    } catch (e) {
      print("Error al actualizar estado de la solicitud: $e");
      rethrow;
    }
  }

  Future<String?> obtenerCorreoResponsable(int responsableId) async {
    try {
      // Buscar el responsable en la lista de instructores
      final responsable = instructores.firstWhere(
        (instructor) => instructor.id == responsableId,
        orElse: () => throw Exception('Responsable no encontrado'),
      );
      return responsable.correoElectronico;
    } catch (e) {
      print('Error al obtener correo del responsable: $e');
      return null;
    }
  }

  Future<void> enviarCorreoObservaciones(
      SolicitudModel solicitud, String observaciones) async {
    try {
      // ID del responsable
      final responsableId = solicitud.responsable.first;

      // Obtener el correo del responsable
      final correoResponsable = await obtenerCorreoResponsable(responsableId);
      if (correoResponsable == null) {
        throw Exception("No se pudo obtener el correo del responsable.");
      }

      // Filtrar aprendices relacionados con la solicitud
      final aprendicesDeLaSolicitud =
          aprendices.where((a) => solicitud.aprendiz.contains(a.id)).toList();

      // Crear la lista de nombres de los aprendices
      final nombresAprendices = aprendicesDeLaSolicitud
          .map((a) => '${a.nombres} ${a.apellidos}')
          .join(', ');

      // Crear el contenido del correo
      final message = '''
Estimado/a Instructor/a,

Se ha rechazado la solicitud enviada el día: ${DateFormat('yyyy-MM-dd').format(solicitud.fechallamadoatencion)}, dirigida a los aprendices: $nombresAprendices.

Observaciones:
$observaciones

Saludos cordiales.
''';

      // Enviar el correo usando djangoSendEmail
      final service = VerificationService();
      await service.djangoSendEmail2(correoResponsable, message);
      print('Correo enviado correctamente al responsable: $correoResponsable');
    } catch (e) {
      print('Error al enviar correo de observaciones: $e');
      rethrow;
    }
  }

  void _showCoordinationDialog(BuildContext context, SolicitudModel solicitud) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
              '¿Estás seguro de que deseas aceptar esta solicitud para coordinación?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el modal
                await _updateCoordinationStatus(
                    solicitud.id); // Llamar a la función para actualizar
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCoordinationStatus(int solicitudId) async {
    const urlBase = 'http://127.0.0.1:8000/api/Solicitud/';
    final url = Uri.parse('$urlBase$solicitudId/');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'solicitudenviada': false,
          'coordinacionaceptada': true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Éxito: Mostrar un mensaje de confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Solicitud actualizada correctamente para coordinación')),
        );
      } else {
        // Error en la respuesta del servidor
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Error en la conexión o solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showConfirmationDialog(BuildContext context, SolicitudModel solicitud) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
              '¿Estás seguro de que deseas aceptar esta solicitud para citar a comite?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el modal
                await _updateSolicitudStatus(solicitud
                    .id); // Llamar a la función para actualizar el backend
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateSolicitudStatus(int solicitudId) async {
    const urlBase = 'http://127.0.0.1:8000/api/Solicitud/';
    final url = Uri.parse('$urlBase$solicitudId/');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'solicitudenviada': false,
          'solicitudaceptada': true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Éxito: Realizar acciones adicionales si es necesario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud actualizada correctamente')),
        );
      } else {
        // Error en la respuesta del servidor
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Error en la conexión o solicitud
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    required bool isHovered,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            color: isHovered
                ? const Color.fromARGB(255, 17, 120, 255)
                : const Color.fromARGB(255, 1, 187, 10)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 17,
              color: isHovered ? primaryColor : textosOscuros,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AnimacionSobresaliente(
      scaleFactor: 1.09,
      child: Flexible(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            side: BorderSide(color: color, width: 2),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Ajusta el tamaño del Row al contenido
            children: [
              Icon(icon, color: Colors.white, size: 20), // Ícono
              const SizedBox(width: 8), // Espacio entre el ícono y el texto
              Text(label, style: const TextStyle(color: Colors.white)), // Texto
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const SkeletonLoader({
    super.key,
    this.height = 20.0,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

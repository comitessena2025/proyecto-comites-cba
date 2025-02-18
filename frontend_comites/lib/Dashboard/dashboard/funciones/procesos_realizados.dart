// ignore_for_file: use_build_context_synchronously, use_full_hex_values_for_flutter_colors

import 'package:comites/Models/AprendizModel.dart';
import 'package:comites/Models/ReglamentoModel.dart';
import 'package:comites/Models/instructormodel.dart';
import 'package:comites/Widgets/Cards.dart';
import 'package:comites/Widgets/animacionSobresaliente.dart';
import 'package:comites/Widgets/tooltip.dart';
import 'package:comites/constantsDesign.dart';
import 'package:comites/pdf/generar_pdf.dart';
import 'package:comites/source.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comites/Models/SolicitudModel.dart';
import 'package:comites/provider.dart'; // El archivo donde está AppState y la función getSolicitudesByUser
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ProcesosRealizados extends StatefulWidget {
  const ProcesosRealizados({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProcesosRealizadosState createState() => _ProcesosRealizadosState();
}

class _ProcesosRealizadosState extends State<ProcesosRealizados> {
  late Future<List<SolicitudModel>> futureSolicitudes;

  @override
  void initState() {
    super.initState();
    _loadSolicitudes();
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
                    "Aceptada",
                    solicitud.solicitudaceptada
                        ? "Fecha Solicitud: ${DateFormat('yyyy-MM-dd').format(solicitud.fechallamadoatencion)}\n"
                            "Instructor/es: ${responsables.map((r) => r.nombres).join(', ')}\n"
                            "Aprendices: ${aprendices.map((a) => a.nombres).join(', ')}"
                        : "La solicitud aun no se ha aceptado, debes esperar la respuesta de la coordinación",
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

  Future<void> _loadSolicitudes() async {
    final userId = Provider.of<AppState>(context, listen: false).userId;
    if (userId != null) {
      setState(() {
        futureSolicitudes = getSolicitudesByUser(userId);
      });
    } else {
      setState(() {
        futureSolicitudes = Future.error('Usuario no autenticado');
      });
    }
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

  int _selectedOption = 0; // Variable para almacenar la opción seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Contenedor para un DropdownButton estilizado con un ancho del 40%
          Container(
            width: MediaQuery.of(context).size.width *
                0.2, // 40% del ancho de la pantalla
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Fondo del contenedor
              borderRadius: BorderRadius.circular(30.0), // Bordes redondeados
            ),
            child: DropdownButton<int>(
              value: _selectedOption,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedOption = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(value: 0, child: Text("Procesos Activos")),
                DropdownMenuItem(value: 1, child: Text("Procesos Cancelados")),
                DropdownMenuItem(value: 2, child: Text("Procesos Finalizados")),
              ],
              isExpanded:
                  true, // Para hacer que ocupe todo el ancho disponible dentro del contenedor
              dropdownColor: Colors.blueAccent, // Color de fondo del dropdown
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.white), // Icono de dropdown
              style: const TextStyle(
                  color: Colors.white, fontSize: 20), // Color del texto
              underline: const SizedBox(), // Elimina la línea inferior
            ),
          ),

          const SizedBox(height: 30),
          Expanded(child: _buildSolicitudesList()),
        ],
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
      future:
          _getSolicitudesPorCategoria(), // Nueva función que retorna las solicitudes según la categoría
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Aquí podrías poner un loading spinner o un skeleton loader
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Mostrar mensaje si no hay solicitudes
          return const Center(
              child: Text('Aún no hay solicitudes para el área seleccionada'));
        } else {
          final solicitudes = snapshot.data!;
          return _buildGrid(solicitudes);
        }
      },
    );
  }

// Función que obtiene las solicitudes filtradas según la categoría seleccionada
  Future<List<SolicitudModel>> _getSolicitudesPorCategoria() async {
    final userId = Provider.of<AppState>(context, listen: false)
        .userId; // Obtener el ID del instructor logueado

    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final todasLasSolicitudes =
        await getSolicitud(); // Asumo que esta es la lista completa de solicitudes

    List<SolicitudModel> solicitudesFiltradas = [];

    // Filtramos por las solicitudes del instructor actual
    solicitudesFiltradas = todasLasSolicitudes
        .where((solicitud) => solicitud.responsable.contains(
                userId) // Filtramos por el ID del instructor que realizó la solicitud
            )
        .toList();

    // Luego aplicamos el filtro por estado (activos, cancelados, finalizados)
    switch (_selectedOption) {
      case 0: // Procesos Activos
        solicitudesFiltradas = solicitudesFiltradas
            .where((solicitud) =>
                !solicitud.solicitudrechazada && !solicitud.finalizado)
            .toList();
        break;
      case 1: // Procesos Cancelados
        solicitudesFiltradas = solicitudesFiltradas
            .where((solicitud) => solicitud.solicitudrechazada)
            .toList();
        break;
      case 2: // Procesos Finalizados
        solicitudesFiltradas = solicitudesFiltradas
            .where((solicitud) => solicitud.finalizado)
            .toList();
        break;
      default:
        break;
    }

    return solicitudesFiltradas;
  }

  //Construye la cuadricula de cada card, tomando el tamaño de la pantalla
  //Para asi mostrar cierta cantidad de cards segun el tamaño de la pantalla
  //Construye la cuadricula de cada card, tomando el tamaño de la pantalla
  //Para asi mostrar cierta cantidad de cards segun el tamaño de la pantalla
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

// Extracted card content builder for reuse
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
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

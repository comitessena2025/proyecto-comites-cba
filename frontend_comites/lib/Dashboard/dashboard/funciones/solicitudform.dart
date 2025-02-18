// ignore_for_file: use_build_context_synchronously, must_be_immutable, library_private_types_in_public_api, unnecessary_null_comparison, unused_local_variable, collection_methods_unrelated_type

import 'package:comites/Auth/source/verification.dart';
import 'package:comites/Dashboard/main/Main_Funciones/main_comitenormal_directo.dart';
import 'package:comites/Models/AprendizModel.dart';
import 'package:comites/Models/ReglamentoModel.dart';
import 'package:comites/Models/SolicitudModel.dart';
import 'package:comites/Models/instructormodel.dart';
import 'package:comites/constantsDesign.dart';
import 'package:comites/pdf/generar_pdf.dart';
import 'package:comites/pdf/pdfcorreo.dart';
import 'package:comites/provider.dart';
import 'package:comites/source.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart' as provider;

import 'package:supabase_flutter/supabase_flutter.dart';

class SolicitudForm extends StatefulWidget {
  const SolicitudForm({super.key});

  @override
  _SolicitudFormState createState() => _SolicitudFormState();
}

class _SolicitudFormState extends State<SolicitudForm> {
  int faseActual = 1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController descripcion = TextEditingController();
  TextEditingController fichaController = TextEditingController();
  TextEditingController observaciones = TextEditingController();
  List<InstructorModel> usuario = [];
  List<UsuarioAprendizModel> usuariosAprendiz = [];
  List<UsuarioAprendizModel> _filteredAprendices = [];
  List<String> fichas = [];
  String fichaSeleccionada = '';
  List<ReglamentoModel> reglamentos = [];
  List<UsuarioAprendizModel> aprendicesSeleccionados = [];

  List<String> reglamentosSeleccionados = [];
  List<InstructorModel> usuariosSeleccionados = [];
  String usuarioNombre = '';
  PlatformFile? archivoSeleccionado;
  List<PlatformFile?> archivosSeleccionados = List.generate(4, (_) => null);

  void continuar() {
    if (faseActual == 1 && aprendicesSeleccionados.isNotEmpty) {
      setState(() {
        faseActual = 2;
      });
    } else if (faseActual == 2 &&
        descripcion.text.isNotEmpty &&
        observaciones.text.isNotEmpty) {
      setState(() {
        faseActual = 3;
      });
    } else if (faseActual == 3 && reglamentosSeleccionados.isNotEmpty) {
      setState(() {
        faseActual = 4;
      });
    } else if (faseActual == 4 && usuariosSeleccionados.isNotEmpty) {
      setState(() {
        faseActual = 5;
      });
    } else if (faseActual == 5 && archivosSeleccionados != null) {
      _mostrarModalConfirmacion(); // Modal para confirmar y enviar el formulario
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
    }
  }

  void _mostrarModalConfirmacion() async {
    // Filtrar los reglamentos seleccionados basados en sus IDs
    List<ReglamentoModel> reglamentosSeleccionadosCompletos = reglamentos
        .where((reglamento) =>
            reglamentosSeleccionados.contains(reglamento.id.toString()))
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                'Confirmar Envío',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionTitle('Ficha'),
                _buildSectionContent(
                  aprendicesSeleccionados.isNotEmpty
                      ? aprendicesSeleccionados[0].ficha
                      : 'No disponible',
                ),
                _buildSectionTitle('Aprendices'),
                _buildSectionContent(
                  aprendicesSeleccionados
                      .map((aprendiz) =>
                          '${aprendiz.nombres} ${aprendiz.apellidos}')
                      .join(', '),
                ),
                _buildSectionTitle('Instructores'),
                _buildSectionContent(
                  usuariosSeleccionados
                      .map((usuario) =>
                          '${usuario.nombres} ${usuario.apellidos}')
                      .join(', '),
                ),
                _buildSectionTitle('Reglamentos'),
                _buildSectionContent(
                  'Numeral: ${reglamentosSeleccionadosCompletos.map((reglamento) => reglamento.numeral).join(', ')}',
                ),
                _buildSectionTitle('Detalles de la Solicitud'),
                _buildSectionContent(
                  'Descripción de la falta: ${descripcion.text}',
                ),
                _buildSectionContent(
                  'Observaciones: ${observaciones.text}',
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitForm();
              },
            ),
          ],
        );
      },
    );
  }

// Métodos auxiliares para simplificar el diseño
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  void volver() {
    if (faseActual > 1) {
      setState(() {
        faseActual--; // Retrocede a la fase anterior
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya estás en la primera fase')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    descripcion = TextEditingController();
    observaciones = TextEditingController();
    _fetchAprendices();
    _fetchReglamentos();
    _getUsuarioLogueado();
    _filteredAprendices = usuariosAprendiz;
  }

  @override
  void dispose() {
    descripcion.dispose();
    fichaController.dispose();
    observaciones.dispose();
    super.dispose();
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

  // Filtra los aprendices en base a la ficha seleccionada
  void _filterAprendicesPorFicha(String ficha) {
    setState(() {
      _filteredAprendices = usuariosAprendiz.where((aprendiz) {
        return aprendiz.ficha == ficha && aprendiz.llamadoatencionaprendiz >= 2;
      }).toList();
    });
  }

  // Obtiene todas las fichas de los aprendices y almacena la lista de fichas
  Future<void> _fetchAprendices() async {
    final response =
        await http.get(Uri.parse('$sourceApi/api/UsuarioAprendiz/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        usuariosAprendiz =
            data.map((item) => UsuarioAprendizModel.fromJson(item)).toList();
        fichas = usuariosAprendiz
            .map((e) => e.ficha)
            .toSet()
            .toList(); // Obtener fichas únicas
      });
    } else {
      throw Exception('Error al cargar aprendices');
    }
  }

  Future<void> _fetchReglamentos() async {
    try {
      final response = await http.get(Uri.parse('$sourceApi/api/Reglamento/'));
      if (response.statusCode == 200) {
        // Trabajar directamente con response.body sin decodificación UTF-8
        List<dynamic> data = json.decode(response.body);

        setState(() {
          reglamentos =
              data.map((item) => ReglamentoModel.fromJson(item)).toList();
        });
      } else {
        throw Exception('Error al cargar reglamentos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en al cargar reglamentos: $e');
      // Manejar el error aquí, como mostrar un mensaje al usuario
    }
  }

  Future<void> _getUsuarioLogueado() async {
    // Obtén el usuario autenticado desde el AppState
    final appState = provider.Provider.of<AppState>(context, listen: false);
    final usuarioLogueado = appState.usuarioAutenticado;

    // Verifica si hay un usuario logueado
    if (usuarioLogueado != null) {
      setState(() {
        usuarioNombre =
            '${usuarioLogueado.nombres} ${usuarioLogueado.apellidos}'; // Asignar nombre completo del usuario logueado
      });
    }
  }

  // Método para enviar la solicitud con el archivo
  Future<void> _sendSolicitud() async {
    final appState = provider.Provider.of<AppState>(context, listen: false);
    final usuarioLogueado = appState.usuarioAutenticado;
    List<int> selectedAprendicesIds =
        aprendicesSeleccionados.map((aprendiz) => aprendiz.id).toList();
    List<String> selectedReglamentosIds =
        reglamentosSeleccionados.map((id) => id.toString()).toList();
    final descripciontotal = descripcion.text;
    final observacionestotal = observaciones.text;

    if (usuarioLogueado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: No se pudo identificar al usuario logueado.'),
      ));
      return;
    }

    if (aprendicesSeleccionados.isEmpty || reglamentosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Por favor, selecciona al menos un aprendiz y un reglamento.'),
      ));
      return;
    }

    if (descripcion.text.isEmpty || observaciones.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos.')),
      );
      return;
    }

    // Continuar con la lógica para subir el archivo y enviar la solicitud...
    final supabase = Supabase.instance.client;
    List<String?> publicUrls = List.generate(4, (_) => null);

    for (int i = 0; i < archivosSeleccionados.length; i++) {
      final archivo = archivosSeleccionados[i];
      if (archivo != null &&
          archivo.bytes != null &&
          archivo.extension == 'pdf') {
        try {
          final fileName = archivo.name
              .replaceAll(RegExp(r'\s+'), '_')
              .replaceAll(RegExp(r'[^a-zA-Z0-9_\.]'), '');
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final filePath =
              'solicitudes/solicitud_${timestamp}${i + 1}$fileName';

          // Subir el archivo a Supabase
          final uploadResponse = await supabase.storage
              .from('uploads')
              .uploadBinary(filePath, archivo.bytes!);

          if (uploadResponse.error == null) {
            // Obtener la URL pública del archivo
            final publicUrlResponse =
                supabase.storage.from('uploads').getPublicUrl(filePath);

            if (publicUrlResponse.error == null) {
              publicUrls[i] = publicUrlResponse.data;
              print(
                  'Archivo ${i + 1} subido correctamente. URL pública: ${publicUrls[i]}');
            } else {
              print(
                  'Error al obtener URL pública del archivo ${i + 1}: ${publicUrlResponse.error!.message}');
            }
          } else {
            print(
                'Error al subir archivo ${i + 1}: ${uploadResponse.error!.message}');
          }
        } catch (e) {
          print('Error inesperado al subir archivo ${i + 1}: $e');
        }
      }
    }

    // Validar que al menos un archivo fue subido correctamente
    if (publicUrls.every((url) => url == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor sube al menos un archivo válido.')),
      );
      return;
    }

    // Crear el JSON de la solicitud
    final jsonSolicitud = jsonEncode({
      'descripcion': descripciontotal,
      'observaciones': observacionestotal,
      'aprendiz': selectedAprendicesIds,
      'responsable': [
        usuarioLogueado.id.toString(),
        ...usuariosSeleccionados.map((usuario) => usuario.id.toString())
      ],
      'reglamento': selectedReglamentosIds,
      'name_fildsolicitud1': archivosSeleccionados[0]?.name,
      'filesolicitud1': publicUrls[0],
      'name_fildsolicitud2': archivosSeleccionados[1]?.name,
      'filesolicitud2': publicUrls[1],
      'name_fildsolicitud3': archivosSeleccionados[2]?.name,
      'filesolicitud3': publicUrls[2],
      'name_fildsolicitud4': archivosSeleccionados[3]?.name,
      'filesolicitud4': publicUrls[3],
    });

    // Mostrar JSON en consola
    print('JSON enviado al backend: $jsonSolicitud');

    // Enviar la solicitud al backend
    final response = await http.post(
      Uri.parse('$sourceApi/api/Solicitud/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonSolicitud,
    );

    if (response.statusCode == 201) {
      // Lógica de éxito
      print('Solicitud enviada correctamente.');

      // Obtener el instructor (usuario logueado)
      final instructor = usuarioLogueado;

      // Crear el modelo de la solicitud a partir de la respuesta del backend (si es necesario)
      final solicitudEnviada = SolicitudModel(
        id: jsonDecode(response.body)['id'],
        descripcion: descripciontotal,
        observaciones: observacionestotal,
        fechallamadoatencion: DateTime.now(),
        aprendiz: selectedAprendicesIds,
        responsable: [
          usuarioLogueado.id.toInt(),
          ...usuariosSeleccionados.map((usuario) => usuario.id.toInt())
        ],
        reglamento: reglamentosSeleccionados,
        solicitudenviada: true,
        solicitudaceptada: false,
        coordinacionaceptada: false,
        solicitudrechazada: false,
        citacionenviada: false,
        comiteenviado: false,
        planmejoramiento: false,
        pmsubidoaprendiz: false,
        pmsubidoinstructor: false,
        desicoordinador: false,
        desiabogada: false,
        finalizado: false,
        name_fildsolicitud1: "",
        filesolicitud1: "",
        name_fildsolicitud2: "",
        filesolicitud2: "",
        name_fildsolicitud3: "",
        filesolicitud3: "",
        name_fildsolicitud4: "",
        filesolicitud4: "",
      );

      // Enviar el correo de confirmación al instructor
      await enviarCorreoConfirmacionSolicitud(solicitudEnviada, instructor);
      _showSolicitudDetails();
      // Reiniciar el formulario
      _resetform();
    } else {
      print('Error al enviar la solicitud: ${response.reasonPhrase}');
    }
  }

  //ENVIAR FORMULARIO
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _sendSolicitud();
      _resetform();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos. ')),
      );
    }
  }

  Future<void> enviarCorreoConfirmacionSolicitud(
      SolicitudModel solicitud, InstructorModel instructor) async {
    try {
      // Verificar si 'solicitud' o 'instructor' son nulos
      if (solicitud == null || instructor == null) {
        throw ArgumentError(
            "La solicitud o el instructor no pueden ser nulos.");
      }

      // Verificar si 'solicitud.aprendiz' es una lista y si no está vacía
      if (solicitud.aprendiz == null || solicitud.aprendiz.isEmpty) {
        print("No hay aprendices asociados a esta solicitud.");
        return; // O puedes devolver un mensaje de error, según el flujo de tu aplicación
      }

      // Si 'solicitud.aprendiz' es una lista, generar el string con los aprendices

      // Generar el contenido del correo
      final message = '''
Estimado/a ${instructor.nombres} ${instructor.apellidos},

La solicitud con los siguientes detalles ha sido enviada correctamente:

- Fecha de la solicitud: ${DateFormat('yyyy-MM-dd').format(solicitud.fechallamadoatencion)}
- Descripción: ${solicitud.descripcion}
- Observaciones: ${solicitud.observaciones}
- Aprendices involucrados: $aprendicesSeleccionados

Saludos cordiales,
El equipo del sistema.
''';

      // Generar los detalles de los aprendices, responsables y reglamentos

      // Generar el PDF
      final pdfBytes = await generatePdfBytes(solicitud,
          aprendicesSeleccionados, usuariosSeleccionados, reglamentos);

      // Codificar el archivo PDF en base64
      final base64Pdf = base64Encode(Uint8List.fromList(pdfBytes));

      // Enviar el correo usando djangoSendEmail3
      final service = VerificationService();
      await service.djangoSendEmail3(
        instructor.correoElectronico,
        message,
        base64Pdf, // Pasar el PDF como base64
      );
    } catch (e, stackTrace) {
      print('Error al enviar el correo de confirmación: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  void _resetform() {
    setState(() {
      descripcion.clear();
      fichaController.clear();
      observaciones.clear();
      aprendicesSeleccionados.clear();
      reglamentosSeleccionados.clear();
      usuariosSeleccionados.clear();

      faseActual = 1;
    });
  }

  //AL ENVIAR LA SOLICITUD SE MUESTRAN LOS DETALLES DE LA SOLICITUD
  void _showSolicitudDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Solicitud Enviada'),
          content: const Text('La solicitud ha sido enviada exitosamente.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                // Cierra el modal
                Navigator.of(context).pop();
                // Limpia los campos del formulario después de cerrar el diálogo
                _resetform();
              },
            ),
          ],
        );
      },
    );
  }

  //GUARDA EL ID DE LOS REGLAMENTOS SELECCIONADOS PARA LA SOLICITUD
  Future<void> _selectReglamentos(BuildContext context) async {
    final List<String> capitulos = [
      'Capitulo III DEBERES DEL APRENDIZ SENA',
      'Capitulo IV PROHIBICIONES',
    ];

    String? capituloSeleccionado = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecciona un capítulo'),
          content: DropdownButtonFormField<String>(
            value: capitulos.first,
            items: capitulos.map((capitulo) {
              return DropdownMenuItem<String>(
                value: capitulo,
                child: Text(capitulo),
              );
            }).toList(),
            dropdownColor: Colors.grey[200],
            onChanged: (value) {
              Navigator.of(context).pop(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (capituloSeleccionado != null) {
      List<ReglamentoModel> reglamentosFiltrados = reglamentos
          .where((reglamento) => reglamento.capitulo == capituloSeleccionado)
          .toList();

      List<ReglamentoModel> reglamentosAcademicos = reglamentosFiltrados
          .where((reglamento) => reglamento.academico)
          .toList();
      List<ReglamentoModel> reglamentosDisciplinarios = reglamentosFiltrados
          .where((reglamento) => reglamento.disciplinario)
          .toList();

      if (reglamentosFiltrados.isEmpty) {
        await showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('No hay reglamentos'),
              content: const Text(
                  'No se encontraron reglamentos para el capítulo seleccionado.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      final result = await showDialog<List<String>>(
        context: context,
        builder: (context) {
          List<String> reglamentosTempSeleccionados =
              List.from(reglamentosSeleccionados);

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Selecciona Reglamentos'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (reglamentosAcademicos.isNotEmpty) ...[
                        const Text('Académicos',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...reglamentosAcademicos.map((reglamento) {
                          return CheckboxListTile(
                            title: Text(
                                '${reglamento.numeral}: ${reglamento.descripcion}'),
                            value: reglamentosTempSeleccionados
                                .contains(reglamento.id.toString()),
                            activeColor: Colors.green,
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  reglamentosTempSeleccionados
                                      .add(reglamento.id.toString());
                                } else {
                                  reglamentosTempSeleccionados
                                      .remove(reglamento.id.toString());
                                }
                              });
                            },
                          );
                        })
                      ],
                      if (reglamentosDisciplinarios.isNotEmpty) ...[
                        const Text('Disciplinarios',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...reglamentosDisciplinarios.map((reglamento) {
                          return CheckboxListTile(
                            title: Text(
                                '${reglamento.numeral}: ${reglamento.descripcion}'),
                            value: reglamentosTempSeleccionados
                                .contains(reglamento.id.toString()),
                            activeColor: Colors.green,
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  reglamentosTempSeleccionados
                                      .add(reglamento.id.toString());
                                } else {
                                  reglamentosTempSeleccionados
                                      .remove(reglamento.id.toString());
                                }
                              });
                            },
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop(reglamentosTempSeleccionados);
                    },
                  ),
                ],
              );
            },
          );
        },
      );

      if (result != null) {
        setState(() {
          reglamentosSeleccionados = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidthFactor = screenWidth < 600 ? 0.9 : 0.7;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: FractionallySizedBox(
              widthFactor: formWidthFactor,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Progreso visual con Stepper
                    _buildIndicadorPasos(),

                    const SizedBox(height: 20),

                    // Mostrar los campos de acuerdo a la fase actual
                    _buildSection(
                      number: 1,
                      title: 'Digita el número de ficha y escoge al aprendiz',
                      isCompleted: faseActual > 1,
                      isActive: faseActual == 1,
                      child: _buildFichaAndAprendicesContainer(),
                    ),

                    if (faseActual >= 2)
                      _buildSection(
                        number: 2,
                        title: 'Describe la falta y danos tu observación',
                        isCompleted: faseActual > 2,
                        isActive: faseActual == 2,
                        child: _buildDescripcionFaltaContainer(),
                      ),

                    if (faseActual >= 3)
                      _buildSection(
                        number: 3,
                        title: 'Selecciona el reglamento incumplido',
                        isCompleted: faseActual > 3,
                        isActive: faseActual == 3,
                        child: _buildReglamentoContainer(),
                      ),

                    if (faseActual >= 4)
                      _buildSection(
                        number: 4,
                        title: 'Instructores que realizan la solicitud',
                        isCompleted:
                            faseActual == 4 && usuariosSeleccionados.isNotEmpty,
                        isActive: faseActual == 4,
                        child: _buildUsuariosContainer(),
                      ),

                    if (faseActual >= 5)
                      _buildSection(
                        number: 5,
                        title: 'Sube un archivo relacionado',
                        isCompleted:
                            faseActual == 5 && archivoSeleccionado != null,
                        isActive: faseActual == 5,
                        child: _buildSubirArchivosContainer(),
                      ),

                    const SizedBox(height: 20),

                    // Botón de Continuar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón "Volver"
                        ElevatedButton(
                          onPressed: volver,
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red, // Color del texto
                            shadowColor: Colors.grey.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Volver',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Botón con gradiente
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.5),
                                offset: const Offset(0, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: continuar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              faseActual < 5 ? 'Continuar' : 'Enviar Solicitud',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Nuevo botón para abrir ComiteDirecto
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MainComitenormal_Directo()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Comite Directo'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Widget para mostrar un título de sección con un check o indicador de progreso
  Widget _buildSection({
    required int number,
    required String title,
    required bool isCompleted,
    required bool isActive,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[200]),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: isCompleted || isActive
            ? () {
                setState(() {
                  faseActual =
                      number; // Cambia a la fase del número correspondiente
                });
              }
            : null, // No permite hacer clic si no ha sido completado
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle
                          : isActive
                              ? Icons
                                  .radio_button_on // Icono de progreso activo
                              : Icons.circle,
                      color: isCompleted
                          ? Colors.green
                          : isActive
                              ? Colors.orange[300] // Color de progreso activo
                              : Colors.blueAccent,
                      size: 35.0,
                    ),
                    if (!isCompleted && !isActive)
                      Text(
                        '$number',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!isCompleted || isActive) child,
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Indicador de progreso visual de las fases
  Widget _buildIndicadorPasos() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(40),
          color: Colors.grey[200]),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStepProgressIndicator(1, faseActual > 1, faseActual == 1),
          _buildStepProgressIndicator(2, faseActual > 2, faseActual == 2),
          _buildStepProgressIndicator(3, faseActual > 3, faseActual == 3),
          _buildStepProgressIndicator(4, faseActual > 4, faseActual == 4),
          _buildStepProgressIndicator(5, faseActual > 5, faseActual == 5),
        ],
      ),
    );
  }

  // Método para construir el contenedor con el botón de subir archivo
  Widget _buildSubirArchivosContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sube hasta 4 archivos relacionados (mínimo 1 es obligatorio)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...List.generate(4, (index) => _buildArchivoUploader(index)),
          const SizedBox(height: 10),
          // El botón fue eliminado, y `_sendSolicitud` queda como función aparte.
        ],
      ),
    );
  }

  Widget _buildArchivoUploader(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            // Lógica para seleccionar el archivo
            final archivo = await _seleccionarArchivo();
            if (archivo != null) {
              setState(() {
                archivosSeleccionados[index] = archivo;
              });
            }
          },
          icon: const Icon(Icons.upload_file),
          label: Text('Seleccionar Archivo ${index + 1}'),
        ),
        const SizedBox(height: 10),
        if (archivosSeleccionados[index] != null)
          Text(
            'Archivo ${index + 1} seleccionado: ${_getArchivoNombre(archivosSeleccionados[index]!)}',
            style: const TextStyle(color: Colors.green),
          ),
      ],
    );
  }

// Función para obtener el nombre del archivo según la plataforma
  String _getArchivoNombre(PlatformFile archivo) {
    if (kIsWeb) {
      // En la web, solo tenemos acceso al nombre del archivo
      return archivo.name;
    } else {
      // En otras plataformas, usamos el path para obtener el nombre
      return archivo.path?.split('/').last ?? archivo.name;
    }
  }

// Método para seleccionar archivo y convertir a File de dart:io
  Future<PlatformFile?> _seleccionarArchivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    return result?.files.first;
  }

  // Widget auxiliar para crear los pasos del indicador
  Widget _buildStepProgressIndicator(
      int stepNumber, bool isCompleted, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isCompleted
              ? Colors.green
              : isActive
                  ? Colors.orange[300] // Indicador del paso en progreso
                  : Colors.grey,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white)
              : isActive
                  ? const Icon(Icons.radio_button_on, color: Colors.white)
                  : Text(
                      '$stepNumber',
                      style: const TextStyle(color: Colors.white),
                    ),
        ),
        const SizedBox(height: 8),
        Text(
          'Paso $stepNumber',
          style: TextStyle(
            color: isCompleted
                ? Colors.green
                : isActive
                    ? Colors.orange[300] // Texto del paso en progreso
                    : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFichaAndAprendicesContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              // Filtrar fichas en base a lo que se va digitando
              return fichas.where((ficha) {
                return ficha.contains(textEditingValue.text);
              });
            },
            onSelected: (String selectedFicha) {
              setState(() {
                fichaSeleccionada = selectedFicha;
              });
              _filterAprendicesPorFicha(
                  selectedFicha); // Filtrar aprendices por ficha seleccionada
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                controller: fieldTextEditingController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Número de Ficha',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el número de ficha';
                  }
                  return null;
                },
              );
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width:
                            constraints.maxWidth, // Igualar el ancho del input
                        constraints: const BoxConstraints(
                            maxHeight: 200,
                            maxWidth:
                                150 // Limitar el alto máximo (aproximadamente 5 elementos)
                            ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Fondo gris claro
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(
                                  option,
                                  style: const TextStyle(color: primaryColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),

          // Mostrar los aprendices filtrados
          SizedBox(
            width: double.infinity,
            height: _filteredAprendices.isNotEmpty
                ? 400
                : null, // Si hay datos, usa 400, si no, sin altura fija
            child: _filteredAprendices.isNotEmpty
                ? SingleChildScrollView(
                    scrollDirection:
                        Axis.vertical, // Permite el scroll vertical
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Mantiene el scroll horizontal
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Apellido')),
                          DataColumn(label: Text('Documento')),
                          DataColumn(label: Text('Programa')),
                        ],
                        rows: _filteredAprendices.map((aprendiz) {
                          final bool isSelected =
                              aprendicesSeleccionados.contains(aprendiz);
                          return DataRow(
                            selected: isSelected,
                            onSelectChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  aprendicesSeleccionados.add(aprendiz);
                                } else {
                                  aprendicesSeleccionados.remove(aprendiz);
                                }
                              });
                            },
                            cells: [
                              DataCell(Text(aprendiz.nombres)),
                              DataCell(Text(aprendiz.apellidos)),
                              DataCell(Text(aprendiz.numeroDocumento)),
                              DataCell(Text(aprendiz.programa)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                        'Digita una ficha')), // Mostrar mensaje cuando no hay datos
          ),
        ],
      ),
    );
  }

  Widget _buildDescripcionFaltaContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller: descripcion,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Descripción de la Falta',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese la descripción de la falta';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller: observaciones,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese observaciones, en caso de no tenerlas escriba "Ninguna"';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReglamentoContainer() {
    // Dividimos los reglamentos en dos listas: académicos y disciplinarios
    List<ReglamentoModel> reglamentosAcademicos =
        reglamentos.where((reglamento) => reglamento.academico).toList();

    List<ReglamentoModel> reglamentosDisciplinarios =
        reglamentos.where((reglamento) => reglamento.disciplinario).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () => _selectReglamentos(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                child: Text(
                  reglamentosSeleccionados.isEmpty
                      ? 'Selecciona Reglamentos'
                      : reglamentosSeleccionados.length == 1
                          ? '1 reglamento seleccionado'
                          : '${reglamentosSeleccionados.length} reglamentos seleccionados',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Título de académicos y tabla de reglamentos académicos
          if (reglamentosAcademicos.isNotEmpty) ...[
            const Text(
              'Académicos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            _buildReglamentoTable(reglamentosAcademicos),
          ],
          const SizedBox(height: 10),
          // Título de disciplinarios y tabla de reglamentos disciplinarios
          if (reglamentosDisciplinarios.isNotEmpty) ...[
            const Text(
              'Disciplinarios',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            _buildReglamentoTable(reglamentosDisciplinarios),
          ],
        ],
      ),
    );
  }

// Función auxiliar para crear la tabla de reglamentos
  Widget _buildReglamentoTable(List<ReglamentoModel> reglamentosFiltrados) {
    final filteredData = reglamentosFiltrados
        .where((reglamento) =>
            reglamentosSeleccionados.contains(reglamento.id.toString()))
        .toList();

    return filteredData.isNotEmpty
        ? ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 400, // Límite de altura de la tabla
            ),
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.vertical, // Habilita scroll vertical al llegar a 400px
              child: SingleChildScrollView(
                scrollDirection: Axis
                    .horizontal, // Habilita scroll horizontal si es necesario
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Capítulo')),
                    DataColumn(label: Text('Numeral')),
                    DataColumn(label: Text('Descripción')),
                    DataColumn(label: Text('Tipo')),
                  ],
                  rows: filteredData.map((reglamento) {
                    return DataRow(cells: [
                      DataCell(Text(reglamento.capitulo.toString())),
                      DataCell(Text(reglamento.numeral.toString())),
                      DataCell(Text(reglamento.descripcion)),
                      DataCell(Text(reglamento.tipoFalta)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          )
        : const Center(child: Text('No hay reglamentos seleccionados'));
  }

  Widget _buildUsuariosContainer() {
    final usuarioAutenticado = context.read<AppState>().usuarioAutenticado;

    if (!usuariosSeleccionados.contains(usuarioAutenticado)) {
      usuariosSeleccionados.add(usuarioAutenticado);
    }

    final filteredData = instructor
        .where((usuario) => usuariosSeleccionados.contains(usuario))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showSearchDialog(context),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                usuariosSeleccionados.isEmpty
                    ? 'Buscar Instructores'
                    : usuariosSeleccionados.length == 1
                        ? '1 instructor seleccionado'
                        : '${usuariosSeleccionados.length} instructores seleccionados',
              ),
            ),
          ),
          const SizedBox(height: 10),
          filteredData.isNotEmpty
              ? ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Apellido')),
                          DataColumn(label: Text('Correo')),
                        ],
                        rows: filteredData.map((usuario) {
                          final bool isSelected =
                              usuariosSeleccionados.contains(usuario);
                          return DataRow(
                            selected: isSelected,
                            onSelectChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  usuariosSeleccionados.add(usuario);
                                } else {
                                  usuariosSeleccionados.remove(usuario);
                                }
                              });
                            },
                            cells: [
                              DataCell(Text(usuario.nombres)),
                              DataCell(Text(usuario.apellidos)),
                              DataCell(Text(usuario.correoElectronico)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('No hay instructores seleccionados')),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Buscar Instructores'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          // Filtrar la lista de instructores basado en el texto de búsqueda
                          _filteredInstructors = instructor
                              .where((usuario) =>
                                  usuario.nombres
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  usuario.apellidos
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Buscar por nombre o apellido',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredInstructors.length,
                        itemBuilder: (context, index) {
                          final usuario = _filteredInstructors[index];
                          final bool isSelected =
                              usuariosSeleccionados.contains(usuario);
                          return CheckboxListTile(
                            title:
                                Text('${usuario.nombres} ${usuario.apellidos}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(usuario.correoElectronico),
                                Text('Coordinación: ${usuario.coordinacion}'),
                              ],
                            ),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  usuariosSeleccionados.add(usuario);
                                } else {
                                  usuariosSeleccionados.remove(usuario);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Actualizar el widget principal cuando se cierra el diálogo
      setState(() {});
    });
  }

// Variable para almacenar los resultados filtrados de la búsqueda
  List<InstructorModel> _filteredInstructors = [];

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10.0,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<MultiSelectItem<String>> items;
  final List<String> initialSelectedValues;

  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.initialSelectedValues,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<MultiSelectItem<String>> items;

  @override
  void initState() {
    super.initState();
    items = widget.items.map((item) {
      return MultiSelectItem<String>(
        value: item.value,
        label: item.label,
        isSelected: widget.initialSelectedValues.contains(item.value),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecciona'),
      content: SingleChildScrollView(
        child: Column(
          children: items,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Aceptar'),
          onPressed: () {
            List<String> selectedValues = items
                .where((item) => item.isSelected)
                .map((item) => item.value)
                .toList();
            Navigator.of(context).pop(selectedValues);
          },
        ),
      ],
    );
  }
}

class MultiSelectItem<T> extends StatefulWidget {
  final T value;
  final String label;
  bool isSelected;

  MultiSelectItem({
    super.key,
    required this.value,
    required this.label,
    required this.isSelected,
  });

  @override
  _MultiSelectItemState<T> createState() => _MultiSelectItemState<T>();
}

class _MultiSelectItemState<T> extends State<MultiSelectItem<T>> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      leading: Checkbox(
        value: widget.isSelected,
        onChanged: (bool? selected) {
          setState(() {
            widget.isSelected = selected ?? false;
          });
        },
      ),
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
      },
    );
  }
}

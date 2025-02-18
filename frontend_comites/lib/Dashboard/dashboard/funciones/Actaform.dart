// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActaForm extends StatefulWidget {
  final int citacionId;

  const ActaForm({super.key, required this.citacionId});

  @override
  _ActaFormState createState() => _ActaFormState();
}

class _ActaFormState extends State<ActaForm> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  final List<String> _labels = [
    'Verificación Quórum',
    'Verificación Asistencia Aprendiz',
    'Verificación Beneficio',
    'Reporte',
    'Descargos',
    'Pruebas',
    'Deliberación',
    'Votos',
    'Conclusiones',
    'Clasificación Información',
  ];
  int faseActual = 1;
  Clasificacion _selectedClasificacion = Clasificacion.PUBLICA;
  String _selectedDecision = 'Cancelacion de Matricula';

  // Lista de decisiones finales
  final List<String> _decisiones = ['Cancelacion de Matricula', 'Plan de mejoramiento'];

  @override
  void initState() {
    super.initState();
    _controllers.addAll(List.generate(_labels.length - 1, (_) => TextEditingController()));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Mostrar el cuadro de confirmación antes de enviar
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Decisión Final'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Seleccione la decisión final tomada para el acta:'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedDecision,
                decoration: const InputDecoration(
                  labelText: 'Decisión',
                  border: OutlineInputBorder(),
                ),
                items: _decisiones
                    .map((decision) => DropdownMenuItem<String>(
                          value: decision,
                          child: Text(decision),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedDecision = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _submitForm(); // Enviar el formulario
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final data = {
      "citacion": widget.citacionId,
      "verificacionquorom": _controllers[0].text,
      "verificacionasistenciaaprendiz": _controllers[1].text,
      "verificacionbeneficio": _controllers[2].text,
      "reporte": _controllers[3].text,
      "descargos": _controllers[4].text,
      "pruebas": _controllers[5].text,
      "deliberacion": _controllers[6].text,
      "votos": _controllers[7].text,
      "conclusiones": _controllers[8].text,
      "clasificacion": _selectedClasificacion.toString().split('.').last,
      "decision_final": _selectedDecision,
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/Acta/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Acta guardada exitosamente');
        await _updateActarealizada(widget.citacionId);

        // Actualizar "finalizado" y desactivar aprendices si es "Cancelación de matrícula"
        if (_selectedDecision == 'Cancelacion de Matricula') {
          await _updateSolicitudFinalizado();
          await _updateAprendicesActivos();
        }

        // Actualizar "planmejoramiento" si es "Plan de mejoramiento"
        if (_selectedDecision == 'Plan de mejoramiento') {
          await _updatePlanMejoramiento();
        }

        _showSuccessDialog();
      } else {
        print('Error al guardar el acta: ${response.body}');
      }
    } catch (e) {
      print('Error de red: $e');
    }
  }
}


Future<void> _updatePlanMejoramiento() async {
  final Map<String, dynamic> data = {'planmejoramiento': true};

  try {
    final response = await http.patch(
      Uri.parse('http://127.0.0.1:8000/api/Solicitud/${widget.citacionId}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Solicitud actualizada con planmejoramiento = true.');
    } else {
      print('Error al actualizar la solicitud: ${response.body}');
    }
  } catch (error) {
    print('Error al actualizar la solicitud: $error');
  }
}

Future<void> _updateAprendicesActivos() async {
  try {
    // Obtener aprendices asociados
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/Aprendices/?citacion=${widget.citacionId}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> aprendices = json.decode(response.body);

      for (var aprendiz in aprendices) {
        final aprendizId = aprendiz['id'];

        // Actualizar cada aprendiz
        final updateResponse = await http.patch(
          Uri.parse('http://127.0.0.1:8000/api/Aprendices/$aprendizId/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'activo': false}),
        );

        if (updateResponse.statusCode == 200) {
          print('Aprendiz $aprendizId desactivado.');
        } else {
          print('Error al desactivar aprendiz $aprendizId: ${updateResponse.body}');
        }
      }
    } else {
      print('Error al obtener los aprendices: ${response.body}');
    }
  } catch (error) {
    print('Error al desactivar aprendices: $error');
  }
}


// Nueva función para actualizar el bool "finalizado"
Future<void> _updateSolicitudFinalizado() async {
  final Map<String, dynamic> data = {'finalizado': true};

  try {
    final response = await http.patch(
      Uri.parse('http://127.0.0.1:8000/api/Solicitud/${widget.citacionId}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Solicitud actualizada con finalizado = true.');
    } else {
      print('Error al actualizar la solicitud: ${response.body}');
    }
  } catch (error) {
    print('Error al actualizar la solicitud: $error');
  }
}


  Future<void> _updateActarealizada(int citacionId) async {
    final Map<String, dynamic> data = {'actarealizada': true};

    try {
      final response = await http.patch(
        Uri.parse('http://127.0.0.1:8000/api/Citacion/$citacionId/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Citacion $citacionId actualizada.');
      } else {
        print('Error al actualizar la citacion: ${response.body}');
      }
    } catch (error) {
      print('Error al actualizar la citacion: $error');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Acta enviada'),
          content: const Text('La acta se ha enviado exitosamente.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: null,
        controller: _controllers[index],
        decoration: InputDecoration(
          labelText: _labels[index],
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildIndicadorPasos() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(40),
          color: Colors.grey[200]),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_labels.length, (index) {
          bool isCompleted = faseActual > index + 1;
          bool isActive = faseActual == index + 1;
          return GestureDetector(
            onTap: () {
              setState(() {
                faseActual = index + 1;
              });
            },
            child: _buildStepProgressIndicator(index + 1, isCompleted, isActive),
          );
        }),
      ),
    );
  }

  Widget _buildStepProgressIndicator(int stepNumber, bool isCompleted, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isCompleted ? Colors.green : (isActive ? Colors.orange : Colors.grey),
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
            color: isCompleted ? Colors.green : (isActive ? Colors.orange : Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildClasificacionDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Clasificacion>(
        value: _selectedClasificacion,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Clasificación de la Información',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        onChanged: (Clasificacion? newValue) {
          setState(() {
            _selectedClasificacion = newValue!;
          });
        },
        items: Clasificacion.values
            .map<DropdownMenuItem<Clasificacion>>((Clasificacion value) {
          return DropdownMenuItem<Clasificacion>(
            value: value,
            child: Text(value.toString().split('.').last),
          );
        }).toList(),
        validator: (value) => value == null ? 'Campo requerido' : null,
        dropdownColor: Colors.grey[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Crear Acta',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildIndicadorPasos(),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (faseActual < 10) _buildFormField(faseActual - 1),
                      if (faseActual == 10) _buildClasificacionDropdown(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: faseActual > 1
                                ? () {
                                    setState(() {
                                      faseActual--;
                                    });
                                  }
                                : null,
                            child: const Text('Volver'),
                          ),
                          ElevatedButton(
                            onPressed: faseActual < 10
                                ? () {
                                    setState(() {
                                      faseActual++;
                                    });
                                  }
                                : _showConfirmationDialog, // Mostrar confirmación antes de enviar
                            child: Text(faseActual < 10 ? 'Siguiente' : 'Enviar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Clasificacion { PUBLICA, PRIVADA, CONFIDENCIAL }

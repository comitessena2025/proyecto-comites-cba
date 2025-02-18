//En este documento se realizan las estadisticas de las solicitudes y reglamentos dependiendo del rol del usuario
//Cuando no hay un usuario logueado se muestran datos generales de las solicitudes y reglamentos
//Se utilizá la libreria fl_chart para realizar grafricos 

import 'dart:convert';
import 'package:comites/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EstadisticasPage extends StatefulWidget {
  const EstadisticasPage({super.key, required List solicitudes});

  @override
  State<EstadisticasPage> createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  String filtroSeleccionado = 'Anual'; // Valor por defecto
  String mesSeleccionado = 'Enero'; // Mes por defecto
  List<dynamic> solicitudes = [];
  List<dynamic> reglamentos= [];
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    fetchSolicitudes();
    fetchReglamentos();
  }
//Se obtienen las solicitudes y reglamentos de la base de datos
  Future<void> fetchSolicitudes() async {
    const url = 'http://127.0.0.1:8000/api/Solicitud/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          solicitudes = data;
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar solicitudes');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

   Future<void> fetchReglamentos() async {
    const url = 'http://127.0.0.1:8000/api/Reglamento/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          reglamentos = data;
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar solicitudes');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
//Widget principal para mostrar las estadisticas
 @override
Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: screenWidth < 600
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Estadísticas de Solicitudes',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFiltroSelector(),
                            if (filtroSeleccionado == 'Mensual') ...[
                              const SizedBox(width: 20),
                              _buildMesSelector(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 300,
                          child: _buildGrafica(context),
                        ),
                        const SizedBox(height: 20),
                        // Título para la sección de distribución de faltas
                        const Text(
                          'Distribución de Faltas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 400,
                          child: _buildPieChart(context),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Estadísticas de Solicitudes',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildFiltroSelector(),
                                  if (filtroSeleccionado == 'Mensual') ...[
                                    const SizedBox(width: 20),
                                    _buildMesSelector(),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 300,
                                child: _buildGrafica(context),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Distribución de Faltas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 400,
                                child: _buildPieChart(context),
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
//Widget para mostrar la distribución de faltas
Widget _buildPieChart(BuildContext context) {
  return Consumer<AppState>(builder: (context, appState, _) {
    final usuarioAutenticado = appState.usuarioAutenticado;

    // Filtrar solicitudes según el rol del usuario
    List<dynamic> solicitudesFiltradas = solicitudes;

    if (usuarioAutenticado != null) {
      final bool esInstructor = usuarioAutenticado.rol1 == 'INSTRUCTOR';
      final bool esAprendiz = usuarioAutenticado.rol1 == 'APRENDIZ';
      final int? idUsuario = usuarioAutenticado.id;

      if (esInstructor) {
        solicitudesFiltradas = solicitudesFiltradas.where((sol) {
          var responsable = sol['responsable'];
          if (responsable is List) {
            responsable = responsable.isNotEmpty ? responsable[0] : null;
          }
          return responsable == idUsuario;
        }).toList();
      }

      if (esAprendiz) {
        solicitudesFiltradas = solicitudesFiltradas.where((sol) {
          var aprendiz = sol['aprendiz'];
          if (aprendiz is List) {
            return aprendiz.contains(idUsuario);
          }
          return false;
        }).toList();
      }
    }

    // Calcular distribución de faltas
    int faltasAcademicas = 0;
    int faltasDisciplinarias = 0;
    int faltasAmbas = 0;

    for (var solicitud in solicitudesFiltradas) {
      List<dynamic> reglamentoIds = solicitud['reglamento'];
      bool tieneAcademica = false;
      bool tieneDisciplinaria = false;

      for (var reglamentoId in reglamentoIds) {
        var reglamento = reglamentos.firstWhere(
          (r) => r['id'] == reglamentoId,
          orElse: () => null,
        );

        if (reglamento != null) {
          if (reglamento['academico']) tieneAcademica = true;
          if (reglamento['disciplinario']) tieneDisciplinaria = true;
        }
      }

      if (tieneAcademica && tieneDisciplinaria) {
        faltasAmbas++;
      } else if (tieneAcademica) {
        faltasAcademicas++;
      } else if (tieneDisciplinaria) {
        faltasDisciplinarias++;
      }
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 18),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // Puedes eliminar esta parte si no necesitas interacción táctil
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(
                      faltasAcademicas,
                      faltasDisciplinarias,
                      faltasAmbas,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.blue,
                  text: 'Académicas',
                  isSquare: true,
                  value: faltasAcademicas,
                ),
                const SizedBox(height: 4),
                Indicator(
                  color: Colors.red,
                  text: 'Disciplinarias',
                  isSquare: true,
                  value: faltasDisciplinarias,
                ),
                const SizedBox(height: 4),
                Indicator(
                  color: Colors.purple,
                  text: 'Ambas',
                  isSquare: true,
                  value: faltasAmbas,
                ),
              ],
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  });
}
//Lista de secciones para mostrar en la grafica
List<PieChartSectionData> showingSections(
  int academicas,
  int disciplinarias,
  int ambas,
) {
  final total = academicas + disciplinarias + ambas;
  if (total == 0) return [];

  return [
    PieChartSectionData(
      color: Colors.blue,
      value: academicas.toDouble(),
      title: '${((academicas / total) * 100).toStringAsFixed(1)}%',
      radius: 50,  // No cambiar el tamaño al tocar
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: Colors.red,
      value: disciplinarias.toDouble(),
      title: '${((disciplinarias / total) * 100).toStringAsFixed(1)}%',
      radius: 50,  // No cambiar el tamaño al tocar
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: Colors.purple,
      value: ambas.toDouble(),
      title: '${((ambas / total) * 100).toStringAsFixed(1)}%',
      radius: 50,  // No cambiar el tamaño al tocar
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];
}

List<PieChartSectionData> solicitudesSections(
  int activos,
  int cancelados,
  int finalizados
) {
  final total = activos + cancelados + finalizados;
  if (total == 0) return [];

  return [
    PieChartSectionData(
      color: Colors.green,
      value: activos.toDouble(),
      title: '${((activos / total) * 100).toStringAsFixed(1)}%',
      radius: 50,  // No cambiar el tamaño al tocar
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: Colors.red,
      value: cancelados.toDouble(),
      title: '${((cancelados / total) * 100).toStringAsFixed(1)}%',
      radius: 50,  // No cambiar el tamaño al tocar
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: Colors.blue,
      value: finalizados.toDouble(),
      title: '${((finalizados / total) * 100).toStringAsFixed(1)}%',
      radius: 50,  // No cambiar el tamaño al tocar
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];
}


  // Widget para mostrar el selector de filtro
  Widget _buildFiltroSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black87, width: 1.0),
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<String>(
        dropdownColor: Colors.grey[300],
        value: filtroSeleccionado,
        onChanged: (String? newValue) {
          setState(() {
            filtroSeleccionado = newValue!;
          });
        },
        items: <String>['Anual', 'Mensual']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  // Widget para mostrar el selector de mes (solo si "Mensual" es seleccionado)
  Widget _buildMesSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black87, width: 1.0),
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<String>(
        dropdownColor: Colors.grey[300],
        value: mesSeleccionado,
        onChanged: (String? newValue) {
          setState(() {
            mesSeleccionado = newValue!;
          });
        },
        items: <String>[
          'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
          'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

// Widget para mostrar la gráfica de solicitudes
Widget _buildGrafica(BuildContext context) {
  return Consumer<AppState>(
    builder: (BuildContext context, AppState appState, _) {
      final usuarioAutenticado = appState.usuarioAutenticado;
      final bool esInstructor = usuarioAutenticado?.rol1 == 'INSTRUCTOR';
      final bool esAprendiz = usuarioAutenticado?.rol1 == 'APRENDIZ';
      final int? idUsuario = usuarioAutenticado?.id;

      // Verifica que idUsuario no sea nulo

      // Filtrar solicitudes según el rol
      List<dynamic> solicitudesFiltradas = solicitudes;
      
      if (filtroSeleccionado == 'Mensual') {
        solicitudesFiltradas = solicitudes.where((sol) {
          final DateTime fecha = DateTime.parse(sol['fechasolicitud']);
          return fecha.month == _getMesIndex(mesSeleccionado);
        }).toList();
      }

      if (esInstructor) {
  solicitudesFiltradas = solicitudesFiltradas
      .where((sol) {
        // Verifica si 'responsable' es una lista, y extrae el primer valor si es necesario
        var responsable = sol['responsable'];
        if (responsable is List) {
          responsable = responsable.isNotEmpty ? responsable[0] : null;
        }
        return responsable == idUsuario;
      })
      .toList();
      }
      if (esAprendiz) {
  solicitudesFiltradas = solicitudesFiltradas
      .where((sol) {
        var aprendiz = sol['aprendiz'];
        if (aprendiz is List) {
          return aprendiz.contains(idUsuario);
        }
        return false;
      })
      .toList();
}


      if (solicitudesFiltradas.isEmpty) {
        return const Center(
          child: Text('No hay solicitudes para los filtros seleccionados.'),
        );
      }


      final int procesosActivos = solicitudesFiltradas
          .where((sol) => sol['finalizado'] == false && sol['solicitudrechazada'] == false)
          .length;
      final int procesosCancelados = solicitudesFiltradas
          .where((sol) => sol['solicitudrechazada'] == true)
          .length;
      final int procesosFinalizados = solicitudesFiltradas
          .where((sol) => sol['finalizado'] == true)
          .length;

      return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 18),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // Puedes eliminar esta parte si no necesitas interacción táctil
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: solicitudesSections(
                      procesosActivos,
                      procesosCancelados,
                      procesosFinalizados,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.green,
                  text: 'Activos',
                  isSquare: true,
                  value: procesosActivos,
                ),
                const SizedBox(height: 4),
                Indicator(
                  color: Colors.red,
                  text: 'Cancelados',
                  isSquare: true,
                  value: procesosCancelados,
                ),
                const SizedBox(height: 4),
                Indicator(
                  color: Colors.blue,
                  text: 'Finalizados',
                  isSquare: true,
                  value: procesosFinalizados,
                ),
              ],
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  });
}


int _getMesIndex(String mes) {
  switch (mes) {
    case 'Enero':
      return 1;
    case 'Febrero':
      return 2;
    case 'Marzo':
      return 3;
    case 'Abril':
      return 4;
    case 'Mayo':
      return 5;
    case 'Junio':
      return 6;
    case 'Julio':
      return 7;
    case 'Agosto':
      return 8;
    case 'Septiembre':
      return 9;
    case 'Octubre':
      return 10;
    case 'Noviembre':
      return 11;
    case 'Diciembre':
      return 12;
    default:
      return 1; // Valor por defecto
  }
}

}



class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final int value;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.value,
    this.isSquare = false,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$text ($value)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
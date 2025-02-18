import 'dart:convert';
import 'package:comites/Dashboard/main/Main_Funciones/Main_llamadoatencion2.dart';
import 'package:comites/Models/Llamadoatencion_model_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:math';

class LlamadoAtencionPage extends StatefulWidget {
  const LlamadoAtencionPage({super.key});
  @override
  _LlamadoAtencionPageState createState() => _LlamadoAtencionPageState();
}

class _LlamadoAtencionPageState extends State<LlamadoAtencionPage> {
  List<LlamadoatencionModel> _llamadoAtencionList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLlamadoAtencion();
  }

  Future<void> _fetchLlamadoAtencion() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/llamadoAtencion/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _llamadoAtencionList =
              data.map((json) => LlamadoatencionModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Llamado de Atención'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _llamadoAtencionList.length,
              itemBuilder: (context, index) {
                return FuturisticCard(
                  llamado: _llamadoAtencionList[index],
                );
              },
            ),
    );
  }
}

class FuturisticCard extends StatefulWidget {
  final LlamadoatencionModel llamado;

  const FuturisticCard({required this.llamado});

  @override
  _FuturisticCardState createState() => _FuturisticCardState();
}

class _FuturisticCardState extends State<FuturisticCard>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
      if (_isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * pi; // Rotación completa (180°)
          final isBackVisible =
              angle > pi / 2; // Detecta si estamos en el reverso
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(angle),
            child: isBackVisible
                ? Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.rotationY(pi), // Invierte el texto del reverso
                    child: _buildCardBack(),
                  )
                : _buildCardFront(),
          );
        },
      ),
    );
  }

  Widget _buildCardFront() {
    return _buildCard(
      gradient: const LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID: ${widget.llamado.id}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Descripción: ${widget.llamado.descripcion}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            'Fecha: ${widget.llamado.fechallamadoatencion.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _crearSegundoLlamado,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Crear Segundo Llamado',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return _buildCard(
      gradient: const LinearGradient(
        colors: [Colors.purple, Colors.blue],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Observaciones: ${widget.llamado.observaciones}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Fecha de Llamado: ${widget.llamado.fechallamadoatencion.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            'Reglamentos: ${widget.llamado.reglamento}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            'Responsables: ${widget.llamado.responsable}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            'Aprendiz: ${widget.llamado.aprendiz}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _crearSegundoLlamado,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Crear Segundo Llamado',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _crearSegundoLlamado() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Segundo Llamado'),
        content: const Text('¿Desea crear un segundo llamado de atención?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MainLllamadoatencion2(), // Pass the llamadoId here
                ),
              );
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required LinearGradient gradient,
    required Widget content,
  }) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyan, width: 2),
        ),
        child: content,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

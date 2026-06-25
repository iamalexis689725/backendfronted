import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClaseDashboardScreen extends StatelessWidget {
  final int periodoId;
  final int cursoId;
  final int paraleloId;
  final int asignacionId;

  final String curso;
  final String paralelo;
  final String materia;

  const ClaseDashboardScreen({
    super.key,
    required this.periodoId,
    required this.cursoId,
    required this.paraleloId,
    required this.asignacionId,
    required this.curso,
    required this.paralelo,
    required this.materia,
  });
  static const purple = Color(0xFF4F46E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        title: Text('$curso - $paralelo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    children: [
                    Text(
                      materia,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          context.go(
                            '/mis-clases/$periodoId/$cursoId/$paraleloId/$asignacionId/anecdotarios',
                          );
                        },
                          icon: const Icon(Icons.menu_book),
                        label: const Text('Ver Anecdotarios'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          context.go(
                            '/mis-clases/$periodoId/$cursoId/$paraleloId/$asignacionId/anecdotarios/create',
                          );
                        },
                        icon: const Icon(Icons.edit_note),
                        label: const Text('Registrar Anecdotario'),
                      ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
    ),
    onPressed: () {
      context.go(
        '/mis-clases/$periodoId/$cursoId/$paraleloId/$asignacionId/libro-calificaciones',
      );
    },
    icon: const Icon(Icons.grade),
    label: const Text(
      'Libro de Calificaciones',
    ),
  ),
  
),

const SizedBox(height: 14),


SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
    onPressed: () {
      context.go(
        '/mis-clases/$periodoId/$cursoId/$paraleloId/$asignacionId/asistencia',
      );
    },
    icon: const Icon(Icons.check_circle),
    label: const Text('Tomar Asistencia'),
  ),
),
const SizedBox(height: 14),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
    onPressed: () {
      context.go(
        '/mis-clases/$periodoId/$cursoId/$paraleloId/$asignacionId/agendas',
      );
    },
    icon: const Icon(Icons.event_note),
    label: const Text('Ver Agenda'),
  ),
),
const SizedBox(height: 14),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
    onPressed: () {
      context.go(
        '/mis-clases/$periodoId/$cursoId/$paraleloId/$asignacionId/criterios',
      );
    },
    icon: const Icon(Icons.rule),
    label: const Text('Criterios de Evaluación'),
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
}
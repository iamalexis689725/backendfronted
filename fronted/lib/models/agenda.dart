import 'agenda_archivo.dart';
class Agenda {
  final int? id;
  final String titulo;
  final String? descripcion;
  final String tipo;
  final String? fechaEntrega;

  final String? materia;
  final String? profesor;
  final String? curso;
  final String? paralelo;

  final List<AgendaArchivo> archivos;

  Agenda({
    this.id,
    required this.titulo,
    this.descripcion,
    required this.tipo,
    this.fechaEntrega,
    this.materia,
    this.profesor,
    this.curso,
    this.paralelo,
    this.archivos = const [],
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'],
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'],
      tipo: json['tipo'] ?? '',
      fechaEntrega: json['fecha_entrega'],
      materia: json['materia'],
      profesor: json['profesor'],
      curso: json['curso'],
      paralelo: json['paralelo'],

      archivos: (json['archivos'] as List<dynamic>?)
              ?.map((e) => AgendaArchivo.fromJson(e))
              .toList() ??
          [],
    );
  }
}
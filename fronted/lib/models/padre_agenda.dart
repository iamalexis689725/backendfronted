import 'agenda_archivo.dart';

class PadreAgenda {
  final int id;
  final String titulo;
  final String descripcion;
  final String tipo;
  final String? fechaEntrega;
  final String materia;

  final List<AgendaArchivo> archivos;

  PadreAgenda({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    this.fechaEntrega,
    required this.materia,
    this.archivos = const [],
  });

  factory PadreAgenda.fromJson(Map<String, dynamic> json) {
    return PadreAgenda(
      id: json["id"],
      titulo: json["titulo"] ?? "",
      descripcion: json["descripcion"] ?? "",
      tipo: json["tipo"] ?? "",
      fechaEntrega: json["fecha_entrega"],
      materia: json["materia"] ?? "",
      archivos:
          (json["archivos"] as List?)
              ?.map((e) => AgendaArchivo.fromJson(e))
              .toList() ??
          [],
    );
  }
}

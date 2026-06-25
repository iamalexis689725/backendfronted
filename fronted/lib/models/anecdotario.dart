class Anecdotario {
  final int? id;
  final int? estudianteId;
  final String? estudiante;
  final String? profesor;
  final String? materia;
  final String? tipo;
  final String? titulo;
  final String? descripcion;
  final String? fecha;

  Anecdotario({
    this.id,
    this.estudianteId,
    this.estudiante,
    this.profesor,
    this.materia,
    this.tipo,
    this.titulo,
    this.descripcion,
    this.fecha,
  });
  factory Anecdotario.fromJson(Map<String, dynamic> json) {
    return Anecdotario(
      id: json['id'],
      estudianteId: json['estudiante_id'],
      estudiante: json['estudiante']?['user']?['name'],
      profesor: json['profesor']?['user']?['name'],
      materia: json['asignacion_docente']?['subject']?['nombre'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
    );
  }
}

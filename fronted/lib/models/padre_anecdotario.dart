class PadreAnecdotario {
  final int? id;
  final String? tipo;
  final String? titulo;
  final String? descripcion;
  final String? fecha;

  final String? profesor;
  final String? materia;

  PadreAnecdotario({
    this.id,
    this.tipo,
    this.titulo,
    this.descripcion,
    this.fecha,
    this.profesor,
    this.materia,
  });

  factory PadreAnecdotario.fromJson(Map<String, dynamic> json) {
    return PadreAnecdotario(
      id: json['id'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],

      profesor: json['profesor']?['user']?['name'],

      materia: json['asignacion_docente']?['subject']?['name'],
    );
  }
}

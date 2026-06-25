class MiClase {
  final int? id;
  final String? curso;
  final String? paralelo;
  final String? materia;
  final int? cursoId;
  final int? paraleloId;
  final int? subjectId;

  MiClase({
    this.id,
    this.curso,
    this.paralelo,
    this.materia,
    this.cursoId,
    this.paraleloId,
    this.subjectId,
  });

  factory MiClase.fromJson(Map<String, dynamic> json) {
    return MiClase(
      id: json['id'],
      curso: json['curso'],
      paralelo: json['paralelo'],
      materia: json['materia'],
      cursoId: json['curso_id'],
      paraleloId: json['paralelo_id'],
      subjectId: json['subject_id'],
    );
  }
}
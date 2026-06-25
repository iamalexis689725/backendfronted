class Asignacion {
  final int? id;
  final String? dia;
  final String? horaInicio;
  final String? horaFin;
  final String? materia;
  final String? curso;
  final String? paralelo;

  Asignacion({
    this.id,
    this.dia,
    this.horaInicio,
    this.horaFin,
    this.materia,
    this.curso,
    this.paralelo,
  });

  factory Asignacion.fromJson(Map<String, dynamic> json) {
    return Asignacion(
      id:         json['id'],
      dia:        json['dia'],
      horaInicio: json['hora_inicio'],
      horaFin:    json['hora_fin'],
      materia:    json['materia'],
      curso:      json['curso'],
      paralelo:   json['paralelo'],
    );
  }
  
}
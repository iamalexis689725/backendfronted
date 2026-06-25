class HorarioItem {
  final int?    id;
  final String? dia;
  final String? horaInicio;
  final String? horaFin;
  final String? materia;
  final String? profesor;

  HorarioItem({
    this.id,
    this.dia,
    this.horaInicio,
    this.horaFin,
    this.materia,
    this.profesor,
  });

  factory HorarioItem.fromJson(Map<String, dynamic> json) {
    return HorarioItem(
      id:         json['id'],
      dia:        json['dia'],
      horaInicio: json['hora_inicio'],
      horaFin:    json['hora_fin'],
      materia:    json['materia'],
      profesor:   json['profesor'],
    );
  }
}
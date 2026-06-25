class PeriodoNota {
  final String periodo;
  final List<MateriaNota> materias;
  final double promedioGeneral;

  PeriodoNota({
    required this.periodo,
    required this.materias,
    required this.promedioGeneral,
  });

  factory PeriodoNota.fromJson(Map<String, dynamic> json) {
    return PeriodoNota(
      periodo: json['periodo'] ?? '',
      materias: (json['materias'] as List?)
              ?.map((e) => MateriaNota.fromJson(e))
              .toList() ??
          [],
      promedioGeneral: (json['promedio_general'] ?? 0).toDouble(),
    );
  }
}

class MateriaNota {
  final String materia;
  final double promedio;

  MateriaNota({
    required this.materia,
    required this.promedio,
  });

  factory MateriaNota.fromJson(Map<String, dynamic> json) {
    return MateriaNota(
      materia: json['materia'] ?? '',
      promedio: (json['promedio'] ?? 0).toDouble(),
    );
  }
}
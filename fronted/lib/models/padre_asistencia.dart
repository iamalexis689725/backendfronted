class PadreAsistencia {
  final String fecha;
  final String materia;

  PadreAsistencia({required this.fecha, required this.materia});

  factory PadreAsistencia.fromJson(Map<String, dynamic> json) {
    return PadreAsistencia(
      fecha: json['fecha'] ?? '',
      materia: json['materia'] ?? '',
    );
  }
}

class PadreAsistenciaResponse {
  final List<String> materias;
  final int totalFaltas;
  final List<PadreAsistencia> faltas;

  PadreAsistenciaResponse({
    required this.materias,
    required this.totalFaltas,
    required this.faltas,
  });

  factory PadreAsistenciaResponse.fromJson(Map<String, dynamic> json) {
    return PadreAsistenciaResponse(
      materias: List<String>.from(json['materias'] ?? []),

      totalFaltas: json['total_faltas'] ?? 0,

      faltas:
          (json['faltas'] as List? ?? [])
              .map((e) => PadreAsistencia.fromJson(e))
              .toList(),
    );
  }
}

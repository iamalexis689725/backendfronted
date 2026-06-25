class LibroCalificaciones {
  final List<CriterioLibro> criterios;
  final List<EstudianteLibro> estudiantes;

  LibroCalificaciones({
    required this.criterios,
    required this.estudiantes,
  });

  factory LibroCalificaciones.fromJson(Map<String, dynamic> json) {
    return LibroCalificaciones(
      criterios: (json['criterios'] as List)
          .map((e) => CriterioLibro.fromJson(e))
          .toList(),
      estudiantes: (json['estudiantes'] as List)
          .map((e) => EstudianteLibro.fromJson(e))
          .toList(),
    );
  }
}

class CriterioLibro {
  final int id;
  final String nombre;
  final double porcentaje;

  CriterioLibro({
    required this.id,
    required this.nombre,
    required this.porcentaje,
  });

  factory CriterioLibro.fromJson(Map<String, dynamic> json) {
    return CriterioLibro(
      id: json['id'],
      nombre: json['nombre'],
      porcentaje: double.parse(json['porcentaje'].toString()),
    );
  }
}

class EstudianteLibro {
  final int estudianteId;
  final String estudiante;
  final List<NotaLibro> notas;
  final double promedio;

  EstudianteLibro({
    required this.estudianteId,
    required this.estudiante,
    required this.notas,
    required this.promedio,
  });

  factory EstudianteLibro.fromJson(Map<String, dynamic> json) {
    return EstudianteLibro(
      estudianteId: json['estudiante_id'],
      estudiante: json['estudiante'],
      promedio: double.parse(json['promedio'].toString()),
      notas: (json['notas'] as List)
          .map((e) => NotaLibro.fromJson(e))
          .toList(),
    );
  }
}

class NotaLibro {
  final int criterioId;
  final String criterio;
  final double porcentaje;
  double nota;

  NotaLibro({
    required this.criterioId,
    required this.criterio,
    required this.porcentaje,
    required this.nota,
  });

  factory NotaLibro.fromJson(Map<String, dynamic> json) {
    return NotaLibro(
      criterioId: json['criterio_id'],
      criterio: json['criterio'],
      porcentaje: double.parse(json['porcentaje'].toString()),
      nota: double.parse(json['nota'].toString()),
    );
  }
}
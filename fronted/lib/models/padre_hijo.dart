class PadreHijo {

  final int id;
  final String nombre;
  final String codigoEstudiante;
  final String parentesco;

  PadreHijo({
    required this.id,
    required this.nombre,
    required this.codigoEstudiante,
    required this.parentesco,
  });

  factory PadreHijo.fromJson(Map<String, dynamic> json) {

    return PadreHijo(
      id: json["id"],
      nombre: json["nombre"],
      codigoEstudiante: json["codigo_estudiante"],
      parentesco: json["parentesco"],
    );
  }
}
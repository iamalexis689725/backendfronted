class Estudiante {
  final int? id;
  final String? codigoEstudiante;
  final String? name;
  final String? email;


  Estudiante({
    this.id,
    this.codigoEstudiante,
    this.name,
    this.email,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'],
      codigoEstudiante: json['codigo_estudiante'],
      name: json['user']?['name'],
      email: json['user']?['email'],
    );
  }
}
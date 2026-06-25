class Profesor {
  final int? id;
  final String? codigo;
  final String? especialidad;
  final String? name;
  final String? email;

  Profesor({
    this.id,
    this.codigo,
    this.especialidad,
    this.name,
    this.email,
  });

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(  
      id: json['id'],
      codigo: json['codigo_profesor'],
      especialidad: json['especialidad'],
      name: json['user']?['name'],
      email: json['user']?['email'],
    );
  }
}
class EstudianteClase {
  final int?    id;
  final String? nombre;
  final String? email;

  EstudianteClase({this.id, this.nombre, this.email});

  factory EstudianteClase.fromJson(Map<String, dynamic> json) {
    return EstudianteClase(
      id:     json['id'],
      nombre: json['nombre'],
      email:  json['email'],
    );
  }
}

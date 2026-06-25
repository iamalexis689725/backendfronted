import 'curso.dart';

class Paralelo {
  final int? id;
  final int? cursoId;
  final String? nombre;
  final String? turno;
  final int? capacidad;
  final int? tenantId;
  final Curso? curso;

  Paralelo({
    this.id,
    this.cursoId,
    this.nombre,
    this.turno,
    this.capacidad,
    this.tenantId,
    this.curso,
  });

  factory Paralelo.fromJson(Map<String, dynamic> json) {
    return Paralelo(
      id: json['id'],
      cursoId: json['curso_id'],
      nombre: json['nombre'],
      turno: json['turno'],
      capacidad: json['capacidad'],
      tenantId: json['tenant_id'],
      curso: json['curso'] != null ? Curso.fromJson(json['curso']) : null,
    );
  }
}
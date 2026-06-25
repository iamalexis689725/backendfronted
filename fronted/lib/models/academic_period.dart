class AcademicPeriod {
  final int? id;
  final String? nombre;
  final String? fechaInicio;
  final String? fechaFin;
  final bool? activo;

  AcademicPeriod({
    this.id,
    this.nombre,
    this.fechaInicio,
    this.fechaFin,
    this.activo,
  });

  factory AcademicPeriod.fromJson(Map<String, dynamic> json) {
    return AcademicPeriod(
      id: json['id'],
      nombre: json['nombre'],
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      activo: json['activo'] == 1 || json['activo'] == true,
    );
  }
}
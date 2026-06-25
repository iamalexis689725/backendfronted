class PeriodoEvaluacion {
  final int? id;
  final int? academicPeriodId;
  final String? nombre;
  final int? orden;
  final int? tenantId;

  PeriodoEvaluacion({
    this.id,
    this.academicPeriodId,
    this.nombre,
    this.orden,
    this.tenantId,
  });

  factory PeriodoEvaluacion.fromJson(
    Map<String, dynamic> json,
  ) {
    return PeriodoEvaluacion(
      id: json['id'],
      academicPeriodId: json['academic_period_id'],
      nombre: json['nombre'],
      orden: json['orden'],
      tenantId: json['tenant_id'],
    );
  }
}
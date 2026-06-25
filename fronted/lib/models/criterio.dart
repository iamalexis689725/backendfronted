import 'periodo_evaluacion.dart';
class Criterio {
  final int? id;
   final int? periodoEvaluacionId;
     final PeriodoEvaluacion? periodoEvaluacion;
  final String? nombre;
  final double? porcentaje;

  Criterio({
    this.id,
    this.periodoEvaluacionId,
     this.periodoEvaluacion,
    this.nombre,
    this.porcentaje,
  });

 factory Criterio.fromJson(Map<String, dynamic> json) {
  return Criterio(
    id: json['id'],
    periodoEvaluacionId: json['periodo_evaluacion_id'],
    periodoEvaluacion: json['periodo_evaluacion'] != null
        ? PeriodoEvaluacion.fromJson(
            json['periodo_evaluacion'],
          )
        : null,
    nombre: json['nombre'],
    porcentaje: double.tryParse(
      json['porcentaje'].toString(),
    ),
  );
}
}
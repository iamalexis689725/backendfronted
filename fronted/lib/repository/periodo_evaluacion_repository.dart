import 'package:dio/dio.dart';

import '../models/periodo_evaluacion.dart';

class PeriodoEvaluacionRepository {
  final Dio _dio;

  PeriodoEvaluacionRepository(this._dio);

  Future<List<PeriodoEvaluacion>> getPeriodosEvaluacion(
    int periodoId,
  ) async {
    final response = await _dio.get(
      '/periodos/$periodoId/periodos-evaluacion',
    );

    return (response.data as List)
        .map(
          (e) => PeriodoEvaluacion.fromJson(e),
        )
        .toList();
  }

  Future<PeriodoEvaluacion> createPeriodoEvaluacion({
    required int periodoId,
    required String nombre,
    required int orden,
  }) async {
    final response = await _dio.post(
      '/periodos/$periodoId/periodos-evaluacion',
      data: {
        'nombre': nombre,
        'orden': orden,
      },
    );

    return PeriodoEvaluacion.fromJson(
      response.data,
    );
  }
}
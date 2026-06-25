import 'package:dio/dio.dart';

import '../models/libro_calificaciones.dart';
import '../models/periodo_evaluacion.dart';

class LibroCalificacionesRepository {
  final Dio _dio;

  LibroCalificacionesRepository(this._dio);

  Future<List<PeriodoEvaluacion>> getPeriodosAsignacion(
    int asignacionId,
  ) async {
    final response = await _dio.get(
      '/asignaciones/$asignacionId/periodos-evaluacion',
    );

    return (response.data as List)
        .map(
          (e) => PeriodoEvaluacion.fromJson(e),
        )
        .toList();
  }

  Future<LibroCalificaciones> getLibroCalificaciones({
    required int asignacionId,
    required int periodoId,
  }) async {
    final response = await _dio.get(
      '/asignaciones/$asignacionId/periodos-evaluacion/$periodoId/libro-calificaciones',
    );

    return LibroCalificaciones.fromJson(
      response.data,
    );
  }

  Future<void> guardarNotas({
    required int criterioId,
    required List<Map<String, dynamic>> notas,
  }) async {
    await _dio.post(
      '/criterios/$criterioId/notas',
      data: {
        'notas': notas,
      },
    );
  }
}
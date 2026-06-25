import 'package:dio/dio.dart';
import '../models/criterio.dart';
import '../models/periodo_evaluacion.dart';

class CriterioRepository {
  final Dio _dio;

  CriterioRepository(this._dio);

  Future<List<Criterio>> getCriterios(
    int asignacionId,
  ) async {
    final response = await _dio.get(
      '/criterios/asignacion/$asignacionId',
    );

    return (response.data as List)
        .map((e) => Criterio.fromJson(e))
        .toList();
  }

  Future<void> crearCriterio({
    required int asignacionId,
     required int periodoEvaluacionId,
    required String nombre,
    required double porcentaje,
  }) async {
    await _dio.post(
      '/criterios/asignacion/$asignacionId',
      data: {
        'periodo_evaluacion_id': periodoEvaluacionId,
        'nombre': nombre,
        'porcentaje': porcentaje,
      },
    );
  }

   Future<void> actualizarCriterio({
    required int criterioId,
    required String nombre,
    required double porcentaje,
  }) async {
    await _dio.put(
      '/criterios/$criterioId',
      data: {
        'nombre': nombre,
        'porcentaje': porcentaje,
      },
    );
  }

  Future<void> eliminarCriterio(
    int criterioId,
  ) async {
    await _dio.delete(
      '/criterios/$criterioId',
    );
  }

  Future<List<PeriodoEvaluacion>> getPeriodosEvaluacion(
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
}
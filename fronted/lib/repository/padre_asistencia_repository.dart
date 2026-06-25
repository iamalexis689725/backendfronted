import 'package:dio/dio.dart';

import '../models/padre_asistencia.dart';

class PadreAsistenciaRepository {

  final Dio _dio;

  PadreAsistenciaRepository(
    this._dio,
  );

  Future<PadreAsistenciaResponse>
  getAsistenciasHijo(
    int estudianteId, {
    String? materia,
  }) async {

    final response = await _dio.get(
      '/padre/hijos/$estudianteId/asistencias',

      queryParameters: {
        if (materia != null)
          'materia': materia,
      },
    );

    return PadreAsistenciaResponse.fromJson(
      response.data,
    );
  }
}
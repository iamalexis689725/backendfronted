import 'package:dio/dio.dart';
import '../models/asistencia.dart';

class AsistenciaRepository {
  final Dio _dio;

  AsistenciaRepository(this._dio);

  Future<void> registrarAsistencia({
    required int periodoId,
    required int asignacionId,
    required String fecha,
    required List<AsistenciaDetalle> asistencias,
  }) async {
    await _dio.post(
      '/periodos/$periodoId/asignaciones/$asignacionId/asistencia',
      data: {
        'fecha': fecha,
        'asistencias':
            asistencias.map((e) => e.toJson()).toList(),
      },
    );
  }

  Future<Asistencia> obtenerAsistencia({
    required int periodoId,
    required int asignacionId,
    required String fecha,
  }) async {
    final response = await _dio.get(
      '/periodos/$periodoId/asignaciones/$asignacionId/asistencia/$fecha',
    );

    return Asistencia.fromJson(response.data);
  }


  Future<List<Asistencia>> listarAsistencias({
    required int periodoId,
    required int asignacionId,
  }) async {
    final response = await _dio.get(
      '/periodos/$periodoId/asignaciones/$asignacionId/asistencia',
    );

    final List data = response.data;

    return data
        .map((e) => Asistencia.fromJson(e))
        .toList();
  }

 
  Future<void> actualizarAsistencia({
    required int asistenciaId,
    required List<AsistenciaDetalle> asistencias,
  }) async {
    await _dio.put(
      '/asistencia/$asistenciaId',
      data: {
        'asistencias':
            asistencias.map((e) => e.toJson()).toList(),
      },
    );
  }
}
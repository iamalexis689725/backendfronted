import 'package:dio/dio.dart';
import '../models/anecdotario.dart';

class AnecdotarioRepository {
  final Dio _dio;

  AnecdotarioRepository(this._dio);

  Future<List<Anecdotario>> getAnecdotarios({
    required int asignacionDocenteId,
    required int academicPeriodId,
  }) async {
    final response = await _dio.get('/anecdotarios',
      queryParameters: {
        'asignacion_docente_id': asignacionDocenteId,
        'academic_period_id': academicPeriodId,
      },
    );

    final List data = response.data;
 return data
        .map((e) => Anecdotario.fromJson(e))
        .toList();
  }

  Future<void> createAnecdotario({
    required int estudianteId,
    required int asignacionDocenteId,
    required int academicPeriodId,
    required String tipo,
    required String titulo,
    required String descripcion,
    required String fecha,
  }) async {
    await _dio.post(
      '/anecdotarios',
      data: {
        'estudiante_id': estudianteId,
        'asignacion_docente_id': asignacionDocenteId,
        'academic_period_id': academicPeriodId,
        'tipo': tipo,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha,
      },
    );
  }

  Future<void> deleteAnecdotario({
  required int anecdotarioId,
}) async {
    await _dio.delete(
      '/anecdotarios/$anecdotarioId',
    );
 
}
}
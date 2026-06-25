import 'package:dio/dio.dart';

import '../models/inscripcion.dart';
import '../models/estudiante_clase.dart';

class InscripcionRepository {
  final Dio _dio;

  InscripcionRepository(this._dio);

  // =========================
  // LISTAR INSCRIPCIONES
  // =========================

  Future<List<Inscripcion>> getInscripciones(
    int periodoId,
  ) async {
    final response = await _dio.get(
      '/periodos/$periodoId/inscripciones',
    );

    final List data =
        response.data is List
            ? response.data
            : response.data['data'] ?? [];

    return data
        .map((e) => Inscripcion.fromJson(e))
        .toList();
  }

  // =========================
  // CREAR
  // =========================

  Future<Inscripcion> createInscripcion({
    required int periodoId,
    required int estudianteId,
    required int cursoId,
    required int paraleloId,
  }) async {
    final response = await _dio.post(
      '/periodos/$periodoId/inscripciones',
      data: {
        'estudiante_id': estudianteId,
        'curso_id': cursoId,
        'paralelo_id': paraleloId,
      },
    );

    return Inscripcion.fromJson(response.data);
  }

  // =========================
  // ELIMINAR
  // =========================

  Future<void> deleteInscripcion(
    int periodoId,
    int id,
  ) async {
    await _dio.delete(
      '/periodos/$periodoId/inscripciones/$id',
    );
  }

  // =========================
  // ESTUDIANTES POR CLASE
  // =========================

  Future<List<EstudianteClase>>
      getEstudiantesPorClase({
    required int periodoId,
    required int cursoId,
    required int paraleloId,
  }) async {
    final response = await _dio.get(
      '/periodos/$periodoId/cursos/$cursoId/paralelos/$paraleloId/estudiantes',
    );

    final List data =
        response.data['estudiantes'] ?? [];

    return data
        .map((e) => EstudianteClase.fromJson(e))
        .toList();
  }
}
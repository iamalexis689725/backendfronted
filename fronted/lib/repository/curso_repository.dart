import 'package:dio/dio.dart';
import '../models/curso.dart';

class CursoRepository {
  final Dio _dio;

  CursoRepository(this._dio);

  Future<List<Curso>> getCursos(int periodoId) async {
    final response = await _dio.get('/periodos/$periodoId/cursos');

    return (response.data as List)
    .map((e) => Curso.fromJson(e))
    .toList();
  }

  Future<Curso> createCurso({
    required int periodoId,
    required String nombre,
    required String nivel,
    String? descripcion,
  }) async {
    final response = await _dio.post(
      '/periodos/$periodoId/cursos',
      data: {'nombre': nombre, 'nivel': nivel, 'descripcion': descripcion},
    );
    return Curso.fromJson(response.data);
  }

  Future<void> deleteCurso(int periodoId, int id) async {
    await _dio.delete('/periodos/$periodoId/cursos/$id');
  }
}

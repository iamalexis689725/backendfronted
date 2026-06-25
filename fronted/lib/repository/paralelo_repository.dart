import 'package:dio/dio.dart';
import '../models/paralelo.dart';

class ParaleloRepository {
  final Dio _dio;

  ParaleloRepository(this._dio);

  Future<List<Paralelo>> getParalelos() async {
    final response = await _dio.get('/paralelos');

    return (response.data as List)
        .map((e) => Paralelo.fromJson(e))
        .toList();
  }

  Future<Paralelo> createParalelo({
    required int cursoId,
    required String nombre,
    String? turno,
    int? capacidad,
  }) async {

    final response = await _dio.post(
      '/paralelos',
      data: {
        'curso_id': cursoId,
        'nombre': nombre,
        'turno': turno,
        'capacidad': capacidad,
      },
    );

    return Paralelo.fromJson(response.data);
  }

  Future<void> deleteParalelo(int id) async {
    await _dio.delete('/paralelos/$id');
  }

  Future<List<Paralelo>> getParalelosByCurso(
    int periodoId,
    int cursoId,
  ) async {

    final response = await _dio.get(
      '/periodos/$periodoId/cursos/$cursoId/paralelos',
    );

    final List data = response.data['data'];

    return data
        .map((e) => Paralelo.fromJson(e))
        .toList();
  }
}
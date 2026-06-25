import 'package:dio/dio.dart';
import '../models/circular.dart';

class CircularRepository {

  final Dio _dio;

  CircularRepository(this._dio);

  Future<List<Circular>> getCirculares() async {

    final response = await _dio.get('/circulares');

    return (response.data as List)
        .map((e) => Circular.fromJson(e))
        .toList();
  }

  Future<Circular> getCircularById(int id) async {

    final response = await _dio.get('/circulares/$id');

    return Circular.fromJson(response.data);
  }

  Future<void> createCircular({
    required String titulo,
    required String contenido,
    required String target,
  }) async {

    await _dio.post(
      '/circulares',
      data: {
        'titulo': titulo,
        'contenido': contenido,
        'target': target,
      },
    );
  }

  Future<void> marcarLeido(int id) async {

    await _dio.post('/circulares/$id/leer');
  }

  Future<void> deleteCircular(int id) async {

    await _dio.delete('/circulares/$id');
  }
}
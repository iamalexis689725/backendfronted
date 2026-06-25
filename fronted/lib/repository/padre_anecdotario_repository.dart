import 'package:dio/dio.dart';

import '../models/padre_anecdotario.dart';

class PadreAnecdotarioRepository {
  final Dio _dio;

  PadreAnecdotarioRepository(
    this._dio,
  );

  Future<List<PadreAnecdotario>>
      getAnecdotarios(
    int estudianteId,
  ) async {
    final response = await _dio.get(
      '/padre/mis-hijos/$estudianteId/anecdotarios',
    );

    return (response.data as List)
        .map(
          (e) =>
              PadreAnecdotario.fromJson(e),
        )
        .toList();
  }
}
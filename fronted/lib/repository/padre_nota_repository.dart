import 'package:dio/dio.dart';
import '../models/padre_nota.dart';

class PadreNotaRepository {
  final Dio _dio;

  PadreNotaRepository(this._dio);

  Future<List<PeriodoNota>> getBoleta(int estudianteId) async {
    final response = await _dio.get(
      '/padre/mis-hijos/$estudianteId/notas',
    );

    final List periodos = response.data['periodos'];

    return periodos.map((e) => PeriodoNota.fromJson(e)).toList();
  }
}
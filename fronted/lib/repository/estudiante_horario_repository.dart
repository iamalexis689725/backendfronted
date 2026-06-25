// repository/estudiante_horario_repository.dart

import 'package:dio/dio.dart';
import '../models/horario_curso.dart';

class EstudianteHorarioRepository {
  final Dio _dio;
  EstudianteHorarioRepository(this._dio);

  Future<List<HorarioItem>> getHorario() async {
    final response = await _dio.get('/estudiante/horario');
    return (response.data as List)
        .map((e) => HorarioItem.fromJson(e))
        .toList();
  }
}
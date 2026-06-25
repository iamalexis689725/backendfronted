import 'package:dio/dio.dart';
import '../models/academic_period.dart';

class AcademicPeriodRepository {

  final Dio _dio;

  AcademicPeriodRepository(this._dio);

  Future<List<AcademicPeriod>> getPeriodos() async {

    final response = await _dio.get('/periodos');

    return (response.data as List)
        .map((e) => AcademicPeriod.fromJson(e))
        .toList();
  }

  Future<AcademicPeriod?> getPeriodoActivo() async {

    final response = await _dio.get('/periodos/activo');

    return AcademicPeriod.fromJson(response.data);
  }

  Future<AcademicPeriod> createPeriodo({
    required String nombre,
    required String fechaInicio,
    required String fechaFin,
    bool activo = false,
  }) async {

    final response = await _dio.post(
      '/periodos',
      data: {
        'nombre': nombre,
        'fecha_inicio': fechaInicio,
        'fecha_fin': fechaFin,
        'activo': activo,
      },
    );

    return AcademicPeriod.fromJson(response.data);
  }

  Future<void> activarPeriodo(int id) async {

    await _dio.patch('/periodos/$id/activar');
  }

  Future<void> deletePeriodo(int id) async {

    await _dio.delete('/periodos/$id');
  }
}
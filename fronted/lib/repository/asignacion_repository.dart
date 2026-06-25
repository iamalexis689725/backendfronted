import 'package:dio/dio.dart';
import '../models/asignacion.dart';
import '../models/horario_curso.dart';
import '../models/mi_clase.dart';

class AsignacionRepository {
  final Dio _dio;

  AsignacionRepository(this._dio);

  Future<Map<String, List<Asignacion>>> getHorario(
    int profesorId,
  ) async {
    final response =
        await _dio.get('/profesores/$profesorId/horario');

    final Map<String, dynamic> raw =
        response.data['horario'] ?? {};

    return raw.map((dia, lista) {
      final items = (lista as List)
          .map((e) => Asignacion.fromJson(e))
          .toList();

      return MapEntry(dia, items);
    });
  }

  Future<Map<String, List<HorarioItem>>> getHorarioCurso({
    required int periodoId,
    required int cursoId,
    required int paraleloId,
  }) async {
    final response = await _dio.get(
      '/periodos/$periodoId/cursos/$cursoId/paralelos/$paraleloId/horario',
    );

    final Map<String, dynamic> raw =
        response.data['horario'] as Map<String, dynamic>? ?? {};

    return raw.map((dia, lista) {
      final items = (lista as List)
          .map(
            (e) =>
                HorarioItem.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      return MapEntry(dia, items);
    });
  }

 /*  Future<void> crearAsignacion({
    required int periodoId,
    required int profesorId,
    required int subjectId,
    required int cursoId,
    required int paraleloId,
    required String dia,
    required String horaInicio,
    required String horaFin,
  }) async {
    await _dio.post(
      '/periodos/$periodoId/asignaciones',
      data: {
        'profesor_id': profesorId,
        'subject_id': subjectId,
        'curso_id': cursoId,
        'paralelo_id': paraleloId,
        'dia': dia,
        'hora_inicio': horaInicio,
        'hora_fin': horaFin,
      },
    );
  }
 */
  
  Future<void> crearAsignacion({
  required int periodoId,
  required int profesorId,
  required int subjectId,
  required int cursoId,
  required int paraleloId,
  required String dia,
  required String horaInicio,
  required String horaFin,
}) async {
  await _dio.post(
    '/periodos/$periodoId/asignaciones',
    data: {
      'profesor_id': profesorId,
      'subject_id': subjectId,
      'curso_id': cursoId,
      'paralelo_id': paraleloId,
      'horarios': [
        {
          'dia': dia,
          'hora_inicio': horaInicio,
          'hora_fin': horaFin,
        }
      ]
    },
  );
}
  Future<List<MiClase>> getMisClases(
    int periodoId,
  ) async {
    final response = await _dio.get(
      '/periodos/$periodoId/asignaciones/mis-clases',
    );

    final List data =
        response.data['asignaciones'] ?? [];

    return data
        .map((e) => MiClase.fromJson(e))
        .toList();
  }
}
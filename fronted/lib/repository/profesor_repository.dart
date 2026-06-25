import 'package:dio/dio.dart';
import '../models/profesor.dart';
import '../models/subject.dart';

class ProfesorRepository {
  final Dio _dio;

  ProfesorRepository(this._dio);

  Future<List<Profesor>> getProfesores() async {

    final response = await _dio.get('/profesores');

    return (response.data as List)
        .map((e) => Profesor.fromJson(e))
        .toList();
  }

  // materias de un profesor
  Future<List<Subject>> getSubjectsByProfesor(
    int profesorId,
  ) async {

    final response =
        await _dio.get('/profesores/$profesorId/subjects');

    final List data = response.data['data'];

    return data
        .map((e) => Subject.fromJson(e))
        .toList();
  }

  // CREAR
  Future<Profesor> createProfesor({
    required String name,
    required String email,
    required String password,
    required String codigo,
    String? especialidad,
  }) async {

    final response = await _dio.post(
      '/profesores',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'codigo_profesor': codigo,
        'especialidad': especialidad,
      },
    );

    return Profesor.fromJson(
      response.data['data'],
    );
  }

  // ASIGNAR MATERIA
  Future<void> asignarMateria({
    required int profesorId,
    required int subjectId,
  }) async {

    await _dio.post(
      '/profesores/asignar-materia',
      data: {
        'profesor_id': profesorId,
        'subject_id': subjectId,
      },
    );
  }

  // ELIMINAR
  Future<void> deleteProfesor(int id) async {

    await _dio.delete('/profesores/$id');
  }

  Future<Profesor> getProfesorById(int id) async {
  final response = await _dio.get('/profesores/$id');

  return Profesor.fromJson(
    response.data,
  );
}

Future<Profesor> updateProfesor({
  required int id,
  required String name,
  required String email,
  String? password,
  required String codigo,
  String? especialidad,
}) async {

  final response = await _dio.put(
    '/profesores/$id',
    data: {
      'name': name,
      'email': email,
      'password': password,
      'codigo_profesor': codigo,
      'especialidad': especialidad,
    },
  );

  return Profesor.fromJson(
    response.data,
  );
}
}
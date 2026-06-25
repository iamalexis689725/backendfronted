import 'package:dio/dio.dart';
import '../models/estudiante.dart';

class EstudianteRepository {
  final Dio _dio;
  EstudianteRepository(this._dio);

  Future<List<Estudiante>> getEstudiantes() async {
    
      final response = await _dio.get('/estudiantes');
      return (response.data as List)
          .map((e) => Estudiante.fromJson(e))
          .toList();
    
  }

  Future<Estudiante> createEstudiante({
    required String name,
    required String email,
    required String password,
    required String codigo,
  }) async {
    
      final response = await _dio.post('/estudiantes', data: {
        'name': name,
        'email': email,
        'password': password,
        'codigo_estudiante': codigo,
      });
      return Estudiante.fromJson(response.data['data']);
  }

  Future<void> deleteEstudiante(int id) async {
      await _dio.delete('/estudiantes/$id');
  }

  Future<Estudiante> getEstudiante(int id) async {
  final response = await _dio.get('/estudiantes/$id');

  return Estudiante.fromJson(response.data);
}

Future<Estudiante> updateEstudiante({
  required int id,
  required String name,
  required String email,
  required String codigo,
  String? password,
}) async {
  final Map<String, dynamic> data = {
    "name": name,
    "email": email,
    "codigo_estudiante": codigo,
  };

  if (password != null && password.isNotEmpty) {
    data["password"] = password;
  }

  final response = await _dio.put(
    "/estudiantes/$id",
    data: data,
  );

  return Estudiante.fromJson(response.data["data"]);
}
}
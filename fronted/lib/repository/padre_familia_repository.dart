import 'package:dio/dio.dart';
import '../models/padre_familia.dart';
import '../models/estudiante.dart';
import '../models/padre_hijo.dart';

class PadreFamiliaRepository {
  final Dio _dio;
  PadreFamiliaRepository(this._dio);

  Future<List<PadreFamilia>> getPadres() async {
      final response = await _dio.get('/padre-familias');
      return (response.data as List)
          .map((e) => PadreFamilia.fromJson(e))
          .toList();
    }

  Future<PadreFamilia> createPadre({
    required String name,
    required String email,
    required String password,
    String? telefono,
    String? ocupacion,
  }) async {
   
      final response = await _dio.post('/padre-familias', data: {
        'name': name,
        'email': email,
        'password': password,
        'telefono': telefono,
        'ocupacion': ocupacion,
      });
      return PadreFamilia.fromJson(response.data['data']);
    
  }

  Future<void> deletePadre(int id) async {
    
      await _dio.delete('/padre-familias/$id');
  }
  Future<PadreFamilia> getPadreById(int id) async {
  final response = await _dio.get(
    '/padre-familias/$id',
  );

  return PadreFamilia.fromJson(
    response.data,
  );
}
Future<List<PadreHijo>> getMisHijos() async {

  final response = await _dio.get(
    "/padre/mis-hijos",
  );

  final List lista =
      response.data["estudiantes"];

  return lista
      .map((e) => PadreHijo.fromJson(e))
      .toList();
}

Future<PadreFamilia> updatePadre({
  required int id,
  required String name,
  required String email,
  String? password,
  String? telefono,
  String? ocupacion,
}) async {
  final response = await _dio.put(
    '/padre-familias/$id',
    data: {
      "name": name,
      "email": email,
      "password": password,
      "telefono": telefono,
      "ocupacion": ocupacion,
    },
  );

  return PadreFamilia.fromJson(
    response.data["data"],
  );
}
Future<void> asignarEstudiante({
  required int padreId,
  required int estudianteId,
  String? parentesco,
}) async {

  await _dio.post(
    '/padre-familias/asignar-estudiante',
    data: {
      "padre_familia_id": padreId,
      "estudiante_id": estudianteId,
      "parentesco": parentesco,
    },
  );
}

Future<List<Estudiante>> getEstudiantesPadre(
  int padreId,
) async {

  final response = await _dio.get(
    '/padre-familias/$padreId/estudiantes',
  );

  final List data = response.data["estudiantes"];

  return data
      .map((e) => Estudiante(
            id: e["id"],
            codigoEstudiante: e["codigo_estudiante"],
            name: e["nombre"],
          ))
      .toList();
}
}
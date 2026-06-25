import 'package:dio/dio.dart';
import '../models/subject.dart';

class SubjectRepository {
  final Dio _dio;

  SubjectRepository(this._dio);

  Future<Subject> createSubject(String name) async {
      final response = await _dio.post(
        '/subjects',
        data: {
          'name': name,
        },
      );

      return Subject.fromJson(response.data);
  }
  Future<Subject> getSubjectById(int id) async {

  final response = await _dio.get(
    '/subjects/$id',
  );

  return Subject.fromJson(
    response.data,
  );
}

  Future<List<Subject>> getSubjects() async {
      final response = await _dio.get('/subjects');

      print("GET SUBJECTS: ${response.data}");

      return (response.data as List)
          .map((e) => Subject.fromJson(e))
          .toList();
  }
  Future<Subject> updateSubject({
  required int id,
  required String name,
}) async {

  final response = await _dio.put(
    '/subjects/$id',
    data: {
      'name': name,
    },
  );

  return Subject.fromJson(
    response.data,
  );
}
Future<void> deleteSubject(int id) async {

  await _dio.delete(
    '/subjects/$id',
  );
}

}
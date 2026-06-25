import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/subject.dart';
import '../repository/subject_repository.dart';
import '../core/utils/api_error_handler.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository repository;

  bool loading = false;
  bool creating = false;
  bool updating = false;
  String? error;
  List<Subject> subjects = [];

  SubjectViewModel({required this.repository});

  
  Future<bool> createSubject(String name) async {
    if (creating) return false; 
    creating = true;
    error = null;
    notifyListeners();

    try {
      final subject = await repository.createSubject(name);

      subjects.add(subject);
      return true;
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);

      return false;
    } catch (e) {
      error = 'Error inesperado';

      return false;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  // LISTAR
  Future<void> loadSubjects() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      subjects = await repository.getSubjects();
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (e) {
      error = 'Error inesperado';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
  Future<Subject?> getSubjectById(int id) async {

  try {

    return await repository.getSubjectById(id);

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    notifyListeners();

    return null;

  } catch (_) {

    error = 'Error inesperado';

    notifyListeners();

    return null;
  }
}
Future<bool> updateSubject({
  required int id,
  required String name,
}) async {

  if (updating) return false;

  updating = true;

  error = null;

  notifyListeners();

  try {

    final subject =
        await repository.updateSubject(
      id: id,
      name: name,
    );

    final index = subjects.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {
      subjects[index] = subject;
    }

    return true;

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    return false;

  } catch (_) {

    error = 'Error inesperado';

    return false;

  } finally {

    updating = false;

    notifyListeners();
  }
}
Future<bool> deleteSubject(int id) async {

  loading = true;

  error = null;

  notifyListeners();

  try {

    await repository.deleteSubject(id);

    subjects.removeWhere(
      (e) => e.id == id,
    );

    return true;

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    return false;

  } catch (_) {

    error = 'Error inesperado';

    return false;

  } finally {

    loading = false;

    notifyListeners();
  }
}
}

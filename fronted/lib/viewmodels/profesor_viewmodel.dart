import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/profesor.dart';
import '../models/subject.dart';
import '../repository/profesor_repository.dart';
import '../core/utils/api_error_handler.dart';

class ProfesorViewModel extends ChangeNotifier {

  final ProfesorRepository repository;

  bool loading = false;
  bool creating = false;
  bool assigning = false;
  bool updating = false;

  String? error;

  List<Profesor> profesores = [];

  List<Subject> subjectsProfesor = [];

  ProfesorViewModel({
    required this.repository,
  });

  // =========================
  // LISTAR
  // =========================

  Future<void> loadProfesores() async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      profesores =
          await repository.getProfesores();

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

    } catch (e) {

      error = 'Error inesperado';

    } finally {

      loading = false;
      notifyListeners();
    }
  }

  // =========================
  // MATERIAS DEL PROFESOR
  // =========================

  Future<void> loadSubjectsProfesor(
    int profesorId,
  ) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      subjectsProfesor =
          await repository.getSubjectsByProfesor(
        profesorId,
      );

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

    } catch (e) {

      error = 'Error inesperado';

    } finally {

      loading = false;
      notifyListeners();
    }
  }

  // =========================
  // CREAR
  // =========================

  Future<bool> createProfesor({
    required String name,
    required String email,
    required String password,
    required String codigo,
    String? especialidad,
  }) async {

    if (creating) return false;

    creating = true;

    error = null;

    notifyListeners();

    try {

      final profesor =
          await repository.createProfesor(
        name: name,
        email: email,
        password: password,
        codigo: codigo,
        especialidad: especialidad,
      );

      profesores.add(profesor);

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

  // =========================
  // ASIGNAR MATERIA
  // =========================

  Future<bool> asignarMateria({
    required int profesorId,
    required int subjectId,
  }) async {

    if (assigning) return false;

    assigning = true;

    error = null;

    notifyListeners();

    try {

      await repository.asignarMateria(
        profesorId: profesorId,
        subjectId: subjectId,
      );

      return true;

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

      return false;

    } catch (e) {

      error = 'Error inesperado';

      return false;

    } finally {

      assigning = false;
      notifyListeners();
    }
  }

  // =========================
  // ELIMINAR
  // =========================

  Future<bool> deleteProfesor(int id) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      await repository.deleteProfesor(id);

      profesores.removeWhere(
        (e) => e.id == id,
      );

      return true;

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

      return false;

    } catch (e) {

      error = 'Error inesperado';

      return false;

    } finally {

      loading = false;
      notifyListeners();
    }
  }
  Future<Profesor?> getProfesorById(
  int id,
) async {

  try {

    return await repository.getProfesorById(id);

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    notifyListeners();

    return null;

  } catch (_) {

    error = "Error inesperado";

    notifyListeners();

    return null;
  }
}
Future<bool> updateProfesor({

  required int id,

  required String name,

  required String email,

  String? password,

  required String codigo,

  String? especialidad,

}) async {

  if (updating) return false;

  updating = true;

  error = null;

  notifyListeners();

  try {

    final profesor =
        await repository.updateProfesor(

      id: id,

      name: name,

      email: email,

      password: password,

      codigo: codigo,

      especialidad: especialidad,
    );

    final index = profesores.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {

      profesores[index] = profesor;
    }

    return true;

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    return false;

  } catch (_) {

    error = "Error inesperado";

    return false;

  } finally {

    updating = false;

    notifyListeners();
  }
}
}
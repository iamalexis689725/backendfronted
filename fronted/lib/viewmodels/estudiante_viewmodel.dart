import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/estudiante.dart';
import '../repository/estudiante_repository.dart';
import '../core/utils/api_error_handler.dart';

class EstudianteViewModel extends ChangeNotifier {
  final EstudianteRepository repository;
  EstudianteViewModel({required this.repository});

  bool loading = false;
  bool creating = false;
  bool updating = false;
  String? error;
  List<Estudiante> estudiantes = [];

  Future<void> loadEstudiantes() async {
    loading = true;
    error = null;
    notifyListeners();
    try{
        estudiantes = await repository.getEstudiantes();
    
   } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

  } catch (e) {

    error = 'Error inesperado';

  } finally {
    loading = false;
    notifyListeners();
  }}

  Future<bool> createEstudiante({
    required String name,
    required String email,
    required String password,
    required String codigo,
  }) async {
    if (creating) return false; 

    creating = true;
    error = null;
    notifyListeners();

    try{
      final estudiante = await repository.createEstudiante(
        name: name,
        email: email,
        password: password,
        codigo: codigo,
      );
      estudiantes.add(estudiante);
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

  Future<bool> deleteEstudiante(int id) async {
    loading = true;
      error = null;
    notifyListeners();
    try{
      await repository.deleteEstudiante(id);

  estudiantes.removeWhere((e) => e.id == id);
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
  Future<Estudiante?> getEstudiante(
  int id,
) async {
  try {
    return await repository.getEstudiante(id);
  } on DioException catch (e) {
    error = ApiErrorHandler.handle(e);
    notifyListeners();
    return null;
  }
}
Future<bool> updateEstudiante({
  required int id,
  required String name,
  required String email,
  required String codigo,
  String? password,
}) async {
  updating = true;
  error = null;

  notifyListeners();

  try {
    final estudiante =
        await repository.updateEstudiante(
      id: id,
      name: name,
      email: email,
      codigo: codigo,
      password: password,
    );

    final index = estudiantes.indexWhere(
      (e) => e.id == id,
    );

    if (index != -1) {
      estudiantes[index] = estudiante;
    }

    return true;
  } on DioException catch (e) {
    error = ApiErrorHandler.handle(e);
    return false;
  } catch (e) {
    error = "Error inesperado";
    return false;
  } finally {
    updating = false;
    notifyListeners();
  }
}
}  
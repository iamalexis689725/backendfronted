import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/utils/api_error_handler.dart';
import '../models/padre_familia.dart';
import '../repository/padre_familia_repository.dart';
import '../models/estudiante.dart';
import '../models/padre_hijo.dart';

class PadreFamiliaViewModel extends ChangeNotifier {
  final PadreFamiliaRepository repository;
  PadreFamiliaViewModel({required this.repository});

  bool loading = false;
  bool creating = false;
  bool updating = false;
  bool assigning = false;
  String? error;
  List<PadreFamilia> padres = [];
  List<Estudiante> estudiantesPadre = [];
  List<PadreHijo> misHijos = [];

  Future<void> loadPadres() async {
    loading = true;
    error = null;
    notifyListeners();
    try{
         padres = await repository.getPadres();
    }on DioException catch (e){
      error = ApiErrorHandler.handle(e);
    }catch(e){
      error = 'Error inesperado';
    }
    finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createPadre({
    required String name,
    required String email,
    required String password,
    String? telefono,
    String? ocupacion,
  }) async {
    if(creating) return false;

    creating = true;
    error = null;
    notifyListeners();
    try {
      final padre = await repository.createPadre(
        name: name, email: email, password: password,
        telefono: telefono, ocupacion: ocupacion,
      );
      padres.add(padre);
      return true;
      }on DioException catch (e) {
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

  Future<bool> deletePadre(int id) async {
    loading = true;
      error = null;
    notifyListeners();
    try{
     await repository.deletePadre(id);
      padres.removeWhere((p) => p.id == id);
      return true;
    }on DioException catch (e) {
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
  Future<PadreFamilia?> getPadreById(
  int id,
) async {
  try {
    return await repository.getPadreById(id);
  } on DioException catch (e) {
    error = ApiErrorHandler.handle(e);
    notifyListeners();
    return null;
  } catch (e) {
    error = "Error inesperado";
    notifyListeners();
    return null;
  }
}
Future<void> loadMisHijos() async {

  loading = true;
  error = null;

  notifyListeners();

  try {

    misHijos =
        await repository.getMisHijos();

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

  } catch (e) {

    error = "Error inesperado";

  } finally {

    loading = false;

    notifyListeners();
  }
}
Future<bool> updatePadre({
  required int id,
  required String name,
  required String email,
  String? password,
  String? telefono,
  String? ocupacion,
}) async {

  updating = true;
  error = null;

  notifyListeners();

  try {

    final padre = await repository.updatePadre(
      id: id,
      name: name,
      email: email,
      password: password,
      telefono: telefono,
      ocupacion: ocupacion,
    );

    final index = padres.indexWhere(
      (p) => p.id == id,
    );

    if (index != -1) {
      padres[index] = padre;
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
Future<void> loadEstudiantesPadre(
  int padreId,
) async {

  loading = true;
  error = null;

  notifyListeners();

  try {

    estudiantesPadre =
        await repository.getEstudiantesPadre(
      padreId,
    );

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

  } catch (e) {

    error = "Error inesperado";

  } finally {

    loading = false;

    notifyListeners();
  }
}
Future<bool> asignarEstudiante({
  required int padreId,
  required int estudianteId,
  String? parentesco,
}) async {

  if (assigning) return false;

  assigning = true;

  error = null;

  notifyListeners();

  try {

    await repository.asignarEstudiante(
      padreId: padreId,
      estudianteId: estudianteId,
      parentesco: parentesco,
    );

    return true;

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    return false;

  } catch (e) {

    error = "Error inesperado";

    return false;

  } finally {

    assigning = false;

    notifyListeners();
  }
}
}
    
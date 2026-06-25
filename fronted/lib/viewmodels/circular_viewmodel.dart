import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/circular.dart';
import '../repository/circular_repository.dart';
import '../core/utils/api_error_handler.dart';

class CircularViewModel extends ChangeNotifier {
  final CircularRepository repository;
  CircularViewModel({required this.repository});

  bool loading  = false;
  bool creating = false;
  String? error;
  List<Circular> circulares = [];
   Circular? selected;

  Future<void> loadCirculares() async {

  loading = true;

  error = null;

  notifyListeners();

  try {

    circulares = await repository.getCirculares();

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

  } catch (e) {

    error = 'Error inesperado';

  } finally {

    loading = false;

    notifyListeners();
  }
}
  Future<void> loadCircularDetail(int id) async {

  loading = true;

  error = null;

  notifyListeners();

  try {

    selected = await repository.getCircularById(id);

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

  } catch (e) {

    error = 'Error inesperado';

  } finally {

    loading = false;

    notifyListeners();
  }
}


  Future<bool> createCircular({
  required String titulo,
  required String contenido,
  required String target,
}) async {

  if (creating) return false;

  creating = true;

  error = null;

  notifyListeners();

  try {

    await repository.createCircular(
      titulo: titulo,
      contenido: contenido,
      target: target,
    );

    await loadCirculares();

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
 Future<bool> marcarLeido(int id) async {

  error = null;

  notifyListeners();

  try {

    await repository.marcarLeido(id);

    final idx =
        circulares.indexWhere((c) => c.id == id);

    if (idx != -1) {

      circulares[idx] = Circular(
        id: circulares[idx].id,
        titulo: circulares[idx].titulo,
        contenido: circulares[idx].contenido,
        target: circulares[idx].target,
        publishedAt: circulares[idx].publishedAt,
        leido: true,
        creadoPor: circulares[idx].creadoPor,
      );

      notifyListeners();
    }

    return true;

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    return false;

  } catch (e) {

    error = 'Error inesperado';

    return false;
  }
}
Future<bool> deleteCircular(int id) async {

  loading = true;

  error = null;

  notifyListeners();

  try {

    await repository.deleteCircular(id);

    circulares.removeWhere((c) => c.id == id);

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
}
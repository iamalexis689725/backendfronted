import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/criterio.dart';
import '../repository/criterio_repository.dart';
import '../core/utils/api_error_handler.dart';
import '../models/periodo_evaluacion.dart'; 

class CriterioViewModel extends ChangeNotifier {
  final CriterioRepository repository;

  CriterioViewModel({
    required this.repository,
  });

  List<Criterio> criterios = [];
  List<PeriodoEvaluacion> periodosEvaluacion = [];

  bool loading = false;
  bool creating = false;

  String? error;

  Future<void> loadCriterios(
    int asignacionId,
  ) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      criterios =
          await repository.getCriterios(
        asignacionId,
      );
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> crearCriterio({
    required int asignacionId,
    required int periodoEvaluacionId,
    required String nombre,
    required double porcentaje,
  }) async {
    creating = true;
    error = null;

    notifyListeners();

    try {
      await repository.crearCriterio(
        asignacionId: asignacionId,
        periodoEvaluacionId: periodoEvaluacionId,
        nombre: nombre,
        porcentaje: porcentaje,
      );

      await loadCriterios(asignacionId);

      return true;
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);

      return false;
    } finally {
      creating = false;
      notifyListeners();
    }
  }
  Future<bool> actualizarCriterio({
  required int criterioId,
  required int asignacionId,
  required String nombre,
  required double porcentaje,
}) async {
  creating = true;
  error = null;

  notifyListeners();

  try {
    await repository.actualizarCriterio(
      criterioId: criterioId,
      nombre: nombre,
      porcentaje: porcentaje,
    );

    await loadCriterios(asignacionId);

    return true;
  } on DioException catch (e) {
    error = ApiErrorHandler.handle(e);
    return false;
  } finally {
    creating = false;
    notifyListeners();
  }
}

  Future<void> eliminarCriterio({
    required int asignacionId,
    required int criterioId,
  }) async {
    await repository.eliminarCriterio(
      criterioId,
    );

    await loadCriterios(asignacionId);
  }

  Future<void> loadPeriodosEvaluacion(
  int asignacionId,
) async {

  try {

    periodosEvaluacion =
        await repository.getPeriodosEvaluacion(
      asignacionId,
    );

    notifyListeners();

  } on DioException catch (e) {

    error = ApiErrorHandler.handle(e);

    notifyListeners();

  }

}
}
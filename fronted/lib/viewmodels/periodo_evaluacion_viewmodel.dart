import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/periodo_evaluacion.dart';
import '../repository/periodo_evaluacion_repository.dart';
import '../core/utils/api_error_handler.dart';

class PeriodoEvaluacionViewModel
    extends ChangeNotifier {

  final PeriodoEvaluacionRepository repository;

  PeriodoEvaluacionViewModel({
    required this.repository,
  });

  bool loading = false;
  bool creating = false;

  String? error;

  List<PeriodoEvaluacion> periodosEvaluacion = [];

  Future<void> loadPeriodosEvaluacion(
    int periodoId,
  ) async {

    loading = true;
    error = null;

    notifyListeners();

    try {

      periodosEvaluacion =
          await repository.getPeriodosEvaluacion(
        periodoId,
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

  Future<bool> createPeriodoEvaluacion({
    required int periodoId,
    required String nombre,
    required int orden,
  }) async {

    if (creating) return false;

    creating = true;
    error = null;

    notifyListeners();

    try {

      final nuevo =
          await repository.createPeriodoEvaluacion(
        periodoId: periodoId,
        nombre: nombre,
        orden: orden,
      );

      periodosEvaluacion.add(nuevo);

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
}
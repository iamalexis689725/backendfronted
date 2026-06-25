import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../core/utils/api_error_handler.dart';
import '../models/padre_asistencia.dart';
import '../repository/padre_asistencia_repository.dart';

class PadreAsistenciaViewModel
    extends ChangeNotifier {

  final PadreAsistenciaRepository repository;

  PadreAsistenciaViewModel({
    required this.repository,
  });

  bool loading = false;

  String? error;

  List<String> materias = [];

  List<PadreAsistencia> faltas = [];

  int totalFaltas = 0;

  Future<void> loadAsistenciasHijo(
    int estudianteId, {
    String? materia,
  }) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      final response =
          await repository.getAsistenciasHijo(
        estudianteId,
        materia: materia,
      );

      materias = response.materias;

      faltas = response.faltas;

      totalFaltas =
          response.totalFaltas;

    } on DioException catch (e) {

      error =
          ApiErrorHandler.handle(e);

    } catch (e) {

      error = 'Error inesperado';

    } finally {

      loading = false;

      notifyListeners();
    }
  }

  void clear() {

    materias.clear();

    faltas.clear();

    totalFaltas = 0;

    error = null;

    notifyListeners();
  }
}
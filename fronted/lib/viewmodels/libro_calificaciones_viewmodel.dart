import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../core/utils/api_error_handler.dart';
import '../models/libro_calificaciones.dart';
import '../models/periodo_evaluacion.dart';
import '../repository/libro_calificaciones_repository.dart';

class LibroCalificacionesViewModel extends ChangeNotifier {
  final LibroCalificacionesRepository repository;

  LibroCalificacionesViewModel({
    required this.repository,
  });

  bool loading = false;
  bool saving = false;

  String? error;

  List<PeriodoEvaluacion> periodosEvaluacion = [];

  PeriodoEvaluacion? periodoSeleccionado;

  List<CriterioLibro> criterios = [];

  List<EstudianteLibro> estudiantes = [];

  Future<void> loadPeriodos(
    int asignacionId,
  ) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      periodosEvaluacion =
          await repository.getPeriodosAsignacion(
        asignacionId,
      );

      if (periodosEvaluacion.isNotEmpty) {
        periodoSeleccionado =
            periodosEvaluacion.first;

        await loadLibro(
          asignacionId,
          periodoSeleccionado!.id!,
        );
      }
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadLibro(
    int asignacionId,
    int periodoId,
  ) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      final libro =
          await repository.getLibroCalificaciones(
        asignacionId: asignacionId,
        periodoId: periodoId,
      );

      criterios = libro.criterios;

      estudiantes = libro.estudiantes;
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void seleccionarPeriodo(
    int asignacionId,
    PeriodoEvaluacion periodo,
  ) {
    periodoSeleccionado = periodo;

    loadLibro(
      asignacionId,
      periodo.id!,
    );

    notifyListeners();
  }

  void actualizarNota({
    required int estudianteId,
    required int criterioId,
    required double nota,
  }) {
    for (final estudiante in estudiantes) {
      if (estudiante.estudianteId ==
          estudianteId) {
        for (final n in estudiante.notas) {
          if (n.criterioId == criterioId) {
            n.nota = nota;
          }
        }
      }
    }

    notifyListeners();
  }

  Future<void> guardarNotas(  int asignacionId,) async {
    saving = true;
    error = null;

    notifyListeners();

    try {
      for (final criterio in criterios) {
        final List<Map<String, dynamic>>
            notas = [];

        for (final estudiante
            in estudiantes) {
          final nota = estudiante.notas.firstWhere(
            (n) =>
                n.criterioId ==
                criterio.id,
          );

          notas.add({
            "estudiante_id":
                estudiante.estudianteId,
            "nota": nota.nota,
            "observacion": "",
          });
        }

        await repository.guardarNotas(
          criterioId: criterio.id,
          notas: notas,
        );
      }
      if (periodoSeleccionado != null) {
  await loadLibro(
    asignacionId,
    periodoSeleccionado!.id!,
  );
}
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
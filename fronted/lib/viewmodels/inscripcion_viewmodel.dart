import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/inscripcion.dart';
import '../models/academic_period.dart';

import '../repository/inscripcion_repository.dart';
import '../repository/academic_period_repository.dart';

import '../core/utils/api_error_handler.dart';

class InscripcionViewModel extends ChangeNotifier {

  final InscripcionRepository repository;
  final AcademicPeriodRepository periodoRepository;

  bool loading = false;
  bool creating = false;

  String? error;
  String? errorPeriodo;

  List<Inscripcion> inscripciones = [];

  List<AcademicPeriod> periodos = [];

  AcademicPeriod? periodoSeleccionado;

  InscripcionViewModel({
    required this.repository,
    required this.periodoRepository,
  });

  // =========================
  // CARGAR PERIODOS
  // =========================

  Future<void> loadPeriodos() async {

    loading = true;

    error = null;
    errorPeriodo = null;

    notifyListeners();

    try {

      periodos =
          await periodoRepository.getPeriodos();

      if (periodos.isEmpty) {

        errorPeriodo =
            'No hay periodos académicos';

        inscripciones = [];

        return;
      }

      periodoSeleccionado = periodos.firstWhere(
        (p) => p.activo == true,
        orElse: () => periodos.first,
      );

      await _cargarInscripciones();

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
  // CAMBIAR PERIODO
  // =========================

  Future<void> cambiarPeriodo(
    AcademicPeriod periodo,
  ) async {

    periodoSeleccionado = periodo;

    inscripciones = [];

    notifyListeners();

    await _cargarInscripciones();
  }

  // =========================
  // CARGAR INSCRIPCIONES
  // =========================

  Future<void> _cargarInscripciones() async {

    if (periodoSeleccionado?.id == null) {
      return;
    }

    loading = true;

    error = null;

    notifyListeners();

    try {

      inscripciones =
          await repository.getInscripciones(
        periodoSeleccionado!.id!,
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

  Future<bool> createInscripcion({
    required int periodoId,
    required int estudianteId,
    required int cursoId,
    required int paraleloId,
  }) async {

    if (creating) return false;

    creating = true;

    error = null;

    notifyListeners();

    try {

      await repository.createInscripcion(
        periodoId: periodoId,
        estudianteId: estudianteId,
        cursoId: cursoId,
        paraleloId: paraleloId,
      );

      // Recargar inscripciones para obtener datos completos
      await _cargarInscripciones();

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
  // ELIMINAR
  // =========================

  Future<bool> deleteInscripcion(
    int id,
  ) async {

    if (periodoSeleccionado == null) {
      return false;
    }

    loading = true;

    error = null;

    notifyListeners();

    try {

      await repository.deleteInscripcion(
        periodoSeleccionado!.id!,
        id,
      );

      inscripciones.removeWhere(
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
}
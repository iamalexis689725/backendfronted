import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/academic_period.dart';

import '../repository/academic_period_repository.dart';

import '../core/utils/api_error_handler.dart';

class AcademicPeriodViewModel extends ChangeNotifier {

  final AcademicPeriodRepository repository;

  bool loading = false;
  bool creating = false;

  String? error;

  List<AcademicPeriod> periodos = [];

  AcademicPeriod? periodoActivo;

  AcademicPeriodViewModel({
    required this.repository,
  });

  // =========================
  // LISTAR
  // =========================

  Future<void> loadPeriodos() async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      periodos = await repository.getPeriodos();

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
  // PERIODO ACTIVO
  // =========================

  Future<void> loadPeriodoActivo() async {

    error = null;

    notifyListeners();

    try {

      periodoActivo =
          await repository.getPeriodoActivo();

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

    } catch (e) {

      error = 'Error inesperado';
    }

    notifyListeners();
  }

  // =========================
  // CREAR
  // =========================

  Future<bool> createPeriodo({
    required String nombre,
    required String fechaInicio,
    required String fechaFin,
    bool activo = false,
  }) async {

    if (creating) return false;

    creating = true;

    error = null;

    notifyListeners();

    try {

      final periodo =
          await repository.createPeriodo(
        nombre: nombre,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        activo: activo,
      );

      periodos.add(periodo);

      if (periodo.activo == true) {
        periodoActivo = periodo;
      }

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
  // ACTIVAR
  // =========================

  Future<bool> activarPeriodo(int id) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      await repository.activarPeriodo(id);

      for (final p in periodos) {

        if (p.id == id) {

          periodoActivo = AcademicPeriod(
            id: p.id,
            nombre: p.nombre,
            fechaInicio: p.fechaInicio,
            fechaFin: p.fechaFin,
            activo: true,
          );
        }
      }

      await loadPeriodos();

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

  // =========================
  // ELIMINAR
  // =========================

  Future<bool> deletePeriodo(int id) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      await repository.deletePeriodo(id);

      periodos.removeWhere(
        (p) => p.id == id,
      );

      if (periodoActivo?.id == id) {
        periodoActivo = null;
      }

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
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/curso.dart';
import '../models/academic_period.dart';

import '../repository/curso_repository.dart';
import '../repository/academic_period_repository.dart';

import '../core/utils/api_error_handler.dart';

class CursoViewModel extends ChangeNotifier {

  final CursoRepository repository;
  final AcademicPeriodRepository periodoRepository;

  bool loading = false;
  bool creating = false;

  String? error;
  String? errorPeriodo;

  List<Curso> cursos = [];

  AcademicPeriod? periodoActivo;

  CursoViewModel({
    required this.repository,
    required this.periodoRepository,
  });

  // =========================
  // LISTAR
  // =========================

  Future<void> loadCursos() async {

    loading = true;

    error = null;
    errorPeriodo = null;

    notifyListeners();

    try {

      periodoActivo =
          await periodoRepository.getPeriodoActivo();

      if (periodoActivo == null) {

        errorPeriodo =
            'No hay periodo académico activo';

        cursos = [];

        return;
      }

      cursos = await repository.getCursos(
        periodoActivo!.id!,
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

  Future<bool> createCurso({
    required String nombre,
    required String nivel,
    String? descripcion,
  }) async {

    if (creating) return false;

    creating = true;

    error = null;

    notifyListeners();

    try {

      if (periodoActivo == null) {
        await loadCursos();

        if (periodoActivo == null) {
          return false;
        }
      }

      final curso = await repository.createCurso(
        periodoId: periodoActivo!.id!,
        nombre: nombre,
        nivel: nivel,
        descripcion: descripcion,
      );

      cursos.add(curso);

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

  Future<bool> deleteCurso(int id) async {

    if (periodoActivo == null) {
      return false;
    }

    loading = true;

    error = null;

    notifyListeners();

    try {

      await repository.deleteCurso(
        periodoActivo!.id!,
        id,
      );

      cursos.removeWhere((e) => e.id == id);

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
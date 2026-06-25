import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/asignacion.dart';
import '../models/academic_period.dart';
import '../models/horario_curso.dart';
import '../models/mi_clase.dart';

import '../repository/asignacion_repository.dart';
import '../repository/academic_period_repository.dart';

import '../core/utils/api_error_handler.dart';

class AsignacionViewModel extends ChangeNotifier {
  final AsignacionRepository repository;
  final AcademicPeriodRepository periodoRepository;

  AsignacionViewModel({
    required this.repository,
    required this.periodoRepository,
  });

  bool loading = false;
  bool creating = false;
  bool loadingCurso = false;
  bool loadingClases = false;

  String? error;

  AcademicPeriod? periodoActivo;

  Map<String, List<Asignacion>> horario = {};
  Map<String, List<HorarioItem>> horarioCurso = {};

  List<MiClase> misClases = [];

  List<AcademicPeriod> periodosProfesor = [];

  AcademicPeriod? periodoSeleccionadoClases;

  Future<void> loadPeriodo() async {
    try {
      periodoActivo =
          await periodoRepository.getPeriodoActivo();

      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadHorario(int profesorId) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      horario =
          await repository.getHorario(profesorId);
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> crearAsignacion({
    required int profesorId,
    required int subjectId,
    required int cursoId,
    required int paraleloId,
    required String dia,
    required String horaInicio,
    required String horaFin,
  }) async {
    if (creating) return false;

    creating = true;
    error = null;

    notifyListeners();

    try {
      if (periodoActivo == null) {
        await loadPeriodo();
      }

      if (periodoActivo?.id == null) {
        error = 'No hay periodo académico activo';
        return false;
      }

      await repository.crearAsignacion(
        periodoId: periodoActivo!.id!,
        profesorId: profesorId,
        subjectId: subjectId,
        cursoId: cursoId,
        paraleloId: paraleloId,
        dia: dia,
        horaInicio: horaInicio,
        horaFin: horaFin,
      );

      await loadHorario(profesorId);

      return true;
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);

      return false;
    } catch (_) {
      error = 'Error inesperado';

      return false;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  Future<void> loadHorarioCurso({
    required int cursoId,
    required int paraleloId,
  }) async {
    loadingCurso = true;
    error = null;

    notifyListeners();

    try {
      if (periodoActivo == null) {
        await loadPeriodo();
      }

      if (periodoActivo == null) {
        horarioCurso = {};
        return;
      }

      horarioCurso =
          await repository.getHorarioCurso(
        periodoId: periodoActivo!.id!,
        cursoId: cursoId,
        paraleloId: paraleloId,
      );
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loadingCurso = false;
      notifyListeners();
    }
  }

  Future<void> loadPeriodosYClases() async {
    loadingClases = true;
    error = null;

    notifyListeners();

    try {
      periodosProfesor =
          await periodoRepository.getPeriodos();

      if (periodosProfesor.isNotEmpty) {
        periodoSeleccionadoClases =
            periodosProfesor.firstWhere(
          (p) => p.activo == true,
          orElse: () => periodosProfesor.first,
        );

        await _cargarMisClases();
      }
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loadingClases = false;
      notifyListeners();
    }
  }

  Future<void> cambiarPeriodoClases(
    AcademicPeriod periodo,
  ) async {
    periodoSeleccionadoClases = periodo;

    misClases = [];

    notifyListeners();

    await _cargarMisClases();
  }

  Future<void> _cargarMisClases() async {
    if (periodoSeleccionadoClases?.id == null) return;

    loadingClases = true;

    notifyListeners();

    try {
      misClases = await repository.getMisClases(
        periodoSeleccionadoClases!.id!,
      );
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loadingClases = false;
      notifyListeners();
    }
  }
}
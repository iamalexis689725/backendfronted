import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/asistencia.dart';
import '../repository/asistencia_repository.dart';
import '../core/utils/api_error_handler.dart';

class AsistenciaViewModel extends ChangeNotifier {
  final AsistenciaRepository repository;

  AsistenciaViewModel({
    required this.repository,
  });

  bool loading = false;
  bool saving = false;

  String? error;

  Asistencia? asistencia;

  List<Asistencia> asistencias = [];

 
  Future<bool> registrarAsistencia({
    required int periodoId,
    required int asignacionId,
    required String fecha,
    required List<AsistenciaDetalle> asistencias,
  }) async {
    saving = true;
    error = null;

    notifyListeners();

    try {
      await repository.registrarAsistencia(
        periodoId: periodoId,
        asignacionId: asignacionId,
        fecha: fecha,
        asistencias: asistencias,
      );

      return true;
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
      return false;
    } catch (_) {
      error = 'Error inesperado';
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  Future<void> obtenerAsistencia({
    required int periodoId,
    required int asignacionId,
    required String fecha,
  }) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      asistencia = await repository.obtenerAsistencia(
        periodoId: periodoId,
        asignacionId: asignacionId,
        fecha: fecha,
      );
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

 
  Future<void> listarAsistencias({
    required int periodoId,
    required int asignacionId,
  }) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      asistencias = await repository.listarAsistencias(
        periodoId: periodoId,
        asignacionId: asignacionId,
      );
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  
  Future<bool> actualizarAsistencia({
    required int asistenciaId,
    required List<AsistenciaDetalle> asistencias,
  }) async {
    saving = true;
    error = null;

    notifyListeners();

    try {
      await repository.actualizarAsistencia(
        asistenciaId: asistenciaId,
        asistencias: asistencias,
      );

      return true;
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
      return false;
    } catch (_) {
      error = 'Error inesperado';
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
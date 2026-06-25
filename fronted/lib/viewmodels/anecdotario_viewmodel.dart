import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/anecdotario.dart';
import '../repository/anecdotario_repository.dart';
import '../core/utils/api_error_handler.dart';

class AnecdotarioViewModel extends ChangeNotifier {
  final AnecdotarioRepository repository;

  AnecdotarioViewModel({
    required this.repository,
  });

  bool loading = false;
  bool creating = false;

  String? error;
  List<Anecdotario> anecdotarios = [];

  Future<void> loadAnecdotarios({
    required int asignacionDocenteId,
    required int academicPeriodId,
  }) async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      anecdotarios = await repository.getAnecdotarios(
        asignacionDocenteId: asignacionDocenteId,
        academicPeriodId: academicPeriodId,
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

  Future<bool> createAnecdotario({
    required int estudianteId,
    required int asignacionDocenteId,
    required int academicPeriodId,
    required String tipo,
    required String titulo,
    required String descripcion,
    required String fecha,
  }) async {
    creating = true;
    error = null;

    notifyListeners();

    try {
      await repository.createAnecdotario(
        estudianteId: estudianteId,
        asignacionDocenteId: asignacionDocenteId,
        academicPeriodId: academicPeriodId,
        tipo: tipo,
          titulo: titulo,
        descripcion: descripcion,
        fecha: fecha,
      );

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

  Future<bool> deleteAnecdotario({
  required int anecdotarioId,
}) async {
  error = null;
  notifyListeners();

  try {
    await repository.deleteAnecdotario(anecdotarioId: anecdotarioId);
    // Recargar la lista después de eliminar
    anecdotarios.removeWhere((a) => a.id == anecdotarioId);
    notifyListeners();
    return true;
  } on DioException catch (e) {
    error = ApiErrorHandler.handle(e);
    notifyListeners();
    return false;
  } catch (_) {
    error = 'Error inesperado';
    notifyListeners();
    return false;
  }
}
}
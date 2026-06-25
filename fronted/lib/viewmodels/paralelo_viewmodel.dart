import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/paralelo.dart';
import '../repository/paralelo_repository.dart';
import '../core/utils/api_error_handler.dart';

class ParaleloViewModel extends ChangeNotifier {
  final ParaleloRepository repository;

  ParaleloViewModel({
    required this.repository,
  });

  bool loading = false;
  bool creating = false;

  String? error;

  List<Paralelo> paralelos = [];

  int? _periodoId;
  int? _cursoId;

  Future<void> loadParalelos() async {

    loading = true;
    error = null;

    notifyListeners();

    try {

      paralelos = await repository.getParalelos();

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

    } catch (e) {

      error = 'Error inesperado';

    } finally {

      loading = false;

      notifyListeners();
    }
  }

  Future<bool> createParalelo({
    required int cursoId,
    required String nombre,
    String? turno,
    int? capacidad,
  }) async {

    if (creating) return false;

    creating = true;
    error = null;

    notifyListeners();

    try {

      final nuevo = await repository.createParalelo(
        cursoId: cursoId,
        nombre: nombre,
        turno: turno,
        capacidad: capacidad,
      );

      paralelos.add(nuevo);

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

  Future<bool> deleteParalelo(int id) async {

    loading = true;
    error = null;

    notifyListeners();

    try {

      await repository.deleteParalelo(id);

      paralelos.removeWhere((p) => p.id == id);

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

  Future<void> loadParalelosByCurso(
    int periodoId,
    int cursoId,
  ) async {

    _periodoId = periodoId;
    _cursoId = cursoId;

    loading = true;
    error = null;

    notifyListeners();

    try {

      paralelos = await repository.getParalelosByCurso(
        periodoId,
        cursoId,
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

  Future<void> reload() async {

    if (_periodoId == null || _cursoId == null) return;

    await loadParalelosByCurso(
      _periodoId!,
      _cursoId!,
    );
  }
}
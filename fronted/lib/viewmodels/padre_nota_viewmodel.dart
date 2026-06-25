import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../core/utils/api_error_handler.dart';
import '../models/padre_nota.dart';
import '../repository/padre_nota_repository.dart';

class PadreNotaViewModel extends ChangeNotifier {
  final PadreNotaRepository repository;

  PadreNotaViewModel({required this.repository});

  bool loading = false;
  String? error;
  List<PeriodoNota> periodos = [];

  Future<void> loadBoleta(int estudianteId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      periodos = await repository.getBoleta(estudianteId);
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void clear() {
    periodos.clear();
    error = null;
    notifyListeners();
  }
}
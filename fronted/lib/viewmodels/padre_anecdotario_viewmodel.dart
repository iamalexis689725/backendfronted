import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/padre_anecdotario.dart';
import '../repository/padre_anecdotario_repository.dart';
import '../core/utils/api_error_handler.dart';

class PadreAnecdotarioViewModel
    extends ChangeNotifier {
  final PadreAnecdotarioRepository
      repository;

  PadreAnecdotarioViewModel({
    required this.repository,
  });

  bool loading = false;

  String? error;

  List<PadreAnecdotario>
      anecdotarios = [];

  Future<void> loadAnecdotarios(
    int estudianteId,
  ) async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      anecdotarios =
          await repository
              .getAnecdotarios(
        estudianteId,
      );
    } on DioException catch (e) {
      error =
          ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loading = false;

      notifyListeners();
    }
  }
}
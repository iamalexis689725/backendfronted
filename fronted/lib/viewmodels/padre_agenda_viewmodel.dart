import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../core/utils/api_error_handler.dart';
import '../models/padre_agenda.dart';
import '../repository/padre_agenda_repository.dart';

class PadreAgendaViewModel extends ChangeNotifier {

  final PadreAgendaRepository repository;

  PadreAgendaViewModel({
    required this.repository,
  });

  bool loading = false;

  String? error;

  List<PadreAgenda> agendas = [];

  Future<void> loadAgendasHijo(
    int estudianteId,
  ) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      agendas =
          await repository.getAgendasHijo(
        estudianteId,
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

  Future<void> refresh(
    int estudianteId,
  ) async {

    await loadAgendasHijo(
      estudianteId,
    );
  }

  void clear() {

    agendas.clear();

    error = null;

    notifyListeners();
  }
}
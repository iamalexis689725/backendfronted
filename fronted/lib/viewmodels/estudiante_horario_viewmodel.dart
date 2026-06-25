import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/utils/api_error_handler.dart';
import '../models/horario_curso.dart';
import '../repository/estudiante_horario_repository.dart';

class EstudianteHorarioViewModel extends ChangeNotifier {
  final EstudianteHorarioRepository repository;

  EstudianteHorarioViewModel({required this.repository});

  bool loading = false;
  String? error;

  /// Días ordenados → lista de clases
  Map<String, List<HorarioItem>> horario = {};

  static const _diasOrden = [
    'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado',
  ];

  Future<void> loadHorario() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final items = await repository.getHorario();

      // Agrupar por día y ordenar por hora_inicio
      final Map<String, List<HorarioItem>> agrupado = {};
      for (final item in items) {
        final dia = (item.dia ?? '').toLowerCase();
        agrupado.putIfAbsent(dia, () => []).add(item);
      }

      // Ordenar clases dentro de cada día
      for (final lista in agrupado.values) {
        lista.sort((a, b) =>
            (a.horaInicio ?? '').compareTo(b.horaInicio ?? ''));
      }

      // Construir mapa en orden correcto
      horario = {
        for (final dia in _diasOrden)
          if (agrupado.containsKey(dia)) dia: agrupado[dia]!,
      };
    } on DioException catch (e) {
      error = ApiErrorHandler.handle(e);
    } catch (_) {
      error = 'Error inesperado';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
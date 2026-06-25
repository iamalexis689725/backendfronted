import 'package:dio/dio.dart';

import '../models/padre_agenda.dart';

class PadreAgendaRepository {

  final Dio _dio;

  PadreAgendaRepository(
    this._dio,
  );

  Future<List<PadreAgenda>> getAgendasHijo(
    int estudianteId,
  ) async {

    final response = await _dio.get(
      '/padre/mis-hijos/$estudianteId/agendas',
    );

    final List agendas =
        response.data['agendas'];

    return agendas
        .map(
          (e) => PadreAgenda.fromJson(e),
        )
        .toList();
  }
}
import 'package:flutter/material.dart';
import '../models/estudiante_clase.dart';
import '../repository/inscripcion_repository.dart';

class EstudiantesClaseViewModel extends ChangeNotifier {
  final InscripcionRepository repository;

  EstudiantesClaseViewModel({
    required this.repository,
  });

  bool loading = false;
  String? error;

  List<EstudianteClase> estudiantes = [];

  int? _periodoId;
  int? _cursoId;
  int? _paraleloId;

  Future<void> load({
    required int periodoId,
    required int cursoId,
    required int paraleloId,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      _periodoId = periodoId;
      _cursoId = cursoId;
      _paraleloId = paraleloId;

      estudiantes = await repository.getEstudiantesPorClase(
        periodoId: periodoId,
        cursoId: cursoId,
        paraleloId: paraleloId,
      );
    } catch (e) {
      error = 'Error al cargar estudiantes';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> reload() async {
    if (_periodoId == null ||
        _cursoId == null ||
        _paraleloId == null) {
      return;
    }

    await load(
      periodoId: _periodoId!,
      cursoId: _cursoId!,
      paraleloId: _paraleloId!,
    );
  }
}
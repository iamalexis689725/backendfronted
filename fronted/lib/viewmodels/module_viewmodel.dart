import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/module.dart';
import '../repository/module_repository.dart';

class ModuleViewModel extends ChangeNotifier {

  final ModuleRepository repository;

  ModuleViewModel({
    required this.repository,
  });

  bool loading = false;

  String? error;

  List<ModuleModel> modules = [];

  // =========================
  // LISTAR
  // =========================

  Future<void> loadModules(
    int tenantId,
  ) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      modules = await repository.getModules(
        tenantId,
      );

    } on DioException catch (e) {

      error = e.message;

    } catch (e) {

      error = 'Error inesperado';

    } finally {

      loading = false;

      notifyListeners();
    }
  }

  // =========================
  // TOGGLE
  // =========================

  Future<void> toggleModule({
    required int tenantId,
    required int moduleId,
    required bool value,
  }) async {

    try {

      if (value) {

        await repository.activateModule(
          tenantId,
          moduleId,
        );

      } else {

        await repository.deactivateModule(
          tenantId,
          moduleId,
        );
      }

      final index = modules.indexWhere(
        (m) => m.id == moduleId,
      );

      if (index != -1) {

        modules[index] = ModuleModel(
          id: modules[index].id,
          codigo: modules[index].codigo,
          nombre: modules[index].nombre,
          descripcion:
              modules[index].descripcion,
          activo: value,
        );

        notifyListeners();
      }

    } catch (e) {

      error = 'Error al actualizar módulo';

      notifyListeners();
    }
  }
}
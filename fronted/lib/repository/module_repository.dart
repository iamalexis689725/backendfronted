import 'package:dio/dio.dart';

import '../models/module.dart';

class ModuleRepository {

  final Dio dio;

  ModuleRepository(this.dio);

  // =========================
  // LISTAR MODULOS
  // =========================

  Future<List<ModuleModel>> getModules(
    int tenantId,
  ) async {

    final response = await dio.get(
      '/tenants/$tenantId/modules',
    );

    return (response.data as List)
        .map(
          (e) => ModuleModel.fromJson(e),
        )
        .toList();
  }

  // =========================
  // ACTIVAR
  // =========================

  Future<void> activateModule(
    int tenantId,
    int moduleId,
  ) async {

    await dio.patch(
      '/tenants/$tenantId/modules/$moduleId/activate',
    );
  }

  // =========================
  // DESACTIVAR
  // =========================

  Future<void> deactivateModule(
    int tenantId,
    int moduleId,
  ) async {

    await dio.patch(
      '/tenants/$tenantId/modules/$moduleId/deactivate',
    );
  }
}
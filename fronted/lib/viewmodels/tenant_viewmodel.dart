import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../models/tenant.dart';
import '../models/tenant_response.dart';

import '../repository/tenant_repository.dart';

import '../core/utils/api_error_handler.dart';

class TenantViewModel extends ChangeNotifier {
  final TenantRepository repository;

  bool loading = false;
  bool creating = false;
  bool updating = false;
  bool uploading = false;

  String? error;

  TenantResponse? tenant;

  Tenant? currentTenant;

  List<Tenant> tenants = [];

  TenantViewModel({
    required this.repository,
  });

  // =========================
  // LISTAR TENANTS
  // =========================

  Future<void> loadTenants() async {
    loading = true;

    error = null;

    notifyListeners();

    try {

      tenants = await repository.getTenants();

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

    } catch (e) {

      error = 'Error inesperado';

    } finally {

      loading = false;

      notifyListeners();
    }
  }

  // =========================
  // MI TENANT
  // =========================

  Future<void> loadMyTenant() async {
    loading = true;

    error = null;

    notifyListeners();

    try {

      currentTenant = await repository.getMyTenant();

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

    } catch (e) {

      error = 'Error inesperado';

    } finally {

      loading = false;

      notifyListeners();
    }
  }

  // =========================
  // CREAR
  // =========================

  Future<bool> createTenant({
    required String name,
    required String slug,
    required String directorName,
    required String directorEmail,
    required String password,
  }) async {

    if (creating) return false;

    creating = true;

    error = null;

    notifyListeners();

    try {

      final createdTenant =
          await repository.createTenant(
        name: name,
        slug: slug,
        directorName: directorName,
        directorEmail: directorEmail,
        password: password,
      );

      tenant = createdTenant;
      if(createdTenant.tenant != null) {
      tenants.add(createdTenant.tenant!);
      }
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
  Future<bool> uploadLogo(XFile file) async {

    if (uploading) return false;

    uploading = true;

    error = null;

    notifyListeners();

    try {

      final bytes = await file.readAsBytes();

      final success =
          await repository.uploadLogo(
        bytes,
        file.name,
      );

      await loadMyTenant();

      return success;

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

      return false;

    } catch (e) {

      error = 'Error inesperado';

      return false;

    } finally {

      uploading = false;

      notifyListeners();
    }
  }

  Future<bool> updateTenant({
    required String name,
    required String slug,
  }) async {

    if (updating) return false;

    updating = true;

    error = null;

    notifyListeners();

    try {

      final updated =
          await repository.updateTenant(
        name: name,
        slug: slug,
      );

      currentTenant = updated;

      return true;

    } on DioException catch (e) {

      error = ApiErrorHandler.handle(e);

      return false;

    } catch (e) {

      error = 'Error inesperado';

      return false;

    } finally {

      updating = false;

      notifyListeners();
    }
  }
  Future<bool> deleteTenant(int id) async {

    loading = true;

    error = null;

    notifyListeners();

    try {

      await repository.deleteTenant(id);

      tenants.removeWhere(
        (t) => t.id == id,
      );

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
}
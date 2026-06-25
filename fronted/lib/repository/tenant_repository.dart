import 'package:dio/dio.dart';
import '../models/tenant_response.dart';
import '../models/tenant.dart';

class TenantRepository {
  final Dio _dio;

  TenantRepository(this._dio);

  Future<List<Tenant>> getTenants() async {
      final response = await _dio.get('/tenants');
      return (response.data as List)
          .map((e) => Tenant.fromJson(e))
          .toList();
  }

Future<Tenant> getMyTenant() async {
    final response = await _dio.get('/my-tenant');

    final data = response.data['data'];

    data['logo_url'] = response.data['logo_url'];

    return Tenant.fromJson(data);
}

  Future<TenantResponse> createTenant({
    required String name,
    required String slug,
    required String directorName,
    required String directorEmail,
    required String password,
  }) async {
      final response = await _dio.post(
        '/tenants',
        data: {
          'name': name,
          'slug': slug,
          'director_name': directorName,
          'director_email': directorEmail,
          'password': password,
        },
      );
      return TenantResponse.fromJson(response.data);
  }

  Future<bool> uploadLogo(List<int> bytes, String filename) async {
  
    final formData = FormData.fromMap({
      'logo': MultipartFile.fromBytes(bytes, filename: filename),
    });
    await _dio.post('/tenants/logo', data: formData);
    return true;
}

  //  EDITAR nombre y slug
  Future<Tenant> updateTenant({
    required String name,
    required String slug,
  }) async {
  
      final response = await _dio.put('/tenants', data: {
        'name': name,
        'slug': slug,
      });
      return Tenant.fromJson(response.data['data']);
  }

  Future<void> deleteTenant(int id) async {
      await _dio.delete('/tenants/$id');
  }

}
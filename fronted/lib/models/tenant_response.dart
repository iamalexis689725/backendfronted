import 'tenant.dart';

class TenantResponse {
  final Tenant? tenant;

  TenantResponse({this.tenant});

  factory TenantResponse.fromJson(Map<String, dynamic> json) {
    return TenantResponse(
      tenant: json['tenant'] != null
          ? Tenant.fromJson(json['tenant'])
          : null,
    );
  }
}
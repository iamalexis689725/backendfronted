import 'package:dio/dio.dart';

class ApiErrorHandler {

  static String handle(DioException e) {

    final data = e.response?.data;

    // Laravel validation errors
    if (data != null && data['errors'] != null) {

      final errors = data['errors'] as Map<String, dynamic>;

      final firstError = errors.values.first;

      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
    }

    // Generic backend message
    if (data != null && data['message'] != null) {
      return data['message'].toString();
    }

    // Dio/network errors
    switch (e.type) {

      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';

      case DioExceptionType.receiveTimeout:
        return 'Servidor no responde';

      case DioExceptionType.connectionError:
        return 'Sin conexión a internet';

      default:
        return 'Error inesperado';
    }
  }
}
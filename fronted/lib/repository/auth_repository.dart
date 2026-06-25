import 'package:dio/dio.dart';
import '../models/users.dart';

class AuthRepository {
     final Dio _dio;

      AuthRepository(this._dio);
 
  // LOGIN
  Future<Users> login(String email, String password) async {
      final response = await _dio.post(
       '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return Users.fromJson(response.data);
  
  }

  // REGISTER
 Future<Users> register({
  required String name,
  required String email,
  required String password,
}) async {
  
    final response = await _dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': 'super-admin', 
      },
    );

    return Users.fromJson(response.data);
 
}


Future<void> logout() async {
  try {
    await _dio.post('/auth/logout');
  } catch (e) {
    print("ERROR LOGOUT: $e");
  }
}
}
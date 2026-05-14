import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:n_leaks/core/constants/endpoints.dart';

class AuthService {
  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  static final AuthService _instance = AuthService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => true,
    ),
  );

  Future<Response> login(String email, String password) async {
    return await _dio.post(
      loginPath,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> getUserProfile(String token) async {
    return await _dio.get(
      userProfilePath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Response> getCompanyInfo(String token) async {
    return await _dio.get(
      companyInfoPath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Response> getUsers(String token) async {
    return await _dio.get(
      usersPath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Response> getLeaks(String token) async {
    return await _dio.get(
      leaksPath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}

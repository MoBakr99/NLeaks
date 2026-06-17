import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:n_leaks/core/constants/endpoints.dart';

class APIService {
  APIService._internal();

  factory APIService() {
    return _instance;
  }

  static final APIService _instance = APIService._internal();

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

  Future<Response> getUsers(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    return await _dio.get(
      usersPath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  Future<Response> getLeaks(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    return await _dio.get(
      leaksPath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  Future<Response> sendOTP(String email) async {
    return await _dio.post(otpPath, data: {'email': email});
  }

  Future<Response> verifyOTP(String email, String otp) async {
    return await _dio.post(verifyOtpPath, data: {'email': email, 'otp': otp});
  }

  Future<Response> resetPassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {
    return await _dio.post(
      resetPasswordPath,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Response> loginByNik(String nik, String password) async {
    try {
      final response = await _dio.post(
        'http://68.183.234.187:8080/api/v1/auth/nik',
        data: {
          'nik': nik,
          'password': password,
        },
      );

      if (response.statusCode == 401) {
        throw Exception('Failed to login: Invalid nik or password');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  Future<Response> loginByEmail(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://68.183.234.187:8080/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 401) {
        throw Exception('Failed to login: Invalid email or password');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    try {
      final response = await _dio.get(
        'http://68.183.234.187:8080/api/v1/auth/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } catch (error) {
      print('Error fetching profile: $error');
      throw error;
    }
  }
}

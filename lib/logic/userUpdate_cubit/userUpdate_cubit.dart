import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_links.dart';
import '../../data/userData.dart';
import 'userUpdate_states.dart';

class UserUpdateCubit extends Cubit<UserUpdateStates> {
  UserUpdateCubit() : super(UserUpdateInitialStates());

  final Dio _dio = Dio();

  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String gender,
  }) async {
    emit(UserUpdateLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        emit(UserUpdateErrorState('Authentication required. Please login again.'));
        return;
      }

      final response = await _dio.post(
        ApiLinks.userUpdateUrl,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'gender': gender,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        emit(UserUpdateSucessState());
      }
      else if (response.statusCode == 422) {
        // Handle validation errors
        final errors = response.data['data'] as Map<String, dynamic>;
        final errorMessage = errors.entries
            .map((e) => '${e.key}: ${(e.value as List).join(', ')}')
            .join('\n');
        emit(UserUpdateErrorState(errorMessage));
      }
      else {
        emit(UserUpdateErrorState(
          response.data['message'] ?? 'Failed to update profile',
        ));
      }
    } on DioException catch (e) {
      emit(UserUpdateErrorState(
        e.response?.data?['message'] ?? e.message ?? 'Network error occurred',
      ));
    } catch (e) {
      emit(UserUpdateErrorState('An unexpected error occurred'));
    }
  }

  void reset() {
    emit(UserUpdateInitialStates());
  }
}
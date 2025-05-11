import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_links.dart';
import 'logout_states.dart';

class LogoutCubit extends Cubit<logoutStates> {
  final Dio _dio;

  LogoutCubit({Dio? dio})
      : _dio = dio ?? Dio(),
        super(logoutInitialStates());

  Future<void> logout() async {
    emit(logoutLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token != null) {
        final response = await _dio.post(
          ApiLinks.logoutUrl,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            validateStatus: (status) => status! < 500,
          ),
        );

        if (response.statusCode != 200) {
          throw Exception(response.data['message'] ?? 'Logout failed');
        }
      }

      await _clearUserData(prefs);

      // Reset all cubits/blocs
      emit(logoutSuccessState(resetApp: true));

    } on DioException catch (e) {
      emit(logoutErrorState(e.response?.data['message'] ?? e.message ?? 'Network error'));
    } catch (e) {
      emit(logoutErrorState(e.toString()));
    }
  }

  Future<void> _clearUserData(SharedPreferences prefs) async {
    await prefs.clear(); // Clear ALL preferences, not just specific ones
  }
}
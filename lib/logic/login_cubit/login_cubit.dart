import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_links.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialStates());

  Dio request = Dio();

  Future<void> Login({
    required String email,
    required String pass,
  }) async {
    emit(LoginLoadingState());
    try {
      final response = await request.post(
        ApiLinks.loginUrl,
        data: {
          "email": email,
          "password": pass,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final userToken = response.data['data']['token'];
        final userName = response.data['data']['username'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', userToken);
        await prefs.setString('user_name', userName);

        emit(LoginSucessState());
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        emit(LoginErrorState("Login failed: ${response.data['message'] ?? 'Invalid credentials'}"));
      } else {
        emit(LoginErrorState("Unexpected error: ${response.statusCode} - ${response.data}"));
      }
    } on DioException catch (e) {
      emit(LoginErrorState("Dio error: ${e.response?.data ?? e.message}"));
    } catch (e) {
      emit(LoginErrorState("Unknown error: ${e.toString()}"));
    }
  }
}

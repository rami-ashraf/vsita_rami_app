import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:doctor_new_project/logic/signup_cubit/signup_state.dart';

import '../../core/api_links.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialStates());

  Dio request = Dio();

  Future<void> signUp({
    required String email,
    required String name,
    required String gender,
    required String phone,
    required String pass,
    required String confirmationPass,
  }) async {
    emit(SignUpLoadingState());
    try {
      final response = await request.post(
        ApiLinks.signUpUrl,
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "gender": gender,
          "password": pass,
          "password_confirmation": confirmationPass,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(SignUpSucessState());
      } else if (response.statusCode == 422) {
        emit(SignUpErrorState("Validation error: ${response.data}"));
      } else {
        emit(SignUpErrorState("Unexpected error: ${response.statusCode} - ${response.data}"));
      }
    } on DioException catch (e) {
      emit(SignUpErrorState("Dio error: ${e.response?.data ?? e.message}"));
    } catch (e) {
      emit(SignUpErrorState("Unknown error: ${e.toString()}"));
    }
  }
}

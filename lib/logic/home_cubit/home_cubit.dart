import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_links.dart';
import '../../data/userData.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialStates());

  Dio request = Dio();
  UserData? userData;

  Future<void> getUserProfile() async {
    emit(HomeLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        throw Exception('No user token found. Please login again.');
      }

      final response = await request.get(
        ApiLinks.userProfileUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        // Handle both list and map responses
        if (response.data['data'] is List) {
          // If it's a list, take the first item (or handle as needed)
          if ((response.data['data'] as List).isNotEmpty) {
            userData = UserData.fromJson((response.data['data'] as List).first);
          } else {
            throw Exception('No user data found in the response');
          }
        } else if (response.data['data'] is Map) {
          userData = UserData.fromJson(response.data['data']);
        } else {
          throw Exception('Invalid user data format');
        }

        emit(HomeSucessState());
      } else if (response.statusCode == 401) {
        emit(HomeErrorState("Session expired. Please login again."));
      } else {
        emit(HomeErrorState("Error: ${response.data['message'] ?? 'Unknown error'}"));
      }
    } on DioException catch (e) {
      emit(HomeErrorState("Network error: ${e.message}"));
    } catch (e) {
      emit(HomeErrorState("Unexpected error: ${e.toString()}"));
    }
  }

  UserData? get cachedUserData => userData;
}
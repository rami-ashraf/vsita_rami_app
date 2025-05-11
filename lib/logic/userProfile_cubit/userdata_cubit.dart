import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_links.dart';
import '../../data/userData.dart';
import 'userData_states.dart';

class UserProfileCubit extends Cubit<UserProfileStates> {
  UserProfileCubit() : super(UserProfileInitialStates());

  Dio request = Dio();
  UserData? userData;

  Future<void> getUserProfile() async {
    emit(UserProfileLoadingState());

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

        emit(UserProfileSucessState());
      } else if (response.statusCode == 401) {
        emit(UserProfileErrorState("Session expired. Please login again."));
      } else {
        emit(UserProfileErrorState("Error: ${response.data['message'] ?? 'Unknown error'}"));
      }
    } on DioException catch (e) {
      emit(UserProfileErrorState("Network error: ${e.message}"));
    } catch (e) {
      emit(UserProfileErrorState("Unexpected error: ${e.toString()}"));
    }
  }

  // Add this reset method
  void reset() {
    userData = null; // Clear cached user data
    emit(UserProfileInitialStates()); // Reset to initial state
  }

  UserData? get cachedUserData => userData;
}
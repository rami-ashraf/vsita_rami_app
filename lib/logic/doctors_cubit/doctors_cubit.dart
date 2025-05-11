import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_links.dart';
import '../../data/doctorData.dart';
import 'doctors_states.dart';

class DoctorsCubit extends Cubit<DoctorsStates> {
  DoctorsCubit() : super(DoctorsInitialStates());

  final Dio _dio = Dio();
  List<DoctorsData> doctorsList = [];

  Future<void> getDoctors() async {
    emit(DoctorsLoadingStates());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        emit(DoctorsErrorStates("User not logged in."));
        return;
      }

      final response = await _dio.get(
        ApiLinks.getDoctorsUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List data = response.data['data'];
        doctorsList = data.map((e) => DoctorsData.fromJson(e)).toList();
        emit(DoctorsSuccessStates(doctorsList));
      } else {
        emit(DoctorsErrorStates("Failed to load doctors: ${response.data['message'] ?? 'Unknown error'}"));
      }
    } catch (e) {
      emit(DoctorsErrorStates("Unexpected error: ${e.toString()}"));
    }
  }

  // Add this reset method
  void reset() {
    doctorsList = []; // Clear the doctors list
    emit(DoctorsInitialStates()); // Reset to initial state
  }
}
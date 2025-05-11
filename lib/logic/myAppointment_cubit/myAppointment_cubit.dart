import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_links.dart';
import '../../data/myAppointments_module.dart';
import 'myAppointment_states.dart';

class MyAppointmentCubit extends Cubit<MyAppointmentStates> {
  MyAppointmentCubit() : super(MyAppointmentInitialStates());

  final Dio _dio = Dio();
  List<AppointmentData> appointmentsList = [];

  Future<void> getMyAppointments() async {
    emit(MyAppointmentLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        emit(MyAppointmentErrorState("User not logged in."));
        return;
      }

      final response = await _dio.get(
        ApiLinks.getMyAppointmentsUrl, // تأكد إن الرابط ده موجود في ملف api_links
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
        appointmentsList = data.map((e) => AppointmentData.fromJson(e)).toList();
        emit(MyAppointmentSucessState());
      } else {
        emit(MyAppointmentErrorState("Failed to load appointments: ${response.data['message'] ?? 'Unknown error'}"));
      }
    } catch (e) {
      emit(MyAppointmentErrorState("Unexpected error: ${e.toString()}"));
    }
  }

  void reset() {
    appointmentsList = [];
    emit(MyAppointmentInitialStates());
  }
}

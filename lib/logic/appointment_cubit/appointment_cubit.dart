import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api_links.dart';
import 'appointment_states.dart';

class BookingCubit extends Cubit<BookAppointmentStates> {
  BookingCubit() : super(BookAppointmentInitialStates());

  final Dio _dio = Dio();

  Future<void> bookAppointment({
    required int doctorId,
    required String appointmentTime,
    required String appointmentEndTime,
    required double appointmentPrice,
    String? notes,
  }) async {
    emit(BookAppointmentLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      if (token == null) {
        emit(BookAppointmentErrorState("User not logged in"));
        return;
      }

      debugPrint('Sending booking request with: ${{
        'doctor_id': doctorId,
        'appointment_time': appointmentTime,
        'appointment_end_time': appointmentEndTime,
        'appointment_price': appointmentPrice,
        'notes': notes ?? '',
      }}');

      final response = await _dio.post(
        ApiLinks.bookAppointmentUrl,
        data: {
          'doctor_id': doctorId,
          'appointment_time': appointmentTime,
          'appointment_end_time': appointmentEndTime,
          'appointment_price': appointmentPrice,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Full response data: ${response.data}');

      if (response.statusCode == 201) {
        final rawData = response.data['data'];

        // Ensure correct Map type
        final Map<String, dynamic> responseData =
        Map<String, dynamic>.from(rawData);

        emit(BookAppointmentSucessState(
          bookingId: responseData['id'],
          doctorData: Map<String, dynamic>.from(responseData['doctor']),
          patientData: Map<String, dynamic>.from(responseData['patient']),
          appointmentTime: responseData['appointment_time'],
          appointmentEndTime: responseData['appointment_end_time'],
          status: responseData['status'],
          notes: responseData['notes'],
          appointmentPrice:
          double.tryParse(responseData['appointment_price'].toString()) ??
              0.0,
        ));
      } else if (response.statusCode == 422) {
        final errors = response.data['errors'] ?? {};
        final errorMessage = errors.entries
            .map((e) => '${e.key}: ${e.value.join(', ')}')
            .join('\n');
        debugPrint('Error response: ${response.data}');  // Added debugPrint for error response
        emit(BookAppointmentErrorState(errorMessage));
      } else {
        final errorMessage = response.data['message'] ?? 'Booking failed';
        debugPrint('Error response: ${response.data}');  // Added debugPrint for error response
        emit(BookAppointmentErrorState(errorMessage));
      }
    } on DioException catch (e) {
      debugPrint('Error response: ${e.response?.data}');  // Added debugPrint for error response in DioException
      final errorMessage = e.response?.data['message'] ??
          e.response?.data['errors']?.toString() ??
          'Network error: ${e.message}';
      emit(BookAppointmentErrorState(errorMessage));
    } catch (e) {
      debugPrint('Unexpected error: ${e.toString()}');  // Added debugPrint for unexpected errors
      emit(BookAppointmentErrorState('Unexpected error: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(BookAppointmentInitialStates());
  }
}

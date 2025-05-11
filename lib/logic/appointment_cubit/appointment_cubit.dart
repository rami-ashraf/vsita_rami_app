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

      // Create request data with both possible field name variations
      final requestData = {
        'doctor_id': doctorId,
        // Primary field names (from error message)
        'start_time': appointmentTime,
        'end_time': appointmentEndTime,
        'price': appointmentPrice,
        // Alternative field names (from API response)
        'appointment_time': appointmentTime,
        'appointment_end_time': appointmentEndTime,
        'appointment_price': appointmentPrice,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      debugPrint('Sending booking request with: $requestData');

      final response = await _dio.post(
        ApiLinks.bookAppointmentUrl,
        data: requestData,
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
        _handleSuccessResponse(response);
      } else {
        _handleErrorResponse(response);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      emit(BookAppointmentErrorState('Unexpected error: ${e.toString()}'));
    }
  }

  void _handleSuccessResponse(Response response) {
    try {
      final rawData = response.data['data'];
      final Map<String, dynamic> responseData = Map<String, dynamic>.from(rawData);

      emit(BookAppointmentSucessState(
        bookingId: responseData['id'],
        doctorData: Map<String, dynamic>.from(responseData['doctor']),
        patientData: Map<String, dynamic>.from(responseData['patient']),
        appointmentTime: responseData['appointment_time'] ?? responseData['start_time'],
        appointmentEndTime: responseData['appointment_end_time'] ?? responseData['end_time'],
        status: responseData['status'],
        notes: responseData['notes'],
        appointmentPrice: _parsePrice(responseData),
      ));
    } catch (e) {
      emit(BookAppointmentErrorState('Failed to parse response: ${e.toString()}'));
    }
  }

  double _parsePrice(Map<String, dynamic> responseData) {
    try {
      return double.tryParse(
          (responseData['appointment_price'] ?? responseData['price']).toString()
      ) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  void _handleErrorResponse(Response response) {
    if (response.statusCode == 422) {
      final errors = response.data['errors'] ?? {};
      final errorMessage = errors.entries
          .map((e) => '${e.key}: ${e.value.join(", ")}')
          .join('\n')
          .trim();

      emit(BookAppointmentErrorState(
          errorMessage.isNotEmpty
              ? errorMessage
              : 'Validation error: ${response.data['message'] ?? 'Unknown'}'
      ));
    } else {
      emit(BookAppointmentErrorState(
          response.data['message'] ?? 'Booking failed with status ${response.statusCode}'
      ));
    }
  }

  void _handleDioError(DioException e) {
    final responseData = e.response?.data;
    final errorMessage = responseData?['message'] ??
        responseData?['errors']?.toString() ??
        'Network error: ${e.message}';

    emit(BookAppointmentErrorState(errorMessage));
  }

  void resetState() {
    emit(BookAppointmentInitialStates());
  }
}

class BookAppointmentStates {}

class BookAppointmentInitialStates extends BookAppointmentStates {}

class BookAppointmentLoadingState extends BookAppointmentStates {}

class BookAppointmentSucessState extends BookAppointmentStates {
  final int bookingId;
  final Map<String, dynamic> doctorData;
  final Map<String, dynamic> patientData;
  final String appointmentTime;
  final String appointmentEndTime;
  final String status;
  final String? notes;
  final num appointmentPrice;

  BookAppointmentSucessState({
    required this.bookingId,
    required this.doctorData,
    required this.patientData,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.status,
    this.notes,
    required this.appointmentPrice,
  });
}

class BookAppointmentErrorState extends BookAppointmentStates {
  final String error;
  BookAppointmentErrorState(this.error);
}
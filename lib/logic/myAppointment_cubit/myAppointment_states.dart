class MyAppointmentStates {}

class MyAppointmentInitialStates extends MyAppointmentStates {}

class MyAppointmentLoadingState extends MyAppointmentStates {}

class MyAppointmentSucessState extends MyAppointmentStates {}

class MyAppointmentErrorState extends MyAppointmentStates {

  final String error;
  MyAppointmentErrorState(this.error);

}



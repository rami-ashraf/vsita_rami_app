



import '../../data/doctorData.dart';

abstract class DoctorsStates {}

class DoctorsInitialStates extends DoctorsStates {}

class DoctorsLoadingStates extends DoctorsStates {}

class DoctorsSuccessStates extends DoctorsStates {
  final List<DoctorsData> doctors;
  DoctorsSuccessStates(this.doctors);
}

class DoctorsErrorStates extends DoctorsStates {
  final String message;
  DoctorsErrorStates(this.message);
}

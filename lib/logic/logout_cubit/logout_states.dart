
abstract class logoutStates {}

class logoutInitialStates extends logoutStates {}

class logoutLoadingState extends logoutStates {}

class logoutSuccessState extends logoutStates {
  final bool resetApp;
  logoutSuccessState({required this.resetApp});
}

class logoutErrorState extends logoutStates {
  final String error;
  logoutErrorState(this.error);
}
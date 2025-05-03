class LoginStates {}

class LoginInitialStates extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSucessState extends LoginStates {}

class LoginErrorState extends LoginStates {

  final String error;
  LoginErrorState(this.error);

}



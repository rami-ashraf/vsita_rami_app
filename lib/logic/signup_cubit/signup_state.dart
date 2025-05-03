class SignUpStates {}

class SignUpInitialStates extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

class SignUpSucessState extends SignUpStates {}

class SignUpErrorState extends SignUpStates {

  final String error;
  SignUpErrorState(this.error);

}



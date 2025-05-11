class UserUpdateStates {}

class UserUpdateInitialStates extends UserUpdateStates {}

class UserUpdateLoadingState extends UserUpdateStates {}

class UserUpdateSucessState extends UserUpdateStates {}

class UserUpdateErrorState extends UserUpdateStates {

  final String error;
  UserUpdateErrorState(this.error);

}



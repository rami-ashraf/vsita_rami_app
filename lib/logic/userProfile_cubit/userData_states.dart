class UserProfileStates {}

class UserProfileInitialStates extends UserProfileStates {}

class UserProfileLoadingState extends UserProfileStates {}

class UserProfileSucessState extends UserProfileStates {}

class UserProfileErrorState extends UserProfileStates {

  final String error;
  UserProfileErrorState(this.error);

}



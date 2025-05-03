class HomeStates {}

class HomeInitialStates extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSucessState extends HomeStates {}

class HomeErrorState extends HomeStates {

  final String error;
  HomeErrorState(this.error);

}



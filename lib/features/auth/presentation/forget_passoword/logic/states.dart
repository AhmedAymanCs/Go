abstract class ForgetPasswordStates {}

class ForgetPasswordInitialState extends ForgetPasswordStates {}

class ForgetPasswordLoadingState extends ForgetPasswordStates {}

class ForgetPasswordSuccessState extends ForgetPasswordStates {}

class ForgetPasswordErrorState extends ForgetPasswordStates {
  final String errorMessage;

  ForgetPasswordErrorState(this.errorMessage);
}

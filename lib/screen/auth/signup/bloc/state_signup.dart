abstract class SignUpStates{}

class InitialState extends SignUpStates{}

class LoadingSignUp extends SignUpStates{}

class SuccessSignUp extends SignUpStates{}

class ErrorSignUp extends SignUpStates{
  final String error;
  ErrorSignUp(this.error);
}

class LoadingCreateUser extends SignUpStates{}

class SuccessCreateUser extends SignUpStates{}

class ErrorCreateUser extends SignUpStates{
  final String error;
  ErrorCreateUser(this.error);
}

class VisiblePassword extends SignUpStates{}
class VisibleConfirmPassword extends SignUpStates{}

class TakeImageSignUp extends SignUpStates{}




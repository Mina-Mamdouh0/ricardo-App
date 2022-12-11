abstract class LoginStates{}

class InitialState extends LoginStates{}

class LoadingLoginScreen extends LoginStates{}

class SuccessLoginScreen extends LoginStates{}


class ErrorLoginScreen extends LoginStates{
  final String error;
  ErrorLoginScreen(this.error);
}

class VisiblePasswordLogin extends LoginStates{}




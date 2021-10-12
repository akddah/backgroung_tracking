class LoginState {}

class DoneLoginState extends LoginState {
  // set user Model here
  String msg;
  DoneLoginState({this.msg});
}

class FaildLoginState extends LoginState {
  int errType;
  String msg;
  bool isActive;
  FaildLoginState({this.errType, this.msg, this.isActive});
}

class LoadingLoginState extends LoginState {}

import 'dart:io';

class LoginEvent {}

class ClickLoginEvent extends LoginEvent {
  String phone;
  String password;
  buildBody() async {
    return {
      "identifier": phone,
      "password": password,
      "device_type": Platform.isIOS ? "ios" : "android",
      "device_token": "0",
    };
  }

  ClickLoginEvent({this.phone, this.password});
}

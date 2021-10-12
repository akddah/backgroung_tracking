import 'dart:async';

import 'package:face_id_finger_print/Login/LoginBloc/LoginEvent.dart';
import 'package:face_id_finger_print/Login/LoginBloc/LoginState.dart';
import 'package:face_id_finger_print/helper/ServerGate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:face_id_finger_print/Login/LoginBloc/LoginEvent.dart';
// import 'package:face_id_finger_print/Login/LoginBloc/LoginState.dart';
// import 'package:face_id_finger_print/helper/ServerGate.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is ClickLoginEvent) {
      // show loader ........ ?
      yield LoadingLoginState();

      CustomResponse response = await repo(await event.buildBody());

      if (response.success) {
        print("response => ${response.response.data.toString()}");
        // AuthModel _model = AuthModel.fromJson(response.response.data);
        // UserHelper.setUserD/ata(_model.data);
        yield DoneLoginState(msg: response.msg);
      } else {
        print("from map event to state show error => ");
        print(response.error.toString());
        print(response.response.toString());
        if (response.errType == 0) {
          yield FaildLoginState(
            msg: response.msg,
            errType: response.errType,
          );
        } else if (response.errType == 1) {
          print("from xxxxx => ${response.error}");
          print("${response.response.data["is_active"]}");
          yield FaildLoginState(
            msg: response.error,
            errType: response.errType,
            isActive: response.response.data["is_active"],
          );
        } else {
          yield FaildLoginState(
            msg: "Server error , please try again",
            errType: response.errType,
          );
        }
      }
    }
  }

  Future<CustomResponse> repo(Map body) async {
    serverGate.addInterceptors();
    CustomResponse response = await serverGate.sendToServer(
      url: "auth/login",
      body: body,
    );
    return response;
  }
}

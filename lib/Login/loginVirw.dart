import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'LoginBloc/LoginBloc.dart';
import 'LoginBloc/LoginEvent.dart';
import 'LoginBloc/LoginState.dart';
import 'package:face_id_finger_print/helper/FlashHeloer.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var phoneNumberControll = TextEditingController(),
      passwordControll = TextEditingController();
  LoginBloc _bloc = KiwiContainer().resolve<LoginBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
      ),
      body: BlocListener(
        bloc: _bloc,
        listener: (context, state) {
          if (state is FaildLoginState) {
            FlashHelper.errorBar(message: state.msg);
            // if (state.isActive == false) {
            //   // push(ConfirmCodeView(
            //   //   isRegister: 1,
            //   //   phone: phoneControl.text,
            //   // ));
            // }
          } else if (state is DoneLoginState) {
            FlashHelper.successBar(message: state.msg);
            // pushAndRemoveUntil(NavBarView());
          } else {}
        },
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(32),
            shrinkWrap: true,
            children: [
              Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Logo%21_Logo.svg/1024px-Logo%21_Logo.svg.png",
                height: 100,
                width: 100,
              ),
              SizedBox(height: 64),
              TextFormField(
                controller: phoneNumberControll,
                decoration: InputDecoration(
                  hintText: "010XXXXXXXXX",
                  labelText: "Phone Number",
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordControll,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "•••••••••••",
                  labelText: "Password",
                ),
              ),
              SizedBox(height: 64),
              GestureDetector(
                onTap: _onLogin,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow()],
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onLogin() {
    _bloc.add(ClickLoginEvent(
      password: passwordControll.text,
      phone: phoneNumberControll.text,
    ));
  }
}

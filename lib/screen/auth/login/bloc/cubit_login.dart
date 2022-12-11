import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ricardo_app/screen/auth/login/bloc/state_login.dart';


class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(InitialState());

  static LoginCubit get(context)=>BlocProvider.of(context);
  bool obscureText=true;

void userLogin({
  required String email,
  required String password,
  required BuildContext context,
}){
  emit(LoadingLoginScreen());
  FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password).
  then((value){
    emit(SuccessLoginScreen());
  }).
  onError((error,_){
    emit(ErrorLoginScreen(error.toString()));
  });
}

  void visiblePassword(){
    obscureText=!obscureText;
    emit(VisiblePasswordLogin());
  }
}
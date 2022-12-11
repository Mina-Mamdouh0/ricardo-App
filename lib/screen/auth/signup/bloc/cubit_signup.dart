
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ricardo_app/model/user_model.dart';
import 'package:ricardo_app/screen/auth/signup/bloc/state_signup.dart';
import 'package:uuid/uuid.dart';

class SignUpCubit extends Cubit<SignUpStates>{
  SignUpCubit() : super(InitialState());

  static SignUpCubit get(context)=>BlocProvider.of(context);

  bool obscurePassword=true;
  bool obscureConfirmPassword=true;
  XFile? file;

  String? profileUrl;
  FirebaseAuth auth =FirebaseAuth.instance;
void userSignUp({
  required String email,
  required String password,
  required String name,
  required String phone,
  required BuildContext context,
}){
  emit(LoadingSignUp());
  FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password).
  then((value){
        createUser(name: name,
        phone: phone,
        email: email,
        uId: value.user!.uid,
        password: password,
        context: context);
  }).onError((error,_){
    String err;
    if (error.toString()=='[firebase_auth/weak-password] Password should be at least 6 characters') {
      err='The password provided is too weak';
    } else if (error.toString() == '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
      err='The account already exists for that email.';
    }else{
      err='Check Information';
    }
    emit(ErrorSignUp(err));
  });
}

void createUser({
  required String email,
  required String uId,
  required String name,
  required String phone,
  required String password,
  required BuildContext context,
}){

  emit(LoadingCreateUser());
  var id=const Uuid().v4();
  FirebaseStorage.instance.ref().child('profilePhoto/$id}')
      .putFile(File(file!.path))
      .then((value) {
    value.ref.getDownloadURL().then((value) {
      profileUrl = value;
    }).whenComplete((){
      UserModel model=UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        profile: profileUrl!,
        password: password,
      );
      FirebaseFirestore.instance.collection('Users').doc(uId).set(
          model.toMap()
      );
    }).then((value) {
      emit(SuccessSignUp());
    });
  }).onError((error, stackTrace) {
    emit(ErrorCreateUser(error.toString()));
  });
}

  void takeImage(XFile? newFile) {
    file = newFile;
    emit(TakeImageSignUp());
  }


void visiblePassword(){
  obscurePassword=!obscurePassword;
  emit(VisiblePassword());
}

void visibleConfirmPassword(){
  obscureConfirmPassword=!obscureConfirmPassword;
  emit(VisibleConfirmPassword());
}


}
import 'dart:developer';

import 'package:chat/core/app_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/main_page/main_page.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
  static SignUpCubit get(ctx) => BlocProvider.of(ctx);
  final formKey = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  bool isLoading = false;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final coPasswordController = TextEditingController();
  bool isSecure = true;
  bool isSecureConfirmPass = true;
  visablePass(value) {
    if (value == "password") {
      isSecure = !isSecure;
    } else {
      isSecureConfirmPass = !isSecureConfirmPass;
    }
    emit(VisablePasswordState());
  }

  signUpMethod(context) {
    try {
      isLoading = true;
      emit(StartSignUpProcessState());
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        addUserData(value, context);
        SharedPreferences.getInstance().then((value) {
          value.setString(AppKeys.authKey, "yes");
        });

        //todo sharredPrefrance to save auth
      }).onError<FirebaseAuthException>((error, stackTrace) {
        isLoading = false;
        emit(FaildSignUpProcessState());
        Fluttertoast.showToast(msg: error.message.toString());
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      emit(FaildSignUpProcessState());
      Fluttertoast.showToast(msg: e.message.toString());
      log(e.toString());
    }
  }

  String image =
     'https://firebasestorage.googleapis.com/v0/b/chat-friends-42245.appspot.com/o/avatar5.png?alt=media&token=e4d93e1b-f107-4f5f-b3b5-d8311212d558';
  addUserData(value, context) {
    try {
      FirebaseFirestore.instance.collection(AppKeys.firebaseUserKey).add({
        "authId": value.user!.uid,
        "name": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "connections": [],
        "img": image,
        "isPrivate": true,
        "password": passwordController.text.trim(),
      }).then((cloudValue) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(cloudValue.id)
            .update({"userId": cloudValue.id}).then((value) {
          SharedPreferences.getInstance().then((value) {
            value.setString(AppKeys.userId, cloudValue.id);
            value.setString(AppKeys.personalImageKey, image);
            value.setString(AppKeys.nameKey, usernameController.text.trim());
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPageScreen(
                        id: cloudValue.id,
isFromReg:true,
                      
                      )),
              (route) => false);
          isLoading = false;
          emit(SucessSignUpProcessState());
          Fluttertoast.showToast(msg: 'Success');
        }).onError<FirebaseAuthException>((error, stackTrace) {
          isLoading = false;
          emit(FaildSignUpProcessState());
          Fluttertoast.showToast(msg: error.message.toString());
        });
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      emit(FaildSignUpProcessState());
      Fluttertoast.showToast(msg: e.message.toString());
      log(e.toString());
    }
  }
}

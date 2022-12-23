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
      "https://firebasestorage.googleapis.com/v0/b/chat-44439.appspot.com/o/avatar2.png?alt=media&token=21d24ad9-573b-46d1-ad14-4e2b8836ba5b";
  addUserData(value, context) {
    try {
      FirebaseFirestore.instance.collection(AppKeys.firebaseUserKey).add({
        "authId": value.user!.uid,
        "name": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "connections": [],
        "img": image,
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

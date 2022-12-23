import 'dart:developer';

import 'package:chat/core/app_keys.dart';
import 'package:chat/presentation/main_page/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  static SignInCubit get(ctx) => BlocProvider.of(ctx);
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSecure = true;
  visablePass() {
    isSecure = !isSecure;
    emit(VisablePasswordState());
  }

  signInMethod(context) {
    try {
      isLoading = true;
      emit(StartSignInProcessState());
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        SharedPreferences.getInstance().then((value) {
          value.setString(AppKeys.authKey, "yes");
        });
        FirebaseFirestore.instance
            .collection(AppKeys.firebaseUserKey)
            .where("authId", isEqualTo: value.user!.uid)
            .get()
            .then((value) {
          for (var element in value.docs) {
            SharedPreferences.getInstance().then((value) {
              value.setString(AppKeys.userId, element.id);
              value.setString(AppKeys.authKey, "yes");
              value.setString(AppKeys.personalImageKey, element.get("img"));
              value.setString(AppKeys.nameKey, element.get("name"));
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPageScreen(
                          id: element.id,
                        )),
                (route) => false);
            Fluttertoast.showToast(msg: "Sucess");
          }
        });

        isLoading = false;
        emit(SucessSignInProcessState());
        //todo sharedPrefrence to auth
      }).onError<FirebaseAuthException>((error, stackTrace) {
        isLoading = false;
        emit(FaildSignInProcessState());
        Fluttertoast.showToast(msg: error.message.toString());
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      isLoading = false;
      emit(FaildSignInProcessState());
      log(e.toString());
    }
  }
}

import 'dart:developer';

import 'package:chat/core/app_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(ctx) => BlocProvider.of(ctx);
  final messageController = TextEditingController();
  String docsId = "";
  String userImg = "";
  getUserImage() async {
    SharedPreferences.getInstance().then((value) {
      userImg = value.getString(AppKeys.personalImageKey)!;
      emit(GetUserImageState());
    });
  }

  sendMessage(mineId) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(docsId)
        .collection("friedchat")
        .add({
      "userId": mineId,
      "msg": messageController.value.text.trim(),
      "date": DateTime.now()
    }).then((value) {
      messageController.clear();
      emit(SendMessageState());
    }).onError<FirebaseException>((error, stackTrace) {
      log(error.message!);
    });
  }
}

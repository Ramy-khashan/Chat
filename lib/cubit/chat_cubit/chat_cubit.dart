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
  bool isClickingMsg = false;
  String docsId = "";
  String userImg = "";
  int selectedInex =-1;
  bool isLoadingDocsId = false;
  getUserImage() async {
    SharedPreferences.getInstance().then((value) {
      userImg = value.getString(AppKeys.personalImageKey)!;
      emit(GetUserImageState());
    });
  }

  showMessageTime() {
    isClickingMsg = !isClickingMsg;
    emit(ShowMsgTimeState());
  }

  Future getChatId({required String mineId, required String friendId}) async {
    log("Enter");
    isLoadingDocsId = true;
    emit(StartGetChatIdState());

    await FirebaseFirestore.instance.collection("chats").get().then((value) {
      for (var element in value.docs) {
        List connectons = element.get("users").toList();
        log(connectons.toString());
        if (connectons.contains(mineId) && connectons.contains(friendId)) {
          docsId = element.id;
          log(element.id);
          break;
        }
      }
      isLoadingDocsId = false;
      emit(GetChatIdState());
    }).onError<FirebaseException>((error, stackTrace) {
      isLoadingDocsId = false;

      emit(FaildGetChatIdState());
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

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
  bool isEmoji = false;
  bool isdisable = false;
  bool isClickingMsg = false;
  String docsId = "";
  String userImg = "";
  int selectedInex = -1;
  bool isLoadingDocsId = false;
  getUserImage() async {
    SharedPreferences.getInstance().then((value) {
      userImg = value.getString(AppKeys.personalImageKey)!;
      emit(GetUserImageState());
    });
  }

  systemBackButton() {
    if (isdisable == true) {
      isdisable = false;
      isEmoji = false;
      emit(ChangeSystemNavigatorState());

      return false;
    } else {
      return true;
    }
  }

  setEmoji() {
    isdisable = !isdisable;

    isEmoji = !isEmoji;
    if (!isdisable) {
      messageController;
    }
    emit(ChangeEmojiState());
  }

  ScrollController? chatController;
  bool isBottom = true;
  initScrollController() {
    chatController = ScrollController()
      ..addListener(() {
        if (chatController!.position.atEdge) {
          bool isTop = chatController!.position.pixels == 0;
          if (isTop) {
            isTop = true;
          } else {
            isTop = false;
          }
        }
        if (chatController!.position.pixels >
                chatController!.position.minScrollExtent ||
            chatController!.position.pixels >
                chatController!.position.maxScrollExtent) {
          isBottom = false;
          emit(ChangeScrollControllerUpState());
        } else {
          isBottom = true;
          emit(ChangeScrollControllerBottomState());
        }
      });
  }

  showMessageTime() {
    isClickingMsg = !isClickingMsg;
    emit(ShowMsgTimeState());
  }

  Future getChatId({required String mineId, required String friendId}) async {
   
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
      "react": -1,
      "msg": messageController.value.text.trim(),
      "date": DateTime.now()
    }).then((value) {
      messageController.clear();
      getTextFieldifEmpty("");
      emit(SendMessageState());
    }).onError<FirebaseException>((error, stackTrace) {
      log(error.message!);
    });
  }

  sendLike(mineId) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(docsId)
        .collection("friedchat")
        .add({
      "userId": mineId,
      "react": -1,
      "msg": AppKeys.likeKey,
      "date": DateTime.now()
    });
  }

  bool isTextFieldEmpty = true;
  getTextFieldifEmpty(String val) {
    isTextFieldEmpty = val.trim().isEmpty;
    emit(ChangeIsEmptyState());
  }

  msgReact(
      {required String msgId,
      required int reactValue,
      required String selectedReact}) async {
    if (reactValue == int.parse(selectedReact)) {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(docsId)
          .collection("friedchat")
          .doc(msgId)
          .update({"react": -1});
    } else {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(docsId)
          .collection("friedchat")
          .doc(msgId)
          .update({"react": int.parse(selectedReact)});
    }
  }

  String tag = "123";
  bool show = false;
  showFriendImage(frindId) {
    Future.delayed(const Duration(milliseconds: 500));
    show = !show;
    tag = frindId;
    emit(ShowFriendImageState());
  }
}

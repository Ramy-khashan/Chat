import 'dart:developer';
import 'dart:io';

import 'package:chat/core/app_keys.dart';
import 'package:chat/presentation/edit_profile/edit_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'dart:math' as math;
import '../../presentation/splash_page/splash_page.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(ctx) => BlocProvider.of(ctx);
  String userId = "";
  String name = "";
  String image = "";
  bool? containId;
  final nameController = TextEditingController();
  final friendIdController = TextEditingController();
  Future addFriend(context) async {
    log(friendIdController.text);
    log(userId);
    if (friendIdController.text.trim() == userId) {
      Fluttertoast.showToast(msg: "Enter Friend Id Not Yours");
    } else if (friendIdController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "This field must be fill with friend id");
    } else {
      containId = false;
      await FirebaseFirestore.instance.collection("users").get().then((value) {
        for (var element in value.docs) {
          if (element.id == friendIdController.value.text.trim()) {
            containId = true;
          }
        }
      });
      if (containId!) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .get()
            .then((value) async {
          log("id test0 : " + friendIdController.text.trim());

          List connections = value.get("connections").toList();
          log(connections.toString());
          bool isExsist =
              connections.contains(friendIdController.value.text.trim());
          if (isExsist) {
            Fluttertoast.showToast(msg: "Alerady Your Frind");
          } else {
            log("id test : " + friendIdController.value.text.trim());
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .update({
              "connections":
                  FieldValue.arrayUnion([friendIdController.value.text.trim()])
            }).whenComplete(() {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(friendIdController.value.text.trim())
                  .update({
                "connections": FieldValue.arrayUnion([userId])
              }).whenComplete(() async {
                await FirebaseFirestore.instance.collection("chats").add({
                  "user1": friendIdController.value.text.trim(),
                  "user2": userId,
                  "users": [userId, friendIdController.value.text.trim()],
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection("chats")
                      .doc(value.id)
                      .collection("frinds_chat");
                });
                Navigator.pop(context);
              });

              Fluttertoast.showToast(msg: "Added successfully");
            }).onError((error, stackTrace) {
              Fluttertoast.showToast(msg: "Faild to add your frind");
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: "No One with this id");
      }
    }
  }

  selectImage(index) {

    imageFile = null;
      emit(ResetImageFileState());

    selectedImage = index;
    image = images[index];
  

    emit(ChosseImageState());
  }

  cancelSelected() async {
    await SharedPreferences.getInstance().then((sharedPreferences) {
      image = sharedPreferences.getString(AppKeys.personalImageKey)!;
      selectedImage = -1;
      emit(SuccessGettingUserDataState());
    });
  }

  int selectedImage = -1;
  File? imageFile;
  String? imageName;
  final picker = ImagePicker();
  List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/chat-friends-42245.appspot.com/o/avatar5.png?alt=media&token=e4d93e1b-f107-4f5f-b3b5-d8311212d558',
    'https://firebasestorage.googleapis.com/v0/b/chat-friends-42245.appspot.com/o/avatar1.jpg?alt=media&token=53b5e5b3-2123-475c-b4eb-19bf86c789b5',
    'https://firebasestorage.googleapis.com/v0/b/chat-friends-42245.appspot.com/o/avatar2.png?alt=media&token=ea12138b-9c5e-4579-bf90-c5e598dbbb1c',
    'https://firebasestorage.googleapis.com/v0/b/chat-friends-42245.appspot.com/o/avatar3.png?alt=media&token=709f7df5-0928-42ba-a318-500ac81a10e3',
    'https://firebasestorage.googleapis.com/v0/b/chat-friends-42245.appspot.com/o/avatar4.png?alt=media&token=fdd44910-5d7f-4235-8362-f7d966c364df'
  ];
  bool isGettingDataLoad = false;
  bool? isPrivacy;
  getInitialValues() async {
    isGettingDataLoad = true;
    emit(GettingUserDataState());

    await SharedPreferences.getInstance().then((sharedPreferences) {
      userId = sharedPreferences.getString(AppKeys.userId)!;
      name = sharedPreferences.getString(AppKeys.nameKey)!;
      image = sharedPreferences.getString(AppKeys.personalImageKey)!;
      isGettingDataLoad = false;

      emit(SuccessGettingUserDataState());
    }).onError((error, stackTrace) {
      isGettingDataLoad = false;

      emit(FaildGettingUserDataState());
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((value) {
      isPrivacy = value.get("isPrivate");
      emit(GetIsPrivacyState());
    });
  }

  changePrivacy(value) async {
    log(isPrivacy.toString());
    log(value.toString());
    isPrivacy = value;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"isPrivate": value});
    log(isPrivacy.toString());
    emit(ChangePrivacyState());
  }

  getImage() {
    try {
      picker.pickImage(source: ImageSource.gallery).then((value) {
        int ranNum = math.Random().nextInt(10000000);
        imageName = path.basename(value!.path) + ranNum.toString();
        imageFile = File(value.path);
        emit(GetImageState());
      });
    } catch (e) {
      log(e.toString());
    }
  }

  uplodingImage(context) async {
    log(imageName!);
    var ref = FirebaseStorage.instance.ref("CategoryImage/$imageName");
    log("Enter2");
    await ref.putFile(
      File(imageFile!.path),
    );
    await ref.getDownloadURL().then((value) {
      image = value;
      editUserData(context);
    }).onError<FirebaseException>((error, stackTrace) {
      Fluttertoast.showToast(msg: error.message!);
    });
    //var ref = FirebaseStorage.instance.ref("$imageName");

    // await ref.putFile(
    //   File(imageFile!.path),
    // );
    // await ref.getDownloadURL().then((value) {
    //   image = value;
    //   editUserData(context);
    // }).onError<FirebaseException>((error, stackTrace) {
    //   Fluttertoast.showToast(msg: error.message!);
    // });
    // emit(UploadImageState());
  }

  bool isUpdateData = false;
  editUserData(context) async {
    isUpdateData = true;
    emit(UpdateUserDataState());
    await FirebaseFirestore.instance.collection("users").doc(userId).update(
      {
        "name": nameController.text.trim().isEmpty
            ? name
            : nameController.text.trim(),
        "img": image
      },
    ).whenComplete(() {
      SharedPreferences.getInstance().then((value) {
        value.setString(
          AppKeys.nameKey,
          nameController.text.trim().isEmpty
              ? name
              : nameController.text.trim(),
        );
        value.setString(AppKeys.personalImageKey, image);
      });
      isUpdateData = false;
      emit(SuccessUpdateUserDataState());
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const EditProfileScreen()));
    }).onError((error, stackTrace) {
      isUpdateData = false;
      emit(FaildUpdateUserDataState());
    });
  }

  logout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut().then((value) {
      SharedPreferences.getInstance().then((value) async {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .update({"status": false});
        await value.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false);
      });
    });
  }
}

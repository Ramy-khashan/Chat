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
  final nameController = TextEditingController();

  File? imageFile;
  String? imageName;
  final picker = ImagePicker();
  List<String> images = [];
  bool isGettingDataLoad = false;
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
  }

  getStaticImage() {
    images = [];
    FirebaseFirestore.instance.collection("images").get().then((value) {
      for (var element in value.docs) {
        images.add(element.get("img"));
      }
      emit(GetStaticImageState());
    });
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
        await value.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false);
      });
    });
  }
}

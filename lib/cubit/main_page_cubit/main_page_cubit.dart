import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
import 'main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitial());
  static MainPageCubit get(ctx) => BlocProvider.of(ctx);
  bool isOpenSearch = false;
  final searchController = TextEditingController();
  openSearch() {
    isOpenSearch = !isOpenSearch;
    searchController.clear();
    emit(ShowSearchState());
  }

   List frindes=[];


  String img = "";
  update() {
    emit(UpdateValueState());
  }

  getImage({required String id}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) {
      img = value.get("img");
      frindes=value.get("connections");
      emit(UserImageState());
    });
  }
}

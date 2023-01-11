import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat/core/Widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Widgets/image_avatar.dart';
import '../../../core/constant.dart';
import '../../../cubit/main_page_cubit/main_page_cubit.dart';
import '../../../cubit/main_page_cubit/main_page_state.dart';
import '../../chat/chat_page.dart';

class ChatPartItem extends StatelessWidget {
  final Size size;
  final String id;

  const ChatPartItem({Key? key, required this.size, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainPageCubit, MainPageState>(
      listener: (context, state) {
        if (state is GetFriendDataFaildState) {
          AwesomeDialog(
              autoDismiss: false,
              dismissOnTouchOutside: false,
              context: context,
              body: Text("SomeThing went wrong, Try again Later!",
                  style: TextStyle(
                      fontSize: size.shortestSide * .06,
                      fontWeight: FontWeight.w600,
                      color: mainColor)),
              btnOk: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    MainPageCubit.get(context).getFriendData(id: id);
                  },
                  child: const Text("Try Again!")));
        }
      },
      builder: (context, state) {
        final controller = MainPageCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async {
           await controller.getFriendData(id: id);
          },
          color: mainColor,
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.shortestSide * .06,
              ),
              child: controller.isLoadinUsers
                  ? const LoadingItem()
                  : controller.users!.isEmpty
                      ? Center(
                          child: Text(
                            "Add frinds to chat with them",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: size.shortestSide * .06),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPageScreen(
                                      mineId: id,
                                      friendId: controller.users![index].userId,
                                      friendImg:
                                          controller.users![index].userImg,
                                      friendName:
                                          controller.users![index].userName,
                                      status: controller.users![index].status),
                                ),
                              );
                            },
                            child: Padding(
                                padding: EdgeInsets.only(
                                  top: size.longestSide * .02,
                                ),
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      ImageAvatarItem(
                                        img: controller.users![index].userImg,
                                        size: size,
                                        bgColor: mainColor,
                                        radius: .07,
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              controller.users![index].status
                                                  ? Colors.green
                                                  : Colors.grey.shade500,
                                          radius: size.shortestSide * .02,
                                        ),
                                      )
                                    ],
                                  ),
                                  title: Text(
                                    controller.users![index].userName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.shortestSide * .05),
                                  ),
                                  // subtitle: const Text("Last Message"),
                                  // trailing: const Text("date"),
                                )),
                          ),
                          itemCount: controller.users!.length,
                        )),
        );
      },
    );
  }
}

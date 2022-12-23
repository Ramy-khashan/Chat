
import 'package:chat/cubit/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 import '../../core/constant.dart';
import '../../cubit/chat_cubit/chat_state.dart';
import 'widget/chat_textfield.dart';
import 'widget/head.dart';
import 'widget/message_shape.dart';

class ChatPageScreen extends StatelessWidget {
  const ChatPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final controller = ChatCubit.get(context);
              return Column(
                children: [
                  ChatHeadItem(size: size),
                  Expanded(
                    child: Container(
                      decoration: decoration,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.shortestSide * .03,
                                  vertical: size.shortestSide * .02),
                              itemBuilder: (context, index) => MessageShapeItem(
                                  message: "aadwokdoapkdwapodko $index",
                                  size: size),
                              reverse: true,
                              itemCount: 20,
                            ),
                          ),
                          ChatTextFieldItem(
                              onSendMessage: () {},
                              size: size,
                              messageController: controller.messageController)
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

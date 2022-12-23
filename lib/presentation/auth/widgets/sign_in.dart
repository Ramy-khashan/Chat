import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Widgets/button.dart';
import '../../../core/Widgets/loading.dart';
import '../../../core/Widgets/text_field.dart';
import '../../../cubit/signin_cubit/sign_in_cubit.dart';
import '../../../cubit/signin_cubit/sign_in_state.dart';

class SignInScreen extends StatelessWidget {
  final Size size;

  const SignInScreen({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          final controller = SignInCubit.get(context);
          return Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: size.longestSide * .03,
                right: size.shortestSide * .03,
                left: size.shortestSide * .03,
              ),
              child: Column(
                children: [
                  TextFieldItem(
                    onSeePassword: () {},
                    controller: controller.emailController,
                    icon: Icons.email,
                    isPassword: false,
                    isSecure: false,
                    hint: "Enter your email",
                    onValid: (val) {
                      if (val.isEmpty) {
                        return "This field must fill";
                      }
                    },
                    size: size,
                    head: "Email",
                  ),
                  TextFieldItem(
                    onSeePassword: () {
                      controller.visablePass();
                    },
                    controller: controller.passwordController,
                    icon: Icons.password_rounded,
                    isPassword: true,
                    isSecure: controller.isSecure,
                    hint: "Enter your password",
                    onValid: (val) {
                      if (val.isEmpty) {
                        return "This field must fill";
                      }
                    },
                    size: size,
                    head: "Password",
                  ),
                  controller.isLoading
                      ? const LoadingItem()
                      : ButtonITem(
                          size: size,
                          onTap: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.signInMethod(context);
                            }
                          },
                          head: "Sign In")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

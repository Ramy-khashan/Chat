import 'package:regexpattern/regexpattern.dart';
import 'package:chat/core/Widgets/button.dart';
import 'package:chat/core/Widgets/loading.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Widgets/text_field.dart';
import '../../../cubit/signup_cubit/sign_up_cubit.dart';
import '../../../cubit/signup_cubit/sign_up_state.dart';

class SignUpScreen extends StatelessWidget {
  final Size size;
  const SignUpScreen({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          final controller = SignUpCubit.get(context);
          return Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: size.longestSide * .03,
                right: size.shortestSide * .03,
                left: size.shortestSide * .03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFieldItem(
                    onSeePassword: () {},
                    controller: controller.usernameController,
                    icon: Icons.person,
                    isPassword: false,
                    isSecure: false,
                    hint: "Enter your username",
                    onValid: (val) {
 
                      if (val.isEmpty) {
                        return "This field must fill";
                      }
                       else if (controller.usernameController.text.length >
                          20) {
                        return "user name must less than 20 charchter";
                      }
                    },
                    size: size,
                    head: "Username",
                  ),
                  TextFieldItem(
                    onSeePassword: () {},
                    controller: controller.emailController,
                    icon: Icons.email,
                    isPassword: false,
                    isSecure: false,
                    hint: "Enter your email",
                    onValid: (val) {
                      
                      if (val.isEmail()) {
                        return "Enter Email In Correct Form";
                      }
                      if (val.isEmpty) {
                        return "This field must fill";
                      }
                    },
                    size: size,
                    head: "Email",
                  ),
                  TextFieldItem(
                    onSeePassword: () {
                      controller.visablePass("password");
                    },
                    controller: controller.passwordController,
                    icon: Icons.password_rounded,
                    isPassword: true,
                    isSecure: controller.isSecure,
                    hint: "Enter your password",
                    onValid: (val) {
                      
                      if (val.isPasswordNormal2()) {
                        return "Enter Password In Correct Form";
                      }
                      if (val.isEmpty) {
                        return "This field must fill";
                      }
                    },
                    size: size,
                    head: "Password",
                  ),
                  TextFieldItem(
                    onSeePassword: () {
                      controller.visablePass("confirm_password");
                    },
                    controller: controller.coPasswordController,
                    icon: Icons.password_rounded,
                    isPassword: true,
                    isSecure: controller.isSecureConfirmPass,
                    hint: "Re-Enter password",
                    onValid: (val) {
                      
                     if (val.isPasswordNormal2()) {
                        return "Enter Password In Correct Form";
                      }
                      if (val.isEmpty) {
                        return "This field must fill";
                      } else if (controller.passwordController.text !=
                          controller.coPasswordController.text) {
                        return "Confirm password not match with password";
                      }
                    },
                    size: size,
                    head: "Confirm Password",
                  ),
                     SizedBox(height:  size.longestSide * .02,) ,
                  controller.isLoading
                      ? const LoadingItem()
                      : ButtonITem(
                          size: size,
                          onTap: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.signUpMethod(context);
                            }
                          },
                          head: "Sign Up")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

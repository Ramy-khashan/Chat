import 'package:flutter/material.dart';

import '../../core/constant.dart';
import 'widgets/sign_in.dart';
import 'widgets/sign_up.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.longestSide * .2,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: size.shortestSide * .04),
              child: Text(
                "Let's Chat\n with friends",
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: size.shortestSide * .1,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Container(
                    decoration: decoration,
                    padding: EdgeInsets.only(
                      top: size.longestSide * .03,
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          tabs: const [
                            Text("Sign In"),
                            Text("Sign Up"),
                          ],
                          onTap: (value) {},
                          indicatorColor: Colors.transparent,
                          labelColor: mainColor,
                          labelStyle: TextStyle(
                              fontSize: size.shortestSide * .06,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          unselectedLabelColor: Colors.grey,
                          unselectedLabelStyle: TextStyle(
                              fontSize: size.shortestSide * .06,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                            child: TabBarView(children: [
                          SignInScreen(size: size),
                          SignUpScreen(size: size),
                        ]))
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:templog/src/features/authentication/sign_in/pages/sign_in_page.dart';
import 'package:templog/src/features/authentication/sign_up/pages/sign_up_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});
  final ThemeData theme = CommonTheme.themeData;

  Widget getRedirectButtonLook(BuildContext context, String buttonText, bool fillOption) {
    Color color = fillOption ? CommonTheme.deepPurpleColor : const Color(0x00ffffff); // If true, button will be filled with background color

    return Container(
      decoration: const BoxDecoration(
        gradient: CommonTheme.buttonGradient,
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.55,
      height: MediaQuery.of(context).size.height * 0.085,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: color
        ),
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.only(top: 5, bottom: 8, left: 8, right: 8),
        alignment: Alignment.center,
        child: Text(buttonText, style: CommonTheme.getMediumTextStyle(context))
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonTheme.themeData.scaffoldBackgroundColor,
      body: Align(alignment: Alignment.center, child: Column (mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Image(image: const AssetImage("lib/src/images/logo_full.png"), width: MediaQuery.of(context).size.width * 0.6,),
        const Padding(padding: EdgeInsets.all(15)),
        Text("Welcome Back", style: CommonTheme.getLargeTextStyle(context)),
        const Padding(padding: EdgeInsets.all(25)),
        GestureDetector(
          onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage())); },
          child: getRedirectButtonLook(context, "Sign In", true),
        ),
        const Padding(padding: EdgeInsets.all(15)),
        GestureDetector(
          onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage())); },
          child: getRedirectButtonLook(context, "Sign Up", false)
        )
      ]))
    );
  }
}

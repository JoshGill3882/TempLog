import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/profile/services/profile_service.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/validators.dart';

class ConfirmCurrentPasswordDialogue extends StatefulWidget {
  const ConfirmCurrentPasswordDialogue({ super.key });

  @override
  State<StatefulWidget> createState() => _ConfirmCurrentPasswordDialogueState();

}

class _ConfirmCurrentPasswordDialogueState extends State<ConfirmCurrentPasswordDialogue> {
  final _formKey = GlobalKey<FormState>();
  final ThemeData theme = CommonTheme.themeData;
  final ProfileService profileService = ProfileService();

  String enteredPassword = "";
  bool hidePassword = true;
  Widget passwordError = Container();

  handleButtonPress() async {
    passwordError = Container();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String currentEmail = DefaultFirebaseOptions.auth.currentUser!.email!;

      try {
        DefaultFirebaseOptions.auth.signInWithEmailAndPassword(email: currentEmail, password: enteredPassword);
        Navigator.pop(context, true);
      } on FirebaseAuthException {
        setState(() => passwordError = Text("Entered Password Incorrect", style: CommonTheme.getErrorTextStyle(context)));
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CommonTheme.deepPurpleColor,
      title: Text("Confirm Password", style: CommonTheme.getMediumTextStyle(context)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            const Padding(padding: EdgeInsets.all(3)),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.8,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.08 - 20,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,  children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      cursorColor: CommonTheme.whiteColor,
                      decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                      style: CommonTheme.getSmallTextStyle(context),
                      obscureText: hidePassword,
                      onSaved: (newValue) => enteredPassword = newValue!,
                      validator: (value) {
                        if (!Validators.isPassword(value) || Validators.isBlank(value) || Validators.isNull(value)) {
                          setState(() { passwordError = Text("Password invalid", style: CommonTheme.getSmallTextStyle(context)); });
                          return "Password Error";
                        }
                        return null;
                      },
                    )
                  ),
                  GestureDetector(
                    onTap:() => setState(() => hidePassword = !hidePassword),
                    child: (hidePassword)
                      ? Image(image: const AssetImage("lib/src/images/icons/authentication/closed-eye.png"), width: MediaQuery.of(context).size.width * 0.08)
                      : Image(image: const AssetImage("lib/src/images/icons/authentication/open-eye.png"), width: MediaQuery.of(context).size.width * 0.08)
                  ),
                ])
              )
            ),
            Align(alignment: Alignment.center, child: passwordError)
          ])
        ),
      ),
      actions: <Widget>[
        // Confirm Password button
        TextButton(
          onPressed: handleButtonPress,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
            height: MediaQuery.of(context).size.height * 0.07,
            child: Text("Confirm", style: CommonTheme.getMediumTextStyle(context))
          )
        ),

        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
            MainPage.hideLoader(context);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.07,
            child: Text("Cancel", style: CommonTheme.getMediumTextStyle(context))
          )
        )
      ],
    );
  }
}

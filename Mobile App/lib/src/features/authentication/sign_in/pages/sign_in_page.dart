import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/sign_up/pages/sign_up_page.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/validators.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>(); 
  final theme = CommonTheme.themeData;

  String? email;
  String? password;
  Widget signInError = Container();

  bool hidePassword = true;

  handleButtonPress(context) async {
    signInError = Container();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await DefaultFirebaseOptions.auth.signInWithEmailAndPassword(email: email!, password: password!);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
        return;
      } on FirebaseAuthException {
        setState(() { signInError = Text("Invalid Credentials", style: CommonTheme.getErrorTextStyle(context)); });
      }
    }
    setState(() { signInError = Text("Invalid Credentials", style: CommonTheme.getErrorTextStyle(context)); });
  }

  @override
  Widget build(BuildContext context) { return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    body: SafeArea(child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(child: ConstrainedBox(constraints: BoxConstraints(minHeight: constraints.maxHeight), child: IntrinsicHeight(child: Column(children: [
        FractionallySizedBox(widthFactor: 0.9, child: Align(alignment: Alignment.topLeft, child: Text("Sign In!", style: CommonTheme.getLargeTextStyle(context)))),
        const Padding(padding: EdgeInsets.all(10)),

        Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)), color: CommonTheme.purpleColor),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                const Padding(padding: EdgeInsets.all(10)),
                // Email entry
                Text("Email", style: CommonTheme.getMediumTextStyle(context)),
                const Padding(padding: EdgeInsets.all(5)),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CommonTheme.whiteColor),
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CommonTheme.purpleColor),
                      height: constraints.maxHeight - 7,
                      width: constraints.maxWidth - 7,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                        const Padding(padding: EdgeInsets.only(left: 15)),
                        Expanded(
                          child: TextFormField(
                            cursorColor: CommonTheme.whiteColor,
                            decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                            style: CommonTheme.getSmallTextStyle(context),
                            onSaved: (newValue) => email = newValue,
                            validator: (value) {
                              if (!Validators.isEmail(value) || Validators.isBlank(value) || Validators.isNull(value)) {
                                return "Email Error";
                              }
                              return null;
                            },
                          )
                        ),
                        Image(image: const AssetImage("lib/src/images/icons/authentication/email.png"), width: MediaQuery.of(context).size.width * 0.08, height: MediaQuery.of(context).size.width * 0.08),
                        const Padding(padding: EdgeInsets.only(left: 15))
                      ])
                    );
                  })
                ),
                const Padding(padding: EdgeInsets.all(15)),

                // Password entry
                Text("Password", style: CommonTheme.getMediumTextStyle(context)),
                const Padding(padding: EdgeInsets.all(5)),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CommonTheme.whiteColor),
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CommonTheme.purpleColor),
                      height: constraints.maxHeight - 7,
                      width: constraints.maxWidth - 7,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                        const Padding(padding: EdgeInsets.only(left: 15)),
                        Expanded(
                          child: TextFormField(
                            cursorColor: CommonTheme.whiteColor,
                            decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                            style: CommonTheme.getSmallTextStyle(context),
                            obscureText: hidePassword,
                            onSaved: (newValue) => password = newValue,
                            validator: (value) {
                              if (!Validators.isPassword(value) || Validators.isBlank(value) || Validators.isNull(value)) {
                                return "Password Error";
                              }
                              return null;
                            },
                          )
                        ),
                        GestureDetector(
                          onTap:() => setState(() => hidePassword = !hidePassword),
                          child: (hidePassword)
                            ? Image(image: const AssetImage("lib/src/images/icons/authentication/closed-eye.png"), width: MediaQuery.of(context).size.width * 0.08, height: MediaQuery.of(context).size.width * 0.08)
                            : Image(image: const AssetImage("lib/src/images/icons/authentication/open-eye.png"), width: MediaQuery.of(context).size.width * 0.08, height: MediaQuery.of(context).size.width * 0.08)
                        ),
                        const Padding(padding: EdgeInsets.only(left: 15))
                      ])
                    );
                  })
                ),
                const Padding(padding: EdgeInsets.all(10)),

                // Sign In Error Display
                Align(alignment: Alignment.center, child: signInError),
                const Padding(padding: EdgeInsets.all(10)),

                // Sign In button
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => handleButtonPress(context),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.lightPurpleColor),
                      height: MediaQuery.of(context).size.width * 0.22,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.purpleColor),
                          height: constraints.maxHeight - 10,
                          width: constraints.maxWidth - 10,
                          child: Text("Sign In", style: CommonTheme.getLargeTextStyle(context))
                        );
                      })
                    )
                  )
                ),
                const Padding(padding: EdgeInsets.all(15)),

                // "Don't have an account?" section
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage())),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Text("Don't have an account?  ", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045, color: CommonTheme.whiteColor)),
                    Text("Sign Up", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold, color: const Color(0xffC790FF)))
                  ])
                ),
                const Padding(padding: EdgeInsets.all(10))
              ])
            )
          )
        ),

        Expanded(child: Container(decoration: const BoxDecoration(color: CommonTheme.purpleColor)))
      ]))));
    })
  )); }
}

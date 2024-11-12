import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/sign_in/pages/sign_in_page.dart';
import 'package:templog/src/features/authentication/sign_up/pages/manager_pick_page.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/string_extensions.dart';
import 'package:templog/src/util/validators.dart';
import 'package:templog/src/util/widgets/password_reqs_checker.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final theme = CommonTheme.themeData;

  String? displayName;
  String? email;
  String? password;
  String? confirmPassword;

  String tempPassword = "";

  bool hidePassword = true;

  // Errors
  Widget displayNameError = Container();
  Widget emailError = Container();
  Widget passwordError = Container();
  Widget confirmPasswordError = Container();

  handleButtonPress(BuildContext context) async {
    // Reset errors
    displayNameError = Container();
    emailError = Container();
    passwordError = Container();

    // Run validators
    if (_formKey.currentState!.validate()) {
      // On success, save current state
      _formKey.currentState!.save();

      displayName = displayName!.split(' ').map((word) => word.capitalize()).join(' ');

      // Attempt to sign in with given details
      try {
        await DefaultFirebaseOptions.auth.signInWithEmailAndPassword(email: email!, password: password!);
        // If it succeeds, sign out
        await DefaultFirebaseOptions.auth.signOut();
        // Set the "emailError" as a message that an account with this email already exists
        setState(() => emailError = Text("An account with this email already exists", style: CommonTheme.getErrorTextStyle(context), textAlign: TextAlign.center));
        // Return
        return;
      } on FirebaseAuthException catch (exception) {
        // Switch case depending on exception code
        switch (exception.code) {
          // if the password was incorrect, set emailError and break
          case "wrong-password":
            setState(() => emailError = Text("An account with this email already exists", style: CommonTheme.getErrorTextStyle(context), textAlign: TextAlign.center ));
            break;
          // If a user is not found, navigate to "ManagerPickPage" and break
          case "user-not-found":
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManagerPickPage(),
                settings: RouteSettings(arguments: {
                  "email": email,
                  "displayName": displayName,
                  "password": password
                })
              )
            );
            break;
        }
        // Return
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(child: ConstrainedBox(constraints: BoxConstraints(minHeight: constraints.maxHeight), child: IntrinsicHeight(child: Column(children: [
          FractionallySizedBox(widthFactor: 0.9, child: Align(alignment: Alignment.topLeft, child: Text("Create Your Account!", style: CommonTheme.getLargeTextStyle(context)))),
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

                  // Display Name entry
                  Text("Full Name", style: CommonTheme.getMediumTextStyle(context)),
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
                              onSaved: (newValue) => displayName = newValue,
                              validator: (value) {
                                if (Validators.isBlank(value) || Validators.isNull(value)) {
                                  setState(() => displayNameError = Text("Please enter a Display Name", style: CommonTheme.getErrorTextStyle(context)));
                                  return "Display Name Error";
                                }
                                return null;
                              },
                            )
                          ),
                          const Padding(padding: EdgeInsets.only(left: 15))
                        ])
                      );
                    })
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                  Align(alignment: Alignment.center, child: displayNameError),
                  const Padding(padding: EdgeInsets.all(5)),

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
                                  setState(() => emailError = Text("Please enter an Email", style: CommonTheme.getErrorTextStyle(context)));
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
                  const Padding(padding: EdgeInsets.all(3)),
                  Align(alignment: Alignment.center, child: emailError),
                  const Padding(padding: EdgeInsets.all(5)),

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
                              onChanged: (tempValue) => setState(() { tempPassword = tempValue; }),
                              onSaved: (newValue) => password = newValue,
                              obscureText: hidePassword,
                              validator: (value) {
                                if (!Validators.isPassword(value) || Validators.isBlank(value) || Validators.isNull(value)) {
                                  setState(() => passwordError = Text("Please enter a valid Password", style: CommonTheme.getErrorTextStyle(context)));
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

                  // Password Requirements Display
                  const Padding(padding: EdgeInsets.all(3)),
                  PasswordReqsChecker(password: tempPassword),
                  const Padding(padding: EdgeInsets.all(3)),

                  const Padding(padding: EdgeInsets.all(3)),
                  Align(alignment: Alignment.center, child: passwordError),
                  const Padding(padding: EdgeInsets.all(5)),

                  // Sign Up button
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () { handleButtonPress(context); },
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
                            child: Text("Sign Up", style: CommonTheme.getLargeTextStyle(context))
                          );
                        })
                      )
                    )
                  ),
                  const Padding(padding: EdgeInsets.all(10)),

                  // "Already have an account?" section
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage())),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      Text("Already have an account?  ", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045, color: CommonTheme.whiteColor)),
                      Text("Sign In", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold, color: Color(0xffC790FF)))
                    ])
                  ),
                  const Padding(padding: EdgeInsets.all(10))
                ])
              )
            )
          ),

          Expanded(child: Container(decoration: const BoxDecoration(color: CommonTheme.purpleColor)))
        ]))));
      }))
    );
  }
}

import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/profile/pages/profile_page.dart';
import 'package:templog/src/features/profile/services/profile_service.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/string_extensions.dart';
import 'package:templog/src/util/validators.dart';
import 'package:templog/src/util/widgets/confirm_current_password_dialogue.dart';
import 'package:templog/src/util/widgets/password_reqs_checker.dart';

class EditProfilePage extends StatefulWidget {
  final Function changePage;
  const EditProfilePage({required this.changePage, super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final theme = CommonTheme.themeData;
  final profileService = ProfileService();

  String displayName = "";
  String email = "";
  String newPassword = "";

  String tempPassword = "";

  bool displayNameError = false;
  Widget emailError = Container();
  String passwordError = "";
  bool updateError = false;

  bool hideNewPassword = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      displayName = DefaultFirebaseOptions.auth.currentUser!.displayName!;
      email = DefaultFirebaseOptions.auth.currentUser!.email!;
    });
  }

  handleButtonPress(BuildContext context) async {
    displayNameError = false;
    emailError = Container();
    passwordError = "";
    updateError = false;
    if (_formKey.currentState!.validate()) {
      MainPage.showLoader(context, false, "");
      _formKey.currentState!.save();

      displayName = displayName.split(' ').map((word) => word.capitalize()).join(' ');

      String updateProfileResponse = await profileService.updateProfile(email, newPassword, displayName);
      if (updateProfileResponse != "success") {
        if (updateProfileResponse == "email-already-in-use") {
          MainPage.hideLoader(context);
          setState(() => emailError = Text("This email is already in use", style: CommonTheme.getErrorTextStyle(context)));
          return;
        } else if (updateProfileResponse == "requires-recent-login") {
          bool? passwordCheckSuccess = await showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (BuildContext context) => const ConfirmCurrentPasswordDialogue()
          );

          if (passwordCheckSuccess!= null && passwordCheckSuccess) {
            MainPage.showLoader(context, false, "");
            await profileService.updateProfile(email, newPassword, displayName);
            MainPage.hideLoader(context);
          }

          return;
        }
      }

      MainPage.hideLoader(context);
      widget.changePage(ProfilePage(changePage: widget.changePage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        GestureDetector(
          onTap: () => widget.changePage(ProfilePage(changePage: widget.changePage)),
          child: Image(image: const AssetImage("lib/src/images/icons/misc/left-arrow.png"), width: MediaQuery.of(context).size.width * 0.1,)
        ),
        Text("Edit Profile", style: CommonTheme.getLargeTextStyle(context)),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1)
      ]),
      const Padding(padding: EdgeInsets.all(15)),

      Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text("   Full Name", style: CommonTheme.getMediumTextStyle(context)),
          const Padding(padding: EdgeInsets.all(3)),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.08,
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxHeight - 10,
                width: constraints.maxWidth - 40,
                child: TextFormField(
                  cursorColor: CommonTheme.whiteColor,
                  decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                  style: CommonTheme.getSmallTextStyle(context),
                  onSaved:(newValue) => displayName = newValue!,
                  validator: (value) {
                    if (Validators.isNull(value) || Validators.isBlank(value)) { setState(() => displayNameError = true); return "Display Name Error"; }
                    return null;
                  },
                  initialValue: displayName,
                )
              );
            })
          ),
          (displayNameError)
            ? Center(child: Text("Enter a valid Name", style: CommonTheme.getErrorTextStyle(context)))
            : const Padding(padding: EdgeInsets.all(0)),
          const Padding(padding: EdgeInsets.all(10)),

          Text("   Email", style: CommonTheme.getMediumTextStyle(context)),
          const Padding(padding: EdgeInsets.all(3)),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.08,
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxHeight - 10,
                width: constraints.maxWidth - 40,
                child: TextFormField(
                  cursorColor: CommonTheme.whiteColor,
                  decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                  style: CommonTheme.getSmallTextStyle(context),
                  onSaved:(newValue) => email = newValue!,
                  validator: (value) {
                    if (Validators.isNull(value) || Validators.isBlank(value) || !Validators.isEmail(value)) { setState(() => emailError = Text("Please enter a valid email", style: theme.textTheme.bodySmall)); return "Email Error"; }
                    return null;
                  },
                  initialValue: email,
                )
              );
            })
          ),
          Align(alignment: Alignment.center, child: emailError),
          const Padding(padding: EdgeInsets.all(10)),

          Text("   Password", style: CommonTheme.getMediumTextStyle(context)),
          const Padding(padding: EdgeInsets.all(3)),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.08,
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxHeight - 30,
                width: constraints.maxWidth - 40,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Expanded(child: TextFormField(
                    cursorColor: CommonTheme.whiteColor,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: CommonTheme.getSmallTextStyle(context),
                    obscureText: hideNewPassword,
                    onChanged: (tempValue) => setState(() { tempPassword = tempValue; }),
                    onSaved: (newValue) => newPassword = newValue!,
                  )),
                  GestureDetector(
                    onTap:() => setState(() => hideNewPassword = !hideNewPassword),
                    child: (hideNewPassword)
                      ? Image(image: const AssetImage("lib/src/images/icons/authentication/closed-eye.png"), width: MediaQuery.of(context).size.width * 0.08)
                      : Image(image: const AssetImage("lib/src/images/icons/authentication/open-eye.png"), width: MediaQuery.of(context).size.width * 0.08)
                  ),
                ])
              );
            })
          ),

          const Padding(padding: EdgeInsets.all(3)),
          PasswordReqsChecker(password: tempPassword),
          const Padding(padding: EdgeInsets.all(3)),

          (passwordError.isNotEmpty)
            ? Center(child: Text(passwordError, style: CommonTheme.getErrorTextStyle(context)))
            : const Padding(padding: EdgeInsets.all(0)),
          const Padding(padding: EdgeInsets.all(15)),

          Center(child: GestureDetector(
            onTap: () => handleButtonPress(context),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Text("Save", style: CommonTheme.getMediumTextStyle(context))
            )
          )),
          (updateError)
            ? Center(child: Text("Update Profile Error", style: CommonTheme.getErrorTextStyle(context)))
            : const Padding(padding: EdgeInsets.all(0))
        ])
      ),
      const Padding(padding: EdgeInsets.all(5))
    ])))));
  }
}

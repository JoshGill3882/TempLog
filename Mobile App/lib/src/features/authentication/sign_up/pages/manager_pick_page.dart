import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/data/update_claims_dto.dart';
import 'package:templog/src/features/authentication/sign_up/services/sign_up_service.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/subscriptions/services/subscriptions_service.dart';
import 'package:templog/src/theme/common_theme.dart';

class ManagerPickPage extends StatefulWidget{
  const ManagerPickPage({super.key});

  @override
  State<ManagerPickPage> createState() => _ManagerPickPageState();
}

class _ManagerPickPageState extends State<ManagerPickPage> {
  final theme = CommonTheme.themeData;
  SignUpService signUpService = SignUpService();
  final subscriptionsService = SubscriptionsService();
  bool adminFlag = false;
  String buttonSelected = "";
  final businessCodeController = TextEditingController();
  bool businessCodeError = false;
  bool employeeBusinessCodeError = false;
  bool signUpError = false;

  toggleAdmin(bool newStatus) { setState(() { adminFlag = newStatus; buttonSelected = adminFlag ? "Manager" : "Employee"; }); }

  getButton(BuildContext context, bool pressed, String text) {
    return pressed
      ? Center(child: Text(text, style: CommonTheme.getMediumTextStyle(context)))
      : Center(
        child: Container(
          decoration: BoxDecoration(
            color: CommonTheme.deepPurpleColor,
            borderRadius: BorderRadius.circular(35)
          ),
          width: MediaQuery.of(context).size.width * 0.8 - 10,
          height: MediaQuery.of(context).size.height * 0.09 - 10,
          child: Center(child: Text(text, style: CommonTheme.getMediumTextStyle(context)))
        )
      );
  }

  getButtonState(BuildContext context, String button) {
    if (buttonSelected.isEmpty) { return getButton(context, false, button); }
    if (buttonSelected == button) { return getButton(context, true, button); }
    return getButton(context, false, button);
  }

  handleButtonPress(args, BuildContext context) async {
    setState(() { businessCodeError = false; });
    setState(() { employeeBusinessCodeError = false; });
    String businessCode = businessCodeController.text;
    if (businessCode.isEmpty) { context.loaderOverlay.hide(); setState(() { businessCodeError = true; }); return; }

    final collection = await DefaultFirebaseOptions.database.collection(businessCode).doc("Users").collection("Managers").get();
    if (!adminFlag && collection.docs.isEmpty) { context.loaderOverlay.hide(); setState(() { employeeBusinessCodeError = true; }); return; }

    DefaultFirebaseOptions.auth.createUserWithEmailAndPassword(
      email: args["email"], password: args["password"]
    ).then((UserCredential userCredentials) async {
      await DefaultFirebaseOptions.auth.currentUser!.updateDisplayName(args["displayName"]);

      String updateClaimsResponse = await signUpService.updateClaims(
        UpdateClaimsDTO(
          userCredentials.user!.uid,
          businessCode,
          adminFlag
        )
      );
      if (updateClaimsResponse != "success") { context.loaderOverlay.hide(); setState(() { signUpError = true; }); return; }

      await DefaultFirebaseOptions
        .database
        .collection(businessCode)
        .doc("Users")
        .collection((adminFlag) ? "Managers" : "Employees")
        .doc(userCredentials.user!.uid)
        .set(
          {
            'ID': userCredentials.user!.uid,
            'Display Name': args["displayName"]
          },
          SetOptions(merge: true)
        );

      final businessInfoRef = await DefaultFirebaseOptions
        .database
        .collection(businessCode)
        .doc("Business Info")
        .get();
      if (!businessInfoRef.exists) {
        await DefaultFirebaseOptions
          .database
          .collection(businessCode)
          .doc("Business Info")
          .set({
            "Subscription Info": {
              "Customer Id": "",
              "Subscription Id": "",
              "Tier": "Free"
            }
          });
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    
    return LoaderOverlay(child: Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(child: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const Padding(padding: EdgeInsets.all(25)),
        
        Center(child: Text("What is your role?", style: CommonTheme.getLargeTextStyle(context), textAlign: TextAlign.center,)),

        const Padding(padding: EdgeInsets.all(25)),

        GestureDetector(
          onTap:() => toggleAdmin(false),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              gradient: CommonTheme.buttonGradient,
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.09,
            child: getButtonState(context, "Employee"),
          )
        ),

        const Padding(padding: EdgeInsets.all(10)),

        GestureDetector(
          onTap: () => toggleAdmin(true),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              gradient: CommonTheme.buttonGradient,
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.09,
            child: getButtonState(context, "Manager")
          )
        ),
        
        const Padding(padding: EdgeInsets.all(20)),

        (buttonSelected.isEmpty)
        ? Container()
        : Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CommonTheme.purpleColor,
              width: 5.0,
              style: BorderStyle.solid
            ),
            borderRadius: BorderRadius.circular(35)
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(children: <Widget>[
            const Padding(padding: EdgeInsetsDirectional.only(top: 10)),
            Text(adminFlag ? "Create your Company Code" : "Enter your Company Code", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.048)),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(cursorColor: CommonTheme.whiteColor, controller: businessCodeController, style: CommonTheme.getSmallTextStyle(context))
            ),
            const Padding(padding: EdgeInsetsDirectional.only(bottom: 20),)
          ])
        ),
        const Padding(padding: EdgeInsets.all(2)),
        Text(businessCodeError ? "Enter a valid Business Code" : "", style: CommonTheme.getErrorTextStyle(context)),
        Text(employeeBusinessCodeError ? "Business not found" : "", style: CommonTheme.getErrorTextStyle(context)),
        Text(signUpError ? "Error Signing Up, try again" : "", style: CommonTheme.getErrorTextStyle(context)),
        const Padding(padding: EdgeInsets.all(2)),

        GestureDetector(
          onTap:() { context.loaderOverlay.show(); handleButtonPress(args, context); },
          child: Center(child: Container(
            decoration: BoxDecoration(
              gradient: CommonTheme.buttonGradient,
              borderRadius: BorderRadius.circular(35)
            ),
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Center(child: Text("Sign Up", style: CommonTheme.getMediumTextStyle(context)))
          ))
        )
      ]))))
    ));
  }
}
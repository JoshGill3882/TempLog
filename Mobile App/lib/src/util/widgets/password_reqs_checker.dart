import 'package:flutter/material.dart';
import 'package:templog/src/theme/common_theme.dart';

// ignore: must_be_immutable
class PasswordReqsChecker extends StatelessWidget {
  String password;
  PasswordReqsChecker({required this.password, super.key });

  // TextStyle

  // Regex's
  final RegExp uppercaseLetterChecker = RegExp('.*[A-Z].*');
  final RegExp numberChecker = RegExp('.*[0-9].*');
  
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // Length is between 8 and 32 characters (inclusive)
      (password.length > 7 && password.length < 33)
        ? Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.lightPurpleColor),
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.05,
            child: Icon(Icons.check, color: CommonTheme.whiteColor, size: MediaQuery.of(context).size.width * 0.04)
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text("Between 8 and 32 characters long", style: CommonTheme.getSmallTextStyle(context))
        ])
        : Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.05,
            child: Icon(Icons.close, color: CommonTheme.whiteColor, size: MediaQuery.of(context).size.width * 0.04)
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text("Between 8 and 32 characters long", style: CommonTheme.getSmallTextStyle(context))
        ]),
      const Padding(padding: EdgeInsets.all(2)),

      // Contains at least 1 Uppercase Letter
      (uppercaseLetterChecker.hasMatch(password))
        ? Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.lightPurpleColor),
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.05,
            child: Icon(Icons.check, color: CommonTheme.whiteColor, size: MediaQuery.of(context).size.width * 0.04)
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text("Contains at least 1 Uppercase Letter", style: CommonTheme.getSmallTextStyle(context))
        ])
        : Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.05,
            child: Icon(Icons.close, color: CommonTheme.whiteColor, size: MediaQuery.of(context).size.width * 0.04)
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text("Contains at least 1 Uppercase Letter", style: CommonTheme.getSmallTextStyle(context))
        ]),
      const Padding(padding: EdgeInsets.all(2)),

      // Contains at least 1 Number
      (numberChecker.hasMatch(password))
        ? Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.lightPurpleColor),
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.05,
            child: Icon(Icons.check, color: CommonTheme.whiteColor, size: MediaQuery.of(context).size.width * 0.04)
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text("Contains at least 1 Number", style: CommonTheme.getSmallTextStyle(context))
        ])
        : Row(children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.05,
            child: Icon(Icons.close, color: CommonTheme.whiteColor, size: MediaQuery.of(context).size.width * 0.04)
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text("Contains at least 1 Number", style: CommonTheme.getSmallTextStyle(context))
        ]),
      
    ]);
  }
}
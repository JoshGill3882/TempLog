import 'package:flutter/material.dart';
import 'package:templog/src/theme/common_theme.dart';

class ComingSoonAlert extends StatelessWidget {
  const ComingSoonAlert({ super.key });

  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CommonTheme.deepPurpleColor,
      content: SingleChildScrollView(child: Column(children: <Widget>[
        Text("Coming soon", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.05)),
        const Padding(padding: EdgeInsets.all(10)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text("Close", style: CommonTheme.getMediumTextStyle(context))
          )
        )
      ]))
    );
  }
}
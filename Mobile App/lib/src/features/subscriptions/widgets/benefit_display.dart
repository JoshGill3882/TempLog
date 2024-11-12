import 'package:flutter/material.dart';
import 'package:templog/src/theme/common_theme.dart';

class BenefitDisplay extends StatelessWidget {
  final String text;
  final theme = CommonTheme.themeData;
  BenefitDisplay({ required this.text, super.key });

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), gradient: CommonTheme.buttonGradient),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.height * 0.05,
        child: const Icon(Icons.check, size: 30, color: CommonTheme.whiteColor)
      ),
      const Padding(padding: EdgeInsets.all(5)),
      Text(text, style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.04, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold))
    ]);
  }
}
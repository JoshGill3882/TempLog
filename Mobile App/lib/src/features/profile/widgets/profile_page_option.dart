import 'package:flutter/material.dart';
import 'package:templog/src/theme/common_theme.dart';

class ProfilePageOption extends StatelessWidget {
  final Function changePage;
  final Widget newPage;
  final String image;
  final String text;
  ProfilePageOption({ required this.changePage, required this.newPage, required this.image, required this.text, super.key });

  final theme = CommonTheme.themeData;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GestureDetector(
        onTap: () => changePage(newPage),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              Image(image: AssetImage(image), width: MediaQuery.of(context).size.width * 0.1),
              const Padding(padding: EdgeInsets.all(5)),
              Text(text, style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
            ]),
            Image(image: const AssetImage("lib/src/images/icons/misc/right-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
          ]
        )
      ),
      const Padding(padding: EdgeInsets.all(5))
    ]);
  }
}

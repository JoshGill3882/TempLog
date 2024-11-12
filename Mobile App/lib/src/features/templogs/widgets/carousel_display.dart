import 'package:flutter/material.dart';
import 'package:templog/src/theme/common_theme.dart';

class CarouselDisplay extends StatefulWidget {
  final String dayOfWeek;
  final int date;
  const CarouselDisplay(this.dayOfWeek, this.date, {super.key});

  @override
  State<CarouselDisplay> createState() => _CarouselDisplayState();
}

class _CarouselDisplayState extends State<CarouselDisplay> {
  ThemeData theme = CommonTheme.themeData;

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: CommonTheme.whiteColor
      ),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(
          widget.dayOfWeek,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.043, fontFamily: 'Open Sans', fontWeight: FontWeight.bold)
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Text(
          widget.date.toString(),
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.038, fontFamily: 'Open Sans', fontWeight: FontWeight.bold)
        )
      ])
    ));
  }
}

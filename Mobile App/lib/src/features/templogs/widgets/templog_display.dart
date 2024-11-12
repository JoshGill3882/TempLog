import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:templog/src/features/templogs/data/templog.dart';
import 'package:templog/src/theme/common_theme.dart';

class TemplogDisplay extends StatelessWidget {
  final Templog templog;
  TemplogDisplay({ required this.templog, super.key });

  final theme = CommonTheme.themeData;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
        height: MediaQuery.of(context).size.height * 0.3,
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            alignment: Alignment.center,
            height: constraints.maxHeight - 30,
            child: Column(children: <Widget>[
              // Date Display
              SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Text("Date", style: CommonTheme.getMediumTextStyle(context)),
                Text(DateFormat("dd/MM/yyyy").format(templog.dateTime), style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
              ])),

              const Padding(padding: EdgeInsets.all(5)),
              Container(height: 1, color: CommonTheme.whiteColor),
              const Padding(padding: EdgeInsets.all(5)),
              
              // Time Display
              SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Text("Time", style: CommonTheme.getMediumTextStyle(context)),
                Text(DateFormat("HH:mm").format(templog.dateTime), style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
              ])),

              const Padding(padding: EdgeInsets.all(5)),
              Container(height: 1, color: CommonTheme.whiteColor),
              const Padding(padding: EdgeInsets.all(5)),

              // Device Display
              SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Text("Device", style: CommonTheme.getMediumTextStyle(context)),
                Text(templog.deviceName, style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
              ])),

              const Padding(padding: EdgeInsets.all(5)),
              Container(height: 1, color: CommonTheme.whiteColor),
              const Padding(padding: EdgeInsets.all(5)),
  
              // Temperature Display
              SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Text("Temperature", style: CommonTheme.getMediumTextStyle(context)),
                Row(children: <Widget>[
                  Text(templog.temperature.toString(), style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045)),
                  Text("°C", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
                ])
              ]))
            ])
          );
        })
      ),
      const Padding(padding: EdgeInsets.all(10)),

      // Probe Used slider - TODO fix scaling
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
        height: MediaQuery.of(context).size.height * 0.07,
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight - 20,
            width: constraints.maxWidth - 40,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Text("Probe Used", style: CommonTheme.getMediumTextStyle(context)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.12, child: FittedBox(fit: BoxFit.fill, child: Switch(
                onChanged: (value) {},
                trackColor: (templog.probeUsed) ? const MaterialStatePropertyAll<Color>(CommonTheme.lightPurpleColor) : const MaterialStatePropertyAll<Color>(CommonTheme.deepPurpleColor),
                thumbColor: const MaterialStatePropertyAll<Color>(Colors.white),
                value: templog.probeUsed,
              )))
            ])
          );
        })
      ),
      const Padding(padding: EdgeInsets.all(10)),

      // Signature Entry
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
        height: MediaQuery.of(context).size.height * 0.07,
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight - 20,
            width: constraints.maxWidth - 40,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Text("Signed", style: CommonTheme.getMediumTextStyle(context)),
              Text(templog.signature, style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
            ])
          );
        })
      ),
      const Padding(padding: EdgeInsets.all(10)),

      // Comments Entry
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
        height: MediaQuery.of(context).size.height * 0.15,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: constraints.maxHeight - 20,
            width: constraints.maxWidth - 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Comments", style: CommonTheme.getMediumTextStyle(context)),
                Text(templog.comments, style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
              ]
            )
          );
        })
      ),
      const Padding(padding: EdgeInsets.all(10)),
    ]);
  }
}
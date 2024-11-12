import 'package:flutter/material.dart';
import 'package:templog/src/features/devices/pages/add_device.dart';
import 'package:templog/src/features/home/pages/home_page.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class NoDevicesAlert extends StatelessWidget {
  final Function changePage;
  NoDevicesAlert({ required this.changePage, super.key });

  final theme = CommonTheme.themeData;

  @override
  Widget build (BuildContext context) {
    return AlertDialog(
      backgroundColor: CommonTheme.deepPurpleColor,
      content: Text("No Devices Found, please add a Device", style: CommonTheme.getSmallTextStyle(context)),
      actions: <Widget>[
        // Add Device button
        TextButton(
          onPressed: () {
            MainPage.currentLocation.devices.removeAt(0);
            Navigator.of(context).pop();
            changePage(AddDevice(changePage: changePage));
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
            height: MediaQuery.of(context).size.height * 0.065,
            child: Text("Add Device", style: CommonTheme.getMediumTextStyle(context))
          )
        ),

        // Cancel button
        TextButton(
          onPressed: () {
            MainPage.currentLocation.devices.removeAt(0);
            Navigator.of(context).pop();
            changePage(HomePage(changePage: changePage));
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.065,
            child: Text("Cancel", style: CommonTheme.getMediumTextStyle(context))
          )
        )
      ],
    );
  }
}
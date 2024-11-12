import 'package:flutter/material.dart';
import 'package:templog/src/features/devices/pages/devices_page.dart';
import 'package:templog/src/features/home/pages/home_page.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/profile/pages/profile_page.dart';
import 'package:templog/src/features/templogs/pages/add_log_page.dart';
import 'package:templog/src/features/templogs/pages/logbook_page.dart';
import 'package:templog/src/features/templogs/services/templogs_service.dart';
import 'package:templog/src/theme/common_theme.dart';

class BottomNavBar extends StatelessWidget {
  final Function changePage;
  BottomNavBar({ super.key, required this.changePage });

  final theme = CommonTheme.themeData;
  final templogsService = TemplogsService();

  addLogButton(BuildContext context) async {
    int currentMonthlyLogNumber = await templogsService.getNumOfTemplogs();

    if (currentMonthlyLogNumber < MainPage.currentRestrictions.maxMonthlyLogs) {
      changePage(AddLogPage(changePage: changePage));
      return;
    } else {
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
          backgroundColor: CommonTheme.deepPurpleColor,
          content: SingleChildScrollView(child: Column(children: [
            Text("Maximum Number of Templogs reached this month", style: CommonTheme.getSmallTextStyle(context)),
            const Padding(padding: EdgeInsets.all(7)),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(gradient: CommonTheme.buttonGradient, borderRadius: BorderRadius.circular(35)),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.7,
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: CommonTheme.deepPurpleColor, borderRadius: BorderRadius.circular(35)),
                    height: constraints.maxHeight - 7,
                    width: constraints.maxWidth - 7,
                    child: Text("Close", style: CommonTheme.getMediumTextStyle(context))
                  );
                })
              )
            ),
            const Padding(padding: EdgeInsets.all(5))
          ]))
      ));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.08 + 10, child: Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          const Padding(padding: EdgeInsets.all(2)),

          // Home Button
          GestureDetector(
            onTap:() { changePage(HomePage(changePage: changePage)); },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              child: Image(image: const AssetImage("lib/src/images/icons/bottom_nav/home.png"), height: MediaQuery.of(context).size.width * 0.1, width: MediaQuery.of(context).size.width * 0.1)
            )
          ),

          // Devices Button
          GestureDetector(
            onTap:() { changePage(DevicesPage(changePage: changePage)); },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              child: Align(alignment: Alignment.center, child: Image(image: const AssetImage("lib/src/images/icons/bottom_nav/devices.png"), height: MediaQuery.of(context).size.width * 0.1, width: MediaQuery.of(context).size.width * 0.1))
            )
          ),

          // New Log Button
          GestureDetector(
            onTap: () => addLogButton(context),
            child: Container(
              decoration: const BoxDecoration(gradient: CommonTheme.buttonGradient, shape: BoxShape.circle),
              width: MediaQuery.of(context).size.width * 0.11,
              height: MediaQuery.of(context).size.width * 0.11,
              child: Align(alignment: Alignment.center, child: Image(image: const AssetImage("lib/src/images/icons/bottom_nav/plus.png"), height: MediaQuery.of(context).size.width * 0.1, width: MediaQuery.of(context).size.width * 0.1))
            )
          ),

          // Account Page Button
          GestureDetector(
            onTap:() { changePage(ProfilePage(changePage: changePage)); },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              child: Image(image: const AssetImage("lib/src/images/icons/bottom_nav/profile.png"), height: MediaQuery.of(context).size.width * 0.1, width: MediaQuery.of(context).size.width * 0.1)
            )
          ),

          // Logbook Page Button
          GestureDetector(
            onTap:() { changePage(LogbookPage(changePage)); },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.1,
              child: Image(image: const AssetImage("lib/src/images/icons/bottom_nav/logbook.png"), height: MediaQuery.of(context).size.width * 0.1, width: MediaQuery.of(context).size.width * 0.1)
            )
          ),

          const Padding(padding: EdgeInsets.all(2))
        ])
      ),
      const Padding(padding: EdgeInsets.all(5))
    ]));
  }
}
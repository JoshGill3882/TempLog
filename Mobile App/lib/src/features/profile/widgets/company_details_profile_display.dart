import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:templog/src/features/profile/data/profile.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/services/shared_preference_service.dart';
import 'package:templog/src/util/widgets/name_entry_popup.dart';

class CompanyDetailsProfileDisplay extends StatelessWidget {
  final Function changePage;
  final Profile profile;
  final bool fromSharedPreferences;
  final Function updatePageFunction;
  CompanyDetailsProfileDisplay({ required this.changePage, required this.profile, required this.fromSharedPreferences, required this.updatePageFunction, super.key });

  final theme = CommonTheme.themeData;
  final sharedPreferenceService = SharedPreferenceService();

  handleEditEmployee(BuildContext context) async {
    String? newName = await showDialog<String>(context: context, builder: (context) => NameEntryPopup(initialName: profile.displayName));

    if (newName != null) {
      List<String>? sharedPreferenceEmployeeList = await sharedPreferenceService.getListPreferences("profiles");
      if (sharedPreferenceEmployeeList != null) {
        // For each name in the list
        for (int x = 0; x < sharedPreferenceEmployeeList.length; x++) {
          // If the current name matches this display's name
          if (sharedPreferenceEmployeeList[x] == profile.displayName) {
            // Update the name to match the new name
            sharedPreferenceEmployeeList[x] = newName;
            // Update Shared Preferences
            await sharedPreferenceService.setListPreferences("profiles", sharedPreferenceEmployeeList);
            // Break
            break;
          }
        }
      }
    }

    updatePageFunction();
  }

  handleDeleteEmployee() async {
    List<String>? sharedPreferenceEmployeeList = await sharedPreferenceService.getListPreferences("profiles");
    if (sharedPreferenceEmployeeList != null) {
      // For each name in the list
      for (int x = 0; x < sharedPreferenceEmployeeList.length; x++) {
        // If the current name matches this display's name
        if (sharedPreferenceEmployeeList[x] == profile.displayName) {
          // Delete it from the local list
          sharedPreferenceEmployeeList.removeAt(x);
          // Update Shared Preferences
          await sharedPreferenceService.setListPreferences("profiles", sharedPreferenceEmployeeList);
          // Break
          break;
        }
      }
    }

    updatePageFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GestureDetector( // Not sure GestureDetector is needed - future functionality - promoting/demoting employees/managers
        onTap: () { },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
          height: MediaQuery.of(context).size.height * 0.09,
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight - 10,
              width: constraints.maxWidth - 40,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Row(children: [
                  Image(image: const AssetImage("lib/src/images/icons/profile/profile.png"), width: MediaQuery.of(context).size.width * 0.1),
                  const Padding(padding: EdgeInsets.all(10)),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    (profile.admin)
                      ? Text("Manager Name", style: CommonTheme.getSmallTextStyle(context))
                      : Text("Employee Name", style: CommonTheme.getSmallTextStyle(context)),

                    Text(profile.displayName, style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.045, fontFamily: 'Open Sans', fontWeight: FontWeight.bold))
                  ]),
                ]),

                (fromSharedPreferences)
                  ? Row(children: [
                    // Edit button
                    GestureDetector(
                      onTap: () => handleEditEmployee(context),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), gradient: CommonTheme.buttonGradient),
                        height: MediaQuery.of(context).size.width * 0.09,
                          width: MediaQuery.of(context).size.width * 0.09,
                        child: const Icon(Icons.mode_edit, color: CommonTheme.whiteColor, size: 20)
                      )
                    ),

                    const Padding(padding: EdgeInsets.all(5)),

                    // Delete button
                    GestureDetector(
                      onTap: () => handleDeleteEmployee(),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.purpleColor),
                        height: MediaQuery.of(context).size.width * 0.09,
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.deepPurpleColor),
                            height: constraints.maxHeight - 5, width: constraints.maxWidth - 5,
                            child: const Icon(Icons.clear, color: CommonTheme.whiteColor, size: 20)
                          );
                        })
                      )
                    )
                  ])
                  : Container()
              ])
            );
          })
        )
      ),
      const Padding(padding: EdgeInsets.all(3))
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/profile/data/profile.dart';
import 'package:templog/src/features/profile/pages/profile_page.dart';
import 'package:templog/src/features/profile/services/profile_service.dart';
import 'package:templog/src/features/profile/widgets/company_details_profile_display.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/services/shared_preference_service.dart';
import 'package:templog/src/util/widgets/name_entry_popup.dart';

class CompanyDetailsPage extends StatefulWidget {
  final Function changePage;
  const CompanyDetailsPage({ required this.changePage, super.key });

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final theme = CommonTheme.themeData;
  final profileService = ProfileService();
  final sharedPreferenceService = SharedPreferenceService();
  List<Profile> managers = [];
  Column managerListView = const Column();
  List<Profile> employees = [];
  bool noEmployees = true;
  Column employeeListView = const Column();

  @override
  initState() {
    super.initState();
    getProfileLists();
  }

  updatePage() async { await getProfileLists(); }

  getProfileLists() async {
    MainPage.showLoader(context, false, "");
    noEmployees = true;
    
    // Get profiles from the Repository
    final List<List<Profile>> profiles = await profileService.getProfiles();
    
    // Manager Displays generator
    managers = profiles[0];
    List<CompanyDetailsProfileDisplay> managerDisplays = [];
    for (Profile manager in managers) { managerDisplays.add(CompanyDetailsProfileDisplay(changePage: widget.changePage, profile: manager, fromSharedPreferences: false, updatePageFunction: updatePage)); }
    

    // Employee Displays generator
    employees = profiles[1];
    List<CompanyDetailsProfileDisplay> employeeDisplays = [];
    for (Profile employee in employees) { noEmployees = false; employeeDisplays.add(CompanyDetailsProfileDisplay(changePage: widget.changePage, profile: employee, fromSharedPreferences: false, updatePageFunction: updatePage)); }

    // Get Employees from Shared Preferences
    List<String>? sharedPreferenceEmployees = await sharedPreferenceService.getListPreferences("profiles");
    if (sharedPreferenceEmployees != null) {
      for (String name in sharedPreferenceEmployees) {
        noEmployees = false;
        Profile tempProfile = Profile(userId: "", displayName: name, admin: false);
        employeeDisplays.add(CompanyDetailsProfileDisplay(changePage: widget.changePage, profile: tempProfile, fromSharedPreferences: true, updatePageFunction: updatePage));
      }
    }
    

    MainPage.hideLoader(context);
    setState(() {
      managerListView = Column(children: managerDisplays);
      employeeListView = Column(children: employeeDisplays);
    });
  }

  handleAddEmployee() async {
    String? newName = await showDialog<String>(context: context, builder: (context) => NameEntryPopup(initialName: null));

    if (newName != null) {
      List<String>? sharedPreferenceEmployeeList = await sharedPreferenceService.getListPreferences("profiles");
      sharedPreferenceEmployeeList ??= [];
      sharedPreferenceEmployeeList.add(newName);
      await sharedPreferenceService.setListPreferences("profiles", sharedPreferenceEmployeeList);
    }

    await updatePage();
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SingleChildScrollView(child: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Row(children: <Widget>[
        GestureDetector(
          onTap: () => widget.changePage(ProfilePage(changePage: widget.changePage)),
          child: Image(image: const AssetImage("lib/src/images/icons/misc/left-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
        ),
        const Padding(padding: EdgeInsets.all(3)),
        Text("Company Details", style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.08, fontFamily: 'Open Sans', fontWeight: FontWeight.bold))
      ]),
      const Padding(padding: EdgeInsets.all(15)),

      Text("   Managers", style: CommonTheme.getMediumTextStyle(context)),
      const Padding(padding: EdgeInsets.all(5)),
      managerListView,
      const Padding(padding: EdgeInsets.all(10)),

      Text("   Employees", style: CommonTheme.getMediumTextStyle(context)),
      (noEmployees)
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          const Padding(padding: EdgeInsets.all(5)),
          Text("   No Employees Found", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.05))
        ])
        : Column(children: <Widget>[
          const Padding(padding: EdgeInsets.all(5)),
          employeeListView
        ]),
      const Padding(padding: EdgeInsets.all(10)),

      Align(alignment: Alignment.center, child: GestureDetector(
        onTap: () => handleAddEmployee(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Text("Add Employee", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.065, fontWeight: FontWeight.bold))
        )
      )),
      const Padding(padding: EdgeInsets.all(10))
    ])))));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/devices/data/device.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/profile/data/profile.dart';
import 'package:templog/src/features/profile/services/profile_service.dart';
import 'package:templog/src/features/templogs/data/templog.dart';
import 'package:templog/src/features/templogs/pages/logbook_page.dart';
import 'package:templog/src/features/templogs/services/templogs_service.dart';
import 'package:templog/src/util/widgets/name_entry_popup.dart';
import 'package:templog/src/features/templogs/widgets/no_devices_alert.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/services/shared_preference_service.dart';
import 'package:templog/src/util/validators.dart';

class TemplogEntryForm extends StatefulWidget {
  final Function changePage;
  const TemplogEntryForm({ required this.changePage, super.key });

  @override
  State<TemplogEntryForm> createState() => _TemplogEntryFormState();
}

class _TemplogEntryFormState extends State<TemplogEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final theme = CommonTheme.themeData;
  final profileService = ProfileService();
  final templogsService = TemplogsService();
  final sharedPreferenceService = SharedPreferenceService();

  late DateTime dateTime = DateTime.now();
  late String deviceName = (MainPage.currentLocation.devices.isEmpty) ? "" : MainPage.currentLocation.devices[0].deviceName;
  double? temperature;
  late bool probeUsed = true;
  late Profile signature = Profile(userId: "", displayName: "", admin: false);
  late String comments = "";
  bool temperatureError = false;

  late List<Profile> profiles = [Profile(userId: "", displayName: "", admin: false)];

  @override
  void initState() {
    super.initState();
    widgetSetup();
  }

  widgetSetup() async {
    // Get all the profiles for the current business
    final allProfiles = await profileService.getProfiles();
    // For each list of profiles (managers and employees)
    for (List<Profile> profileList in allProfiles) {
      // For each profile, add it to the combined list
      for (Profile profile in profileList) { profiles.add(profile); }
    }
    if (profiles[0].displayName == "") { profiles.removeAt(0); }

    // Get the (non-full-account) profiles from Shared Preferences
    List<String> sharedPrefProfiles = await sharedPreferenceService.getListPreferences("profiles");

    List<String> toRemove = [];
    List<String> toAdd = [];
    
    // For each of the current profiles
    for (Profile profile in profiles) {
      // For each profile from Shared Preferences
      for (String sharedPrefProfileName in sharedPrefProfiles) {
        // If the names match, delete it from Shared Preferences
        if (profile.displayName == sharedPrefProfileName) { toRemove.add(sharedPrefProfileName); }
        // Otherwise, add it to the main profiles list
        else { toAdd.add(sharedPrefProfileName); }
      }
    }
    for (String name in toRemove) { sharedPrefProfiles.removeWhere((element) => element == name); }
    for (String name in toAdd) { profiles.add(Profile(userId: "", displayName: name, admin: false)); }
    // Re-Set the shared-preferences list in case any names were deleted
    await sharedPreferenceService.setListPreferences("profiles", sharedPrefProfiles);

    // TODO - use case of an employee using one device on many businesses - Shared Preference profiles will be shared between businesses
    // Potentially rename list preference to "profiles-BUSINESS_CODE"?

    // If the current user is an admin, add the functionality of adding a new employee to the list
    IdTokenResult userCustomClaims = await DefaultFirebaseOptions.auth.currentUser!.getIdTokenResult(true);
    if (userCustomClaims.claims!["admin"]) { profiles.add(Profile(userId: "", displayName: "Add Employee", admin: false)); }

    String firstDeviceName = "";
    if (MainPage.currentLocation.devices.isEmpty) {
      MainPage.currentLocation.devices.add(Device("", "", DeviceType.other, ""));
      showDialog(context: context, builder: (context) => NoDevicesAlert(changePage: widget.changePage,));
    } else { firstDeviceName = MainPage.currentLocation.devices[0].deviceName; }

    // Set the starting values
    setState(() {
      dateTime = DateTime.now();
      deviceName = firstDeviceName;
      temperature = null;
      probeUsed = true;
      signature = profiles.firstWhere((element) => element.displayName == DefaultFirebaseOptions.auth.currentUser!.displayName);;
      comments = "";
    });
  }

  datePicker(BuildContext context) async {
    final DateTime? newDateTime = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100)
    );
    if (newDateTime != null) { setState(() { dateTime = newDateTime; }); }
  }

  timePicker(BuildContext context) async {
    TimeOfDay currentTime = TimeOfDay.fromDateTime(dateTime);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: currentTime
    );
    if (newTime != null) { setState(() => dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, newTime.hour, newTime.minute)); }
  }

  handleAddEmployee() async {
    // Call the dialogue for entering a new name
    String? newFullName = await showDialog<String>(context: context, builder: (context) => NameEntryPopup(initialName: null));

    // If the variable is not null, a name was entered into the dialogue
    if (newFullName != null) {
      // Get the current profiles list from Shared Preferences
      List<String>? sharedPrefProfiles = await sharedPreferenceService.getListPreferences("profiles");
      if (sharedPrefProfiles == null) { sharedPrefProfiles == []; }
      // Add the new one
      sharedPrefProfiles!.add(newFullName);
      // Re-Set the list
      await sharedPreferenceService.setListPreferences("profiles", sharedPrefProfiles);

      // Make a new dummy profile with the correct details
      Profile tempProfile = Profile(userId: "", displayName: newFullName, admin: false);
      // Remove the last entry ("Add Employee") - so that the new entry does not end up on the bottom of the list
      profiles.removeLast();
      // Add the new profile to the main "profiles" list
      profiles.add(tempProfile);
      // Re-Add the "Add Employee" entry
      profiles.add(Profile(userId: "", displayName: "Add Employee", admin: false));
      // Set the new profile as the current profile
      setState(() { signature = tempProfile; });
    }
  }

  handleButtonPress(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      MainPage.showLoader(context, false, "");

      Templog newTemplog = Templog(
        id: "",
        location: MainPage.currentLocation,
        deviceName: deviceName,
        dateTime: dateTime,
        temperature: temperature!,
        probeUsed: probeUsed,
        signature: signature.displayName,
        comments: comments
      );

      await templogsService.setTemplog(newTemplog);
      MainPage.hideLoader(context);
      widget.changePage(LogbookPage(widget.changePage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.3,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                alignment: Alignment.center,
                height: constraints.maxHeight - 30,
                child: Column(children: <Widget>[
                  // Date Picker
                  SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    Text("Date", style: CommonTheme.getMediumTextStyle(context)),
                    GestureDetector(
                      onTap: () => datePicker(context),
                      child: Row(children: <Widget>[
                        Text(DateFormat("dd/MM/yyyy").format(dateTime), style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045)),
                        Image(image: const AssetImage("lib/src/images/icons/templogs/logbook/down-arrow.png"), width: MediaQuery.of(context).size.width * 0.08)
                      ])
                    )
                  ])),

                  const Padding(padding: EdgeInsets.all(5)),
                  Container(height: 1, color: CommonTheme.whiteColor),
                  const Padding(padding: EdgeInsets.all(5)),

                  // Time Picker
                  SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    Text("Time", style: CommonTheme.getMediumTextStyle(context)),
                    GestureDetector(
                      onTap: () => timePicker(context),
                      child: Row(children: <Widget>[
                        Text(DateFormat("HH:mm").format(dateTime), style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045)),
                        Image(image: const AssetImage("lib/src/images/icons/templogs/logbook/down-arrow.png"), width: MediaQuery.of(context).size.width * 0.08)
                      ])
                    )
                  ])),

                  const Padding(padding: EdgeInsets.all(5)),
                  Container(height: 1, color: CommonTheme.whiteColor),
                  const Padding(padding: EdgeInsets.all(5)),

                  // Device Picker
                  SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    Text("Device", style: CommonTheme.getMediumTextStyle(context)),
                    DropdownButton<String>(
                      alignment: Alignment.centerRight,
                      value: deviceName,
                      icon: Image(image: const AssetImage("lib/src/images/icons/templogs/logbook/down-arrow.png"), width: MediaQuery.of(context).size.width * 0.08),
                      style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045),
                      dropdownColor: CommonTheme.medPurpleColor,
                      underline: Container(), // Empty container so no underline shows
                      onChanged: (value) => setState(() => deviceName = value!),
                      items: MainPage.currentLocation.devices.map<DropdownMenuItem<String>>((Device value) {
                        return DropdownMenuItem<String>(value: value.deviceName, alignment: Alignment.centerRight, child: Text(value.deviceName));
                      }).toList()
                    )
                  ])),
                  
                  const Padding(padding: EdgeInsets.all(5)),
                  Container(height: 1, color: CommonTheme.whiteColor),
                  const Padding(padding: EdgeInsets.all(5)),

                  // Temperature picker
                  SizedBox(height: ((constraints.maxHeight - 93) / 4), width: constraints.maxWidth - 40, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    Text("Temperature", style: CommonTheme.getMediumTextStyle(context)),
                    Row(children: <Widget>[
                      SizedBox(
                        width: 125,
                        height: 30,
                        child: TextFormField(
                          cursorColor: CommonTheme.whiteColor,
                          decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0), isCollapsed: true),
                          style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          textAlign: TextAlign.end,
                          onSaved: (value) => temperature = double.parse(value!),
                          validator: (value) {
                            if (Validators.isNull(value) || Validators.isBlank(value)) { setState(() => temperatureError = true); return "Temperature Error"; }
                            return null;
                          },
                          initialValue: (temperature == null) ? "" : temperature.toString(),
                          textInputAction: TextInputAction.done,
                        )
                      ),
                      Text("°C", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
                    ])
                  ])),
                ])
              );
            })
          ),
          (temperatureError) ? Text("Please enter a temperature", style: CommonTheme.getErrorTextStyle(context)) : const Padding(padding: EdgeInsets.all(0)),
          const Padding(padding: EdgeInsets.all(10)),

          // Probe Used slider - TODO fix scaling
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.07,
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight - 20,
                width: constraints.maxWidth - 40,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text("Probe Used", style: CommonTheme.getMediumTextStyle(context)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.12, child: FittedBox(fit: BoxFit.fill, child: Switch(
                    onChanged: (bool value) => setState(() => probeUsed = value),
                    trackColor: (probeUsed) ? const MaterialStatePropertyAll<Color>(CommonTheme.lightPurpleColor) : const MaterialStatePropertyAll<Color>(CommonTheme.deepPurpleColor),
                    thumbColor: const MaterialStatePropertyAll<Color>(Colors.white),
                    value: probeUsed,
                  )))
                ])
              );
            })
          ),
          const Padding(padding: EdgeInsets.all(10)),

          // Signature Entry
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.07,
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight - 20,
                width: constraints.maxWidth - 40,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text("Signed", style: CommonTheme.getMediumTextStyle(context)),
                  
                  DropdownButton<String>(
                    alignment: Alignment.centerRight,
                    value: signature.displayName,
                    icon: Image(image: const AssetImage("lib/src/images/icons/templogs/logbook/down-arrow.png"), width: MediaQuery.of(context).size.width * 0.08),
                    style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045),
                    dropdownColor: CommonTheme.medPurpleColor,
                    underline: Container(), // Empty container so no underline shows
                    onChanged: (value) {
                      if (value == "Add Employee") { handleAddEmployee(); return; }
                      setState(() => signature = profiles.firstWhere((element) => element.displayName == value));
                    },
                    items: profiles.map<DropdownMenuItem<String>>((Profile value) {
                      return DropdownMenuItem<String>(value: value.displayName, alignment: Alignment.centerRight, child: Text(value.displayName));
                    }).toList()
                  )
                ])
              );
            })
          ),
          const Padding(padding: EdgeInsets.all(10)),

          // Comments Entry
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.15,
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                width: constraints.maxWidth - 40,
                height: constraints.maxHeight - 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Comments", style: CommonTheme.getMediumTextStyle(context)),
                    TextFormField(
                      cursorColor: CommonTheme.whiteColor,
                      decoration: const InputDecoration.collapsed(hintText: null),
                      style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045),
                      maxLines: null,
                      initialValue: comments,
                      onSaved: (newValue) => comments = newValue!,
                      textInputAction: TextInputAction.done,
                    )
                  ]
                )
              );
            })
          ),
          const Padding(padding: EdgeInsets.all(10)),

          // Save button
          Center(
            child: GestureDetector(
              onTap: () => handleButtonPress(context),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), gradient: CommonTheme.buttonGradient),
                height: MediaQuery.of(context).size.height * 0.09,
                child: Text("Save", style: CommonTheme.getLargeTextStyle(context))
              )
            )
          )
        ])
      );
    }, future: null);
  }
}

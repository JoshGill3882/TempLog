import 'package:flutter/material.dart';
import 'package:templog/src/features/devices/data/device.dart';
import 'package:templog/src/features/devices/services/device_service.dart';
import 'package:templog/src/features/home/pages/home_page.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/validators.dart';

// ignore: must_be_immutable
class DeviceEntryForm extends StatefulWidget {
  final Function changePage;
  Device device;
  DeviceEntryForm(this.changePage, this.device, { super.key });

  @override
  State<DeviceEntryForm> createState() => _DeviceEntryFormState();
}

class _DeviceEntryFormState extends State<DeviceEntryForm> {
  final _formKey = GlobalKey<FormState>();
  ThemeData theme = CommonTheme.themeData;
  DeviceService deviceService = DeviceService();

  String? deviceName;
  late DeviceType buttonChosen;
  String? comments;
  bool deviceNameNullError = false;
  bool deviceNameTooLongError = false;

  @override
  void initState() {
    super.initState();
    buttonChosen = (widget.device.deviceId.isEmpty) ? DeviceType.fridge : widget.device.deviceType;
  }

  getDeviceNameError() {
    if (deviceNameNullError) {
      return Text("Please enter a location name", style: CommonTheme.getErrorTextStyle(context));
    } else if (deviceNameTooLongError) {
      return Text("Location Name is too long", style: CommonTheme.getErrorTextStyle(context));
    } else {
      return const Padding(padding: EdgeInsets.all(0));
    }
  }

  setDeviceButton(DeviceType button) { setState(() => buttonChosen = button); }

  handleButtonPress(BuildContext context) async {
    deviceNameNullError = false;
    deviceNameTooLongError = false;
    if (_formKey.currentState!.validate()) {
      MainPage.showLoader(context, false, "");
      _formKey.currentState!.save();

      widget.device = Device(
        (widget.device.deviceId.isEmpty) ? "" : widget.device.deviceId,
        deviceName!,
        buttonChosen,
        (comments == "Add Comments") ? "" : comments!
      );

      await deviceService.setDevice(widget.device);
      MainPage.hideLoader(context);
      widget.changePage(HomePage(changePage: widget.changePage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        // Device Name Entry
        Text("Device Name", style: CommonTheme.getMediumTextStyle(context)),
        const Padding(padding: EdgeInsets.all(5)),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight - 10,
              width: constraints.maxWidth - 40,
              child: TextFormField(
                cursorColor: CommonTheme.whiteColor,
                decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                style: CommonTheme.getSmallTextStyle(context),
                onSaved: (String? newValue) { deviceName = newValue!; },
                validator: (value) {
                  if (Validators.isNull(value) || Validators.isBlank(value)) {
                    setState(() => deviceNameNullError = true);
                    return "Device Name is null"; 
                  } else if (value!.length > 9) {
                    setState(() => deviceNameTooLongError = true);
                    return "Device Name is too long";
                  }
                  return null;
                },
                initialValue: widget.device.deviceName,
              )
            );
          })
        ),
        const Padding(padding: EdgeInsets.all(5)),
        getDeviceNameError(),
        const Padding(padding: EdgeInsets.all(10)),

        // Device Type Picker
        Text("Device Type", style: CommonTheme.getMediumTextStyle(context)),
        const Padding(padding: EdgeInsets.all(5)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          GestureDetector(
            onTap: () => setDeviceButton(DeviceType.fridge),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: (buttonChosen == DeviceType.fridge) ? CommonTheme.buttonGradient : null,
                color: (buttonChosen == DeviceType.fridge) ? null : CommonTheme.medPurpleColor
              ),
              width: MediaQuery.of(context).size.width * 0.27,
              height: MediaQuery.of(context).size.width * 0.27,
              child: Column(mainAxisAlignment : MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Image(image: const AssetImage("lib/src/images/icons/devices/fridge.png"), width: MediaQuery.of(context).size.width * 0.17, height: MediaQuery.of(context).size.width * 0.17),
                Text("Fridge", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.033, fontWeight: FontWeight.bold))
              ])
            )
          ),

          GestureDetector(
            onTap: () => setDeviceButton(DeviceType.freezer),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: (buttonChosen == DeviceType.freezer) ? CommonTheme.buttonGradient : null,
                color: (buttonChosen == DeviceType.freezer) ? null : CommonTheme.medPurpleColor
              ),
              width: MediaQuery.of(context).size.width * 0.27,
              height: MediaQuery.of(context).size.width * 0.27,
              child: Column(mainAxisAlignment : MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Image(image: const AssetImage("lib/src/images/icons/devices/freezer.png"), width: MediaQuery.of(context).size.width * 0.17, height: MediaQuery.of(context).size.width * 0.17),
                Text("Freezer", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.033, fontWeight: FontWeight.bold))
              ])
            )
          ),

          GestureDetector(
            onTap: () => setDeviceButton(DeviceType.other),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: (buttonChosen == DeviceType.other) ? CommonTheme.buttonGradient : null,
                color: (buttonChosen == DeviceType.other) ? null : CommonTheme.medPurpleColor
              ),
              width: MediaQuery.of(context).size.width * 0.27,
              height: MediaQuery.of(context).size.width * 0.27,
              child: Column(mainAxisAlignment : MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Image(image: const AssetImage("lib/src/images/icons/devices/other.png"), width: MediaQuery.of(context).size.width * 0.17, height: MediaQuery.of(context).size.width * 0.17),
                Text("Other", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.033, fontWeight: FontWeight.bold))
              ])
            )
          ),
        ]),
        const Padding(padding: EdgeInsets.all(15)),

        // Comments Box
        Text("Comments", style: CommonTheme.getMediumTextStyle(context)),
        const Padding(padding: EdgeInsets.all(5)),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
          height: MediaQuery.of(context).size.height * 0.2,
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight - 30,
              width: constraints.maxWidth - 40,
              child: TextFormField(
                cursorColor: CommonTheme.whiteColor,
                decoration: const InputDecoration.collapsed(hintText: null),
                style: CommonTheme.getSmallTextStyle(context),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                initialValue: widget.device.comments,
                onSaved: (newValue) => comments = newValue,
              )
            );
          })
        ),
        const Padding(padding: EdgeInsets.all(15)),

        // Save button
        GestureDetector(
          onTap: () => handleButtonPress(context),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), gradient: CommonTheme.buttonGradient),
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Text("Save", style: CommonTheme.getLargeTextStyle(context))
          )
        )
      ])
    );
  }
}

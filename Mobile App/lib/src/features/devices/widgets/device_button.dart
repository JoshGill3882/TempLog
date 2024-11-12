import 'package:flutter/material.dart';
import 'package:templog/src/features/devices/data/device.dart';
import 'package:templog/src/features/devices/pages/add_device.dart';
import 'package:templog/src/features/devices/pages/device_details.dart';
import 'package:templog/src/features/devices/services/device_service.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class DeviceButton extends StatelessWidget {
  final Function changePage;
  final Device device;
  final ThemeData theme = CommonTheme.themeData;
  final deviceService = DeviceService();

  DeviceButton(this.device, this.changePage, { super.key });

  handleButtonPress(BuildContext context) {
    if (device.deviceType == DeviceType.add) {
      int numOfDevices = deviceService.getNumberOfDevices();
      if (numOfDevices < MainPage.currentRestrictions.maxDevices) { changePage(AddDevice(changePage: changePage)); return; }
      else {
        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
          backgroundColor: CommonTheme.deepPurpleColor,
          content: SingleChildScrollView(child: Column(children: [
            Text("Maximum Number of Devices reached", style: CommonTheme.getSmallTextStyle(context)),
            const Padding(padding: EdgeInsets.all(7)),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(gradient: CommonTheme.buttonGradient, borderRadius: BorderRadius.circular(35)),
                height: MediaQuery.of(context).size.height * 0.075,
                width: MediaQuery.of(context).size.width * 0.8,
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
    } else {
      changePage(DeviceDetails(device, changePage));
    }
  }

  Widget getIcon(BuildContext context) {
    switch (device.deviceType.name) {
      case 'add':
        return Image(image: AssetImage("lib/src/images/icons/misc/plus.png"), width: MediaQuery.of(context).size.width * 0.17, height: MediaQuery.of(context).size.width * 0.17);
      case 'fridge':
        return Image(image: AssetImage("lib/src/images/icons/devices/fridge.png"), width: MediaQuery.of(context).size.width * 0.17, height: MediaQuery.of(context).size.width * 0.17);
      case 'freezer':
        return Image(image: AssetImage("lib/src/images/icons/devices/freezer.png"), width: MediaQuery.of(context).size.width * 0.17, height: MediaQuery.of(context).size.width * 0.17);
      default:
        return Image(image: AssetImage("lib/src/images/icons/devices/other.png"), width: MediaQuery.of(context).size.width * 0.17, height: MediaQuery.of(context).size.width * 0.17);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleButtonPress(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: (device.deviceType.name == "add") ? CommonTheme.buttonGradient : null,
          color: (device.deviceType.name == "add") ? null : CommonTheme.medPurpleColor
        ),
        width: MediaQuery.of(context).size.width * 0.27,
        height: MediaQuery.of(context).size.width * 0.27,
        child: Column(mainAxisAlignment : MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          getIcon(context),
          Text(device.deviceName, style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.033, fontWeight: FontWeight.bold))
        ])
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:templog/src/features/devices/data/device.dart';
import 'package:templog/src/features/devices/pages/devices_page.dart';
import 'package:templog/src/features/devices/services/device_service.dart';
import 'package:templog/src/features/devices/widgets/device_entry_form.dart';
import 'package:templog/src/theme/common_theme.dart';

class DeviceDetails extends StatelessWidget {
  final Function changePage;
  final Device device;
  final ThemeData theme = CommonTheme.themeData;
  final DeviceService deviceService = DeviceService();
  DeviceDetails(this.device, this.changePage, { super.key });

  @override
  Widget build(BuildContext context) {
    return Center(child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(children: <Widget>[
      const Padding(padding: EdgeInsets.all(5)),
      Text("Devices", style: CommonTheme.getLargeTextStyle(context)),

      const Padding(padding: EdgeInsets.all(15)),
      DeviceEntryForm(changePage, device),

      const Padding(padding: EdgeInsets.all(10)),
      GestureDetector(
        onTap: () async { await deviceService.deleteDevice(device); changePage(DevicesPage(changePage: changePage)); },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), gradient: CommonTheme.buttonGradient),
          height: MediaQuery.of(context).size.height * 0.075,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.deepPurpleColor),
            height: MediaQuery.of(context).size.height * 0.075 - 5,
            width: MediaQuery.of(context).size.width * 0.85 - 5,
            child: Text("Delete", style: CommonTheme.getLargeTextStyle(context))
          )
        )
      ),
      const Padding(padding: EdgeInsets.all(5))
    ])))));
  }
}

import 'package:flutter/material.dart';
import 'package:templog/src/features/devices/services/device_service.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class DevicesPage extends StatefulWidget {
  final Function changePage;
  const DevicesPage({ super.key, required this.changePage });

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  ThemeData theme = CommonTheme.themeData;
  DeviceService deviceService = DeviceService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: Column(children: <Widget>[
      const Padding(padding: EdgeInsets.all(5)),
      Text("Devices", style: CommonTheme.getLargeTextStyle(context)),
      const Padding(padding: EdgeInsets.all(10)),
      deviceService.getDeviceButtons(MainPage.currentLocation, widget.changePage, context)
    ])))));
  }
}
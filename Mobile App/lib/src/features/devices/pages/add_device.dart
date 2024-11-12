import 'package:flutter/material.dart';
import 'package:templog/src/features/devices/data/device.dart';
import 'package:templog/src/features/devices/widgets/device_entry_form.dart';
import 'package:templog/src/theme/common_theme.dart';

class AddDevice extends StatelessWidget {
  final Function changePage;
  final ThemeData theme = CommonTheme.themeData;
  AddDevice({ super.key, required this.changePage });

  @override
  Widget build(BuildContext context) {
    return Center(child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(children: <Widget>[
      const Padding(padding: EdgeInsets.all(5)),
      Text("Devices", style: theme.textTheme.displayLarge),

      const Padding(padding: EdgeInsets.all(10)),
      DeviceEntryForm(changePage, Device("", "", DeviceType.add, "")),
      const Padding(padding: EdgeInsets.all(10)),
    ])))));
  }
}
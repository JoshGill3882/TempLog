import 'package:flutter/material.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/templogs/widgets/templog_entry_form.dart';
import 'package:templog/src/theme/common_theme.dart';

class AddLogPage extends StatelessWidget {
  final Function changePage;
  final theme = CommonTheme.themeData;
  AddLogPage({ required this.changePage, super.key });
  
  @override
  Widget build(BuildContext context) {
    MainPage.hideLoader(context);
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(children: <Widget>[
      Text("Add Log", style: CommonTheme.getLargeTextStyle(context)),
      const Padding(padding: EdgeInsets.all(10)),

      TemplogEntryForm(changePage: changePage),
      const Padding(padding: EdgeInsets.all(10))
    ])))));
  }
}

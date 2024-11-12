import 'package:flutter/material.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/templogs/data/templog.dart';
import 'package:templog/src/features/templogs/pages/logbook_page.dart';
import 'package:templog/src/features/templogs/services/templogs_service.dart';
import 'package:templog/src/features/templogs/widgets/templog_display.dart';
import 'package:templog/src/theme/common_theme.dart';

class TemplogDetailsPage extends StatelessWidget {
  final Templog templog;
  final Function changePage;
  final ThemeData theme = CommonTheme.themeData;
  final TemplogsService templogsService = TemplogsService();
  TemplogDetailsPage({ required this.templog, required this.changePage, super.key });

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(children: <Widget>[
      Text("Log Details", style: CommonTheme.getLargeTextStyle(context)),
      const Padding(padding: EdgeInsets.all(10)),

      TemplogDisplay(templog: templog),
      const Padding(padding: EdgeInsets.all(5)),

      GestureDetector(
        onTap: () async { MainPage.showLoader(context, false, ""); await templogsService.deleteTemplog(templog); MainPage.hideLoader(context); changePage(LogbookPage(changePage)); },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), gradient: CommonTheme.buttonGradient),
          height: MediaQuery.of(context).size.height * 0.09,
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.deepPurpleColor),
              width: constraints.maxWidth - 10,
              height: constraints.maxHeight - 10,
              child: Text("Delete", style: CommonTheme.getLargeTextStyle(context))
            );
          } )
        )
      ),
      const Padding(padding: EdgeInsets.all(5))
    ])))));
  }
}

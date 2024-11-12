import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:templog/src/features/templogs/data/templog.dart';
import 'package:templog/src/features/templogs/pages/templog_details_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class TemplogTable extends StatelessWidget {
  final List<Templog> templogs;
  final Function changePage;

  TemplogTable(this.templogs, this.changePage, {super.key});

  final ThemeData theme = CommonTheme.themeData;
  final DateFormat timeFormatter = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    if (templogs.isEmpty) { return Center(child: Text("No Logs Found", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.05, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold))); }

    TextStyle tableHeaderTextStyle = TextStyle(
        color: CommonTheme.whiteColor,
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.bold
    );
    TextStyle tableItemTextStyle = TextStyle(
        color: CommonTheme.whiteColor,
        fontSize: MediaQuery.of(context).size.width * 0.035,
        fontFamily: 'Open Sans'
    );

    List<TableRow> tableRows = [];
    tableRows.add(TableRow(children: <Widget>[
      Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: Center(child: Text("Device", style: tableHeaderTextStyle))),
      Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: Center(child: Text("Time", style: tableHeaderTextStyle))),
      Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: Center(child: Text("Temperature", style: tableHeaderTextStyle)))
    ]));

    for (Templog templog in templogs) {
      tableRows.add(TableRow(children: <Widget>[
        GestureDetector(onTap: () => changePage(TemplogDetailsPage(templog: templog, changePage: changePage)), child: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: Center(child: Text(templog.deviceName, style: tableItemTextStyle)))),
        GestureDetector(onTap: () => changePage(TemplogDetailsPage(templog: templog, changePage: changePage)), child: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: Center(child: Text(timeFormatter.format(templog.dateTime), style: tableItemTextStyle)))),
        GestureDetector(onTap: () => changePage(TemplogDetailsPage(templog: templog, changePage: changePage)), child: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), child: Center(child: Text("${templog.temperature}°C", style: tableItemTextStyle))))
      ]));
    }

    return Table(
      border: const TableBorder(bottom: BorderSide(width: 1, color: CommonTheme.whiteColor), horizontalInside: BorderSide(width: 1, color: CommonTheme.whiteColor)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: tableRows
    );
  }
}
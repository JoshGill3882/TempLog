import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/templogs/data/templog.dart';
import 'package:templog/src/features/templogs/pages/add_log_page.dart';
import 'package:templog/src/features/templogs/pages/download_data_page.dart';
import 'package:templog/src/features/templogs/services/carousel_service.dart';
import 'package:templog/src/features/templogs/services/templogs_service.dart';
import 'package:templog/src/features/templogs/widgets/carousel_display.dart';
import 'package:templog/src/features/templogs/widgets/templog_table.dart';
import 'package:templog/src/theme/common_theme.dart';

class LogbookPage extends StatefulWidget {
  final Function changePage;
  const LogbookPage(this.changePage, { super.key });

  @override
  State<LogbookPage> createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  ThemeData theme = CommonTheme.themeData;
  DateTime currentDate = DateTime.now();
  final DateFormat dateFormatter = DateFormat('MMMM, yyyy');
  CarouselController carouselController = CarouselController();
  CarouselService carouselService = CarouselService();
  late List<CarouselDisplay> carouselDisplayList = carouselService.getCarouselObjects(currentDate);
  TemplogsService templogsService = TemplogsService();
  late List<Templog> templogs;
  Widget logbookTable = Container();

  @override
  initState() {
    super.initState();
    initLogbookTable();
  }

  initLogbookTable() async {
    List<Templog> newTemplogs = await templogsService.getTemplogs(currentDate);
    setState(() {
      currentDate = currentDate;
      templogs = newTemplogs;
      logbookTable = TemplogTable(templogs, widget.changePage);
    });
  }

  changeMonth(BuildContext context) async {
    var newDate = await showMonthPicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050)
    );
    if (newDate != null) {
      setState(() {
        currentDate = newDate;
        carouselDisplayList = carouselService.getCarouselObjects(currentDate);
      });
    }
  }

  checkIfToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(currentDate.year, currentDate.month, currentDate.day);

    return dateToCheck != today;
  }

  addLogButton() async {
    int currentMonthlyLogNumber = await templogsService.getNumOfTemplogs();

    if (currentMonthlyLogNumber < MainPage.currentRestrictions.maxMonthlyLogs) {
      widget.changePage(AddLogPage(changePage: widget.changePage));
      return;
    } else {
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        backgroundColor: CommonTheme.deepPurpleColor,
        content: SingleChildScrollView(child: Column(children: [
          Text("Maximum Number of Templogs reached this month", style: theme.textTheme.displaySmall),
          const Padding(padding: EdgeInsets.all(7)),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(gradient: CommonTheme.buttonGradient, borderRadius: BorderRadius.circular(35)),
              height: 50,
              width: 500,
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: CommonTheme.deepPurpleColor, borderRadius: BorderRadius.circular(35)),
                  height: constraints.maxHeight - 7,
                  width: constraints.maxWidth - 7,
                  child: Text("Close", style: theme.textTheme.displayMedium)
                );
              })
            )
          ),
          const Padding(padding: EdgeInsets.all(5))
        ]))
      ));
      return;
    }
  }

  @override
  Widget build(BuildContext context) { return FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
    MainPage.hideLoader(context);
    return SingleChildScrollView(child: Center(child: SafeArea(child: Column(children: <Widget>[
      (MainPage.currentRestrictions.downloadAllowed)
        ? FractionallySizedBox(widthFactor: 0.9, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          SizedBox(width: MediaQuery.of(context).size.width * 0.12, height: MediaQuery.of(context).size.width * 0.12),
          GestureDetector(
            onTap: () => widget.changePage(DownloadDataPage(changePage: widget.changePage, previousPage: LogbookPage(widget.changePage))),
            child: Image(image: const AssetImage("lib/src/images/icons/templogs/logbook/download.png"), width: MediaQuery.of(context).size.width * 0.12, height: MediaQuery.of(context).size.width * 0.12)
          )
        ]))
        : const Padding(padding: EdgeInsets.all(5)),

      Text("Logbook", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.08, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold)),
      const Padding(padding: EdgeInsets.all(3)),

      GestureDetector(
        onTap: () => changeMonth(context),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(dateFormatter.format(currentDate), style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.05, color: CommonTheme.whiteColor)),
          const Padding(padding: EdgeInsets.all(5)),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: CommonTheme.whiteColor),
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.07,
            child: Align(alignment: Alignment.center, child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) { return Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: CommonTheme.deepPurpleColor),
              width: constraints.maxWidth - 3,
              height: constraints.maxHeight - 3,
              child: const Image(image: AssetImage("lib/src/images/icons/templogs/logbook/down-arrow.png"), width: 18, height: 18)
            ); }))
          )
        ])
      ),
      const Padding(padding: EdgeInsets.all(10)),

      CarouselSlider(
        items: carouselDisplayList,
        carouselController: carouselController,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.13,
          initialPage: currentDate.day - 1,
          viewportFraction: 0.25,
          enableInfiniteScroll: false,
          onPageChanged: (newItemIndex, reason) async {
            MainPage.showLoader(context, false, "");
            DateTime newDate = DateTime(currentDate.year, currentDate.month, newItemIndex + 1);
            List<Templog> newTemplogs = await templogsService.getTemplogs(newDate); 
            setState(() {
              currentDate = newDate;
              templogs = newTemplogs;
              logbookTable = TemplogTable(templogs, widget.changePage);
            });
          },
        )
      ),
      const Padding(padding: EdgeInsets.all(15)),

      FractionallySizedBox(widthFactor: 0.97, child: logbookTable),
      const Padding(padding: EdgeInsets.all(15)),

      (checkIfToday())
        ? Container()
        : GestureDetector(
          onTap: () => addLogButton(),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.075,
            child: Align(alignment: Alignment.center, child: Text(
              "Add Log",
              style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.055, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold)
            ))
          )
        ),
      const Padding(padding: EdgeInsets.all(5))
    ]))));
  }, future: null); }
}

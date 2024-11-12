import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/templogs/data/button_picked.dart';
import 'package:templog/src/features/templogs/services/templogs_service.dart';
import 'package:templog/src/theme/common_theme.dart';

class DownloadDataPage extends StatefulWidget {
  final Function changePage;
  final Widget previousPage;
  const DownloadDataPage({ required this.changePage, required this.previousPage, super.key });

  @override
  State<DownloadDataPage> createState() => _DownloadDataPageState();
}

class _DownloadDataPageState extends State<DownloadDataPage> {
  final ThemeData theme = CommonTheme.themeData;
  final TemplogsService templogsService = TemplogsService();

  DateTime? startDate;
  DateTime? endDate;
  DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  ButtonPicked buttonPicked = ButtonPicked.none;

  // Will become an error message if either the start/end date is empty and a custom date is being used, or if the start date is after the end date
  Widget customDateError = Container();
  // Will become an error message if no dates are selected (custom or otherwise) and a download is requested
  Widget mainPageError = Container();

  // Function called if using a Custom Date
  customDateProcess() async {
    // If both "startDate" and "endDate" is "null", set error and return
    if (startDate == null && endDate == null) {
      setState(() { mainPageError = Text("Please pick a time period to download", style: CommonTheme.getErrorTextStyle(context)); });
      return "error";
    }
    // If either "startDate" or "endDate" is null, but not both, set error and return
    if ((startDate == null && endDate != null) || (startDate != null && endDate == null)) {
      setState(() { customDateError = Text("Please pick a start and end date", style: CommonTheme.getErrorTextStyle(context)); });
      return "error";
    }
    // If the start date is after the end date, set error and return
    if (startDate!.isAfter(endDate!)) {
      setState(() { customDateError = Text("Start Date cannot be after End Date", style: CommonTheme.getErrorTextStyle(context)); });
      return "error";
    }
    // If the start date is more than 1 year before the end date, set error and return
    if (startDate!.isBefore(DateTime(endDate!.year - 1, endDate!.month, endDate!.day))) {
      setState(() { customDateError = Text("Start Date cannot be more than 1 Year before End Date", style: CommonTheme.getErrorTextStyle(context)); });
      return "error";
    }

    // Custom Date OK to use
    await templogsService.downloadData(context, startDate!, endDate!);
  }

  // Function called if using a preset Button
  buttonPickedProcess() async {
    // Depending on status of "buttonPicked", set "startDate" and "endDate"
    switch (buttonPicked) {
      // Last 30 Days
      case ButtonPicked.lastThirtyDays:
        endDate = DateTime.now();
        startDate = DateTime(endDate!.year, endDate!.month, endDate!.day - 30);
        break;
      // Last 90 Days
      case ButtonPicked.lastNinetyDays:
        endDate = DateTime.now();
        startDate = DateTime(endDate!.year, endDate!.month, endDate!.day - 90);
        break;
      // Last 6 Months
      case ButtonPicked.lastSixMonths:
        endDate = DateTime.now();
        startDate = DateTime(endDate!.year, endDate!.month - 6, endDate!.day);
        break;
      // Last 1 Year
      case ButtonPicked.lastYear:
        endDate = DateTime.now();
        startDate = DateTime(endDate!.year - 1, endDate!.month, endDate!.day);
        break;
      // Default (will never be used, so just breaks)
      default:
        break;
    }

    // Call the "TemplogsService.downloadData" function using the new "startDate" and "endDate"
    await templogsService.downloadData(context, startDate!, endDate!);
  }

  // Handles page submission
  handleButtonPress() async {
    // Reset errors
    customDateError = Container();
    mainPageError = Container();
    // Set the loading spinner
    MainPage.showLoader(context, true, "Downloading Document");

    String? response;

    // If no button option is selected, run the CustomDate process
    if (buttonPicked == ButtonPicked.none) { response = await customDateProcess(); }
    // Else, run "buttonPickedProcess"
    else { response = await buttonPickedProcess(); }

    // Hide the loading spinner
    MainPage.hideLoader(context);

    if (response != "error") {
      // Set a message that the file has downloaded
      setState(() { mainPageError = Text("Data downloaded", style: theme.textTheme.displaySmall); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Center(child: SafeArea(child: FractionallySizedBox(widthFactor: 0.85, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      // Back button and title text
      Row(children: <Widget>[
        GestureDetector(
          onTap: () => widget.changePage(widget.previousPage),
          child: Image(image: const AssetImage("lib/src/images/icons/misc/left-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Text("Download Data", style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.08, fontFamily: 'Open Sans', fontWeight: FontWeight.bold))
      ]),
      const Padding(padding: EdgeInsets.all(10)),

      // Splash text
      Text(
        '''
You can request a copy of your temperature logs at any time

When your file is ready, it will automatically be downloaded to your device
        ''',
        style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.031, fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
        overflow: TextOverflow.visible,
      ),
      const Padding(padding: EdgeInsets.all(10)),

      // Custom Time period entry
      Text("Select Time Period", style: CommonTheme.getMediumTextStyle(context)),
      const Padding(padding: EdgeInsets.all(5)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        // Start Date Picker
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text("Start Date", style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.04, fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
          const Padding(padding: EdgeInsets.all(5)),
          GestureDetector(
            onTap: () async {
              final DateTime? newDateTime = await showDatePicker(
                context: context,
                initialDate: startDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100)
              );
              if (newDateTime != null) { setState(() { startDate = newDateTime; buttonPicked = ButtonPicked.none; }); }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.39,
              child: Text(
                (startDate == null)
                  ? ""
                  : dateFormatter.format(startDate!),
                style: CommonTheme.getSmallTextStyle(context)
              )
            )
          )
        ]),

        // End Date Picker
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text("End Date", style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.04, fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
          const Padding(padding: EdgeInsets.all(5)),
          GestureDetector(
            onTap: () async {
              final DateTime? newDateTime = await showDatePicker(
                context: context,
                initialDate: endDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100)
              );
              if (newDateTime != null) { setState(() { endDate = newDateTime; buttonPicked = ButtonPicked.none; }); }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.39,
              child: Text(
                (endDate == null)
                  ? ""
                  : dateFormatter.format(endDate!),
                style: CommonTheme.getSmallTextStyle(context)
              )
            )
          )
        ])
      ]),
      const Padding(padding: EdgeInsets.all(3)),
      Center(child: customDateError),
      const Padding(padding: EdgeInsets.all(10)),

      // Pre-set periods
      Text("Or", style: CommonTheme.getMediumTextStyle(context)),
      const Padding(padding: EdgeInsets.all(5)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        // Last 30 Days
        GestureDetector(
          onTap: () {
            if (buttonPicked == ButtonPicked.lastThirtyDays) {
              setState(() => buttonPicked = ButtonPicked.none);
            } else {
              setState(() => buttonPicked = ButtonPicked.lastThirtyDays);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: (buttonPicked == ButtonPicked.lastThirtyDays)
              ? BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient)
              : BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.39,
            child: Text("Last 30 Days", style: CommonTheme.getSmallTextStyle(context))
          )
        ),

        // Last 6 Months
        GestureDetector(
          onTap: () {
            if (buttonPicked == ButtonPicked.lastSixMonths) {
              setState(() => buttonPicked = ButtonPicked.none);
            } else {
              setState(() => buttonPicked = ButtonPicked.lastSixMonths);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: (buttonPicked == ButtonPicked.lastSixMonths)
              ? BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient)
              : BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.39,
            child: Text("Last 6 Months", style: CommonTheme.getSmallTextStyle(context))
          )
        ),
      ]),
      const Padding(padding: EdgeInsets.all(10)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        // Last 90 Days
        GestureDetector(
          onTap: () {
            if (buttonPicked == ButtonPicked.lastNinetyDays) {
              setState(() => buttonPicked = ButtonPicked.none);
            } else {
              setState(() => buttonPicked = ButtonPicked.lastNinetyDays);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: (buttonPicked == ButtonPicked.lastNinetyDays)
              ? BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient)
              : BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.39,
            child: Text("Last 90 Days", style: CommonTheme.getSmallTextStyle(context))
          )
        ),

        // Last 6 Months
        GestureDetector(
          onTap: () {
            if (buttonPicked == ButtonPicked.lastYear) {
              setState(() => buttonPicked = ButtonPicked.none);
            } else {
              setState(() => buttonPicked = ButtonPicked.lastYear);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: (buttonPicked == ButtonPicked.lastYear)
              ? BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient)
              : BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.39,
            child: Text("Last 1 Year", style: CommonTheme.getSmallTextStyle(context))
          )
        ),
      ]),
      const Padding(padding: EdgeInsets.all(20)),

      // "Download" button
      GestureDetector(
        onTap:() => handleButtonPress(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
          height: MediaQuery.of(context).size.height * 0.08,
          child: Text("Download", style: CommonTheme.getLargeTextStyle(context))
        )
      ),
      const Padding(padding: EdgeInsets.all(3)),
      Center(child: mainPageError),
      const Padding(padding: EdgeInsets.all(10))
    ])))));
  }
}

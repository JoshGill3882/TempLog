import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/templogs/data/templog.dart';
import 'package:templog/src/features/templogs/repositories/templog_repository.dart';

class TemplogsService {
  TemplogRepository templogRepository = TemplogRepository();

  getNumOfTemplogs() async {
    IdTokenResult userCustomClaims = await DefaultFirebaseOptions.auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];
    DateTime now = DateTime.now();

    return await templogRepository.getNumOfTemplogs(businessCode, now);
  }

  Future<List<Templog>> getTemplogs(DateTime date) async {
    IdTokenResult userCustomClaims = await DefaultFirebaseOptions.auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];

    List<Templog> templogs = [];
    var templogsSnapshot = await templogRepository.getTemplogs(businessCode, date, MainPage.currentLocation.locationId);
    for (var templog in templogsSnapshot.docs) {
      var templogData = templog.data();
      templogs.add(
        Templog(
          id: templog.id,
          location: MainPage.currentLocation,
          deviceName: templogData["Device Name"],
          dateTime: DateTime.parse(templogData["Timestamp"].toDate().toString()),
          temperature: templogData["Temperature"],
          probeUsed: templogData["Probe Used"],
          signature: templogData["Signature"],
          comments: templogData["Comments"]
        )
      );
    }
  
    templogs.sort((a,b) { return a.dateTime.compareTo(b.dateTime); });
    return templogs;
  }

  setTemplog(Templog templog) async {
    IdTokenResult userCustomClaims = await DefaultFirebaseOptions.auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];

    if (templog.id.isEmpty) { // If the device ID is empty, we can assume it is a new device
      var templogRef = await templogRepository.addTempLog(businessCode, templog);
      templog.id = templogRef.id;

      await templogRepository.setTemplog(businessCode, templog);

      int currentMonthlyTemplogNumber = await getNumOfTemplogs();
      DateTime now = DateTime.now();
      await templogRepository.updateMonthlyTemplogNumber(businessCode, now, currentMonthlyTemplogNumber + 1);
      
    } else { // If the device ID is not empty, we can assume the user is editing an existing device
      await templogRepository.setTemplog(businessCode, templog);
    }
  }

  deleteTemplog(Templog templog) async {
    IdTokenResult userCustomClaims = await DefaultFirebaseOptions.auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];

    await templogRepository.deleteTemplog(businessCode, templog);
  }

  downloadData(BuildContext context, DateTime startDate, final DateTime endDate) async {
    // Calculate the number of days between the start and end dates
    final totalNumOfDays = (endDate.difference(startDate).inHours / 24).round() - 1;
    // Set a "currentDate" flag as equal to "startDate"
    DateTime currentDate = startDate;
    // Define a DateFormatter for the date
    DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    // Define the empty map
    List<List<String>> templogs = [["Date", "Device", "Temperature", "Time", "Signature"]];

    // Get the "currentDate"'s templogs, add them to the list, and iterate "currentDate" by a day, while "startDate" is not after "endDate"
    do {
      int currentDayNumber = totalNumOfDays - (endDate.difference(currentDate).inHours / 24).round();
      String newLoaderProgress = "Downloading data for day ${currentDayNumber.toString()}/${totalNumOfDays.toString()}";
      MainPage.updateLoaderProgress(context, newLoaderProgress);

      List<Templog> currentDateTemplogs = await getTemplogs(currentDate);
      for (Templog templog in currentDateTemplogs) {
        templogs.add([
          dateFormatter.format(templog.dateTime),
          templog.deviceName,
          "${templog.temperature}°C",
          DateFormat.jms().format(templog.dateTime),
          templog.signature
        ]);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    } while (!currentDate.isAfter(endDate));

    // Update Loader Context
    MainPage.updateLoaderProgress(context, "Building File");
    // Format PDF file
    final pdf = pw.Document();
    pdf.addPage(
      // "pw.MultiPage" will automatically add multiple pages to the document if necessary
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.openSansRegular(),
            bold: await PdfGoogleFonts.openSansBold()
          )
        ),
        // If on first page show no header, otherwise, show header
        header: (context) { if (context.pageNumber == 1) { return pw.SizedBox(); } return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
          child: pw.Text('Temperature Log: ${dateFormatter.format(startDate)} - ${dateFormatter.format(endDate)}', style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey))
        ); },
        // Footer containing page number
        footer: (context) { return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey))
        ); },
        build: (context) { return [
          // Header and dates text
          pw.Text("Temperature Log", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
          pw.Text("Provided by Templog LTD", style: const pw.TextStyle(fontSize: 14)),
          pw.Text("Dates: ${dateFormatter.format(startDate)} - ${dateFormatter.format(endDate)}", style: const pw.TextStyle(fontSize: 14)),
          pw.Padding(padding: const pw.EdgeInsets.all(5)),

          // Table generated from "TableHelper", or a text if there are no templogs to be shown
          (templogs.length > 1)
            ? pw.TableHelper.fromTextArray(context: context, data: templogs)
            : pw.Text("No Templogs Found for given dates", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18))
        ]; }
      )
    );

    // Download file
    // Update loader
    MainPage.updateLoaderProgress(context, "Downloading File");
    // Save the file
    final savedFile = await pdf.save();
    // Get application documents directory
    final directory = await getTemporaryDirectory();
    // Get the file and it's path
    final file = File("${directory.path}/Templogs.pdf");
    // Write the file
    await file.writeAsBytes(savedFile);

    MainPage.updateLoaderProgress(context, null);

    await OpenFile.open(file.path);
  }
}

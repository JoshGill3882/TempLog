import 'package:flutter/material.dart';
import 'package:templog/src/features/locations/pages/locations_list_page.dart';
import 'package:templog/src/features/locations/widgets/location_entry_form.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class AddLocation extends StatelessWidget {
  final Function changePage;
  final bool showBackButton;
  final ThemeData theme = CommonTheme.themeData;
  AddLocation({ required this.changePage, required this.showBackButton, super.key });

  @override
  Widget build(BuildContext context) {
    MainPage.hideLoader(context);
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        (showBackButton)
        ? GestureDetector(
          onTap: () => changePage(LocationsListPage(changePage: changePage)),
          child: Image(image: const AssetImage("lib/src/images/icons/misc/left-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
        )
        : SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        Text("New Location", style: CommonTheme.getLargeTextStyle(context)),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1)
      ]),
      const Padding(padding: EdgeInsets.all(10)),

      LocationEntryForm(location: null, changePage: changePage),
      const Padding(padding: EdgeInsets.all(10)),
    ])))));
  }
}

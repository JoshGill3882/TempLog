import 'package:flutter/material.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/locations/pages/locations_list_page.dart';
import 'package:templog/src/features/locations/services/location_service.dart';
import 'package:templog/src/features/locations/widgets/location_entry_form.dart';
import 'package:templog/src/theme/common_theme.dart';

class LocationDetailsPage extends StatelessWidget {
  final Location location;
  final Function changePage;
  final ThemeData theme = CommonTheme.themeData;
  final LocationService locationService = LocationService();
  LocationDetailsPage({ required this.location, required this.changePage, super.key });

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        GestureDetector(
          onTap: () => changePage(LocationsListPage(changePage: changePage)),
          child: Image(image: const AssetImage("lib/src/images/icons/misc/left-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
        ),
        Text("Location", style: CommonTheme.getLargeTextStyle(context)),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1)
      ]),
      const Padding(padding: EdgeInsets.all(15)),

      LocationEntryForm(location: location, changePage: changePage),
      const Padding(padding: EdgeInsets.all(10))
    ])))));
  }
}

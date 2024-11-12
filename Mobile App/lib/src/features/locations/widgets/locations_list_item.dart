import 'package:flutter/material.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/locations/pages/location_details_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class LocationsListItem extends StatelessWidget {
  final Function changePage;
  final Location location;
  final ThemeData theme = CommonTheme.themeData;
  LocationsListItem({ required this.changePage, required this.location, super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
      height: MediaQuery.of(context).size.height * 0.09,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          alignment: Alignment.center,
          height: constraints.maxHeight - 10,
          width: constraints.maxWidth - 40,
          child: GestureDetector(
            onTap: () => changePage(LocationDetailsPage(location: location, changePage: changePage)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Text(location.locationName, style: CommonTheme.getMediumTextStyle(context)),
              Image(image: const AssetImage("lib/src/images/icons/misc/right-arrow.png"), height: MediaQuery.of(context).size.width * 0.1)
            ])
          )
        );
      })
    );
  }
}

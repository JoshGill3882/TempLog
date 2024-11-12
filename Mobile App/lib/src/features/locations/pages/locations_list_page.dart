import 'package:flutter/material.dart';
import 'package:templog/src/features/home/pages/home_page.dart';
import 'package:templog/src/features/locations/pages/add_location.dart';
import 'package:templog/src/features/locations/widgets/locations_list_item.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class LocationsListPage extends StatelessWidget {
  final Function changePage;
  final ThemeData theme = CommonTheme.themeData;
  LocationsListPage({ required this.changePage, super.key });

  getLocationsList() {
    List<LocationsListItem> locationsListItems = [];
    for (int x = 0; x < MainPage.locations.length - 1; x++) { locationsListItems.add(LocationsListItem(changePage: changePage, location: MainPage.locations[x])); }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: locationsListItems.length,
      separatorBuilder: (BuildContext context, int index) => const Padding(padding: EdgeInsets.all(10)),
      itemBuilder: (BuildContext context, int index) => locationsListItems[index],
    );
  }

  addLocationButton(BuildContext context) {
    if (MainPage.locations.length < MainPage.currentRestrictions.maxLocations) {
      changePage(AddLocation(changePage: changePage, showBackButton: true));
      return;
    } else {
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        backgroundColor: CommonTheme.deepPurpleColor,
        content: SingleChildScrollView(child: Column(children: [
          Text("Maximum Number of Locations reached", style: CommonTheme.getSmallTextStyle(context)),
          const Padding(padding: EdgeInsets.all(7)),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(gradient: CommonTheme.buttonGradient, borderRadius: BorderRadius.circular(35)),
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.8,
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: CommonTheme.deepPurpleColor, borderRadius: BorderRadius.circular(35)),
                  height: constraints.maxHeight - 7,
                  width: constraints.maxWidth - 7,
                  child: Text("Close", style: CommonTheme.getMediumTextStyle(context))
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
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(children: <Widget>[
      const Padding(padding: EdgeInsets.all(5)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        GestureDetector(
          onTap: () => changePage(HomePage(changePage: changePage)),
          child: Image(image: const AssetImage("lib/src/images/icons/misc/left-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
        ),
        Text("Locations", style: CommonTheme.getLargeTextStyle(context)),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1)
      ]),
      const Padding(padding: EdgeInsets.all(15)),

      getLocationsList(),
      const Padding(padding: EdgeInsets.all(15)),

      GestureDetector(
        onTap: () => addLocationButton(context),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
          height: MediaQuery.of(context).size.height * 0.085,
          child: Text("Add Location", style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.06, fontFamily: 'Open Sans', fontWeight: FontWeight.bold))
        )
      ),
      const Padding(padding: EdgeInsets.all(10))
    ])))));
  }
}

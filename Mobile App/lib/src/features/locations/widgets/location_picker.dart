import 'package:flutter/material.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';

// ignore: must_be_immutable
class LocationPicker extends StatefulWidget {
  final Function(Location) notifyParent;

  const LocationPicker({ Key? key, required this.notifyParent }): super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker>{
  ThemeData theme = CommonTheme.themeData;

  setCurrentLocation(String newLocationName) {
    for (var element in MainPage.locations) { if (element.locationName == newLocationName) { widget.notifyParent(element); } }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: CommonTheme.medPurpleColor),
      height: MediaQuery.of(context).size.height * 0.07,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth - 40,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Text("Location", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),

            DropdownButton<String>(
              alignment: Alignment.centerRight,
              value: MainPage.currentLocation.locationName,
              icon: Image(image: const AssetImage("lib/src/images/icons/templogs/logbook/down-arrow.png"), height: MediaQuery.of(context).size.width * 0.05, width: MediaQuery.of(context).size.width * 0.05),
              style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.045, fontWeight: FontWeight.bold),
              dropdownColor: CommonTheme.medPurpleColor,
              underline: Container(), // Empty container so no underline shows
              onChanged: (value) => setCurrentLocation(value!),
              items: MainPage.locations.map<DropdownMenuItem<String>>((Location value) {
                return DropdownMenuItem<String>(value: value.locationName, alignment: Alignment.centerRight, child: Text(value.locationName));
              }).toList()
            )
          ])
        );
      } )
    );
  }
}

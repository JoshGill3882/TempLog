import 'package:flutter/material.dart';
import 'package:templog/src/features/home/pages/home_page.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/locations/services/location_service.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/validators.dart';

// ignore: must_be_immutable
class LocationEntryForm extends StatefulWidget {
  Location? location;
  final Function changePage;
  LocationEntryForm({ this.location, required this.changePage, super.key });

  @override
  State<StatefulWidget> createState() => _LocationEntryFormState();
}

class _LocationEntryFormState extends State<LocationEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final ThemeData theme = CommonTheme.themeData;
  final LocationService locationService = LocationService();

  String? locationName;
  String? locationAddress;
  String? locationCity;
  String? locationPostCode;

  bool locationNameNull = false;
  bool locationNameTooLong = false;
  bool locationAddressError = false;

  getLocationNameError() {
    if (locationNameNull) {
      return Text("Please enter a location name", style: CommonTheme.getErrorTextStyle(context));
    } else if (locationNameTooLong) {
      return Text("Location Name is too long", style: CommonTheme.getErrorTextStyle(context));
    } else {
      return const Padding(padding: EdgeInsets.all(0));
    }
  }

  getLocationAddressError() {
    return (locationAddressError)
        ? Text("Please enter a valid address", style: CommonTheme.getErrorTextStyle(context))
        : const Padding(padding: EdgeInsets.all(0));
  }

  handleButtonPress(BuildContext context) async {
    locationNameNull = false;
    locationNameTooLong = false;
    locationAddressError = false;
    if (_formKey.currentState!.validate()) {
      MainPage.showLoader(context, false, "");
      _formKey.currentState!.save();

      widget.location = Location(
        (widget.location != null) ? widget.location!.locationId : "",
        locationName!,
        locationAddress!,
        locationCity!,
        locationPostCode!,
        (widget.location != null) ? widget.location!.devices : []
      );

      await locationService.setLocation(widget.location!);
      MainPage.hideLoader(context);
      widget.changePage(HomePage(changePage: widget.changePage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        // Location Name entry
        Center(child: Text("Location Name", style: CommonTheme.getMediumTextStyle(context))),
        const Padding(padding: EdgeInsets.all(5)),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
          height: MediaQuery.of(context).size.height * 0.07,
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              alignment: Alignment.center,
              height: constraints.maxHeight - 10,
              width: constraints.maxWidth - 40,
              child: TextFormField(
                cursorColor: CommonTheme.whiteColor,
                decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                style: CommonTheme.getSmallTextStyle(context),
                onSaved:(newValue) => locationName = newValue,
                validator: (value) {
                  if (Validators.isNull(value) || Validators.isBlank(value)) {
                    setState(() => locationNameNull = true);
                    return "Name Error";
                  } else if (value!.length > 16) {
                    setState(() => locationNameTooLong = true);
                    return "Name Error";
                  }
                  return null;
                },
                initialValue: (widget.location == null) ? "" : widget.location!.locationName,
              )
            );
          })
        ),
        const Padding(padding: EdgeInsets.all(3)),
        Center(child: getLocationNameError()),
        const Padding(padding: EdgeInsets.all(10)),

        Center(child: Text("Location Address", style: CommonTheme.getMediumTextStyle(context))),
        const Padding(padding: EdgeInsets.all(5)),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), color: CommonTheme.medPurpleColor),
          height: MediaQuery.of(context).size.height * 0.39,
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight - 40,
              width: constraints.maxWidth - 40,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                // Address Input
                Text("Address", style: CommonTheme.getMediumTextStyle(context)),
                TextFormField(
                  cursorColor: CommonTheme.whiteColor,
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, errorStyle: TextStyle(fontSize: 0)),
                  style: CommonTheme.getSmallTextStyle(context),
                  onSaved:(newValue) => locationAddress = newValue,
                  validator: (value) {
                    if (Validators.isNull(value) || Validators.isBlank(value)) { setState(() => locationAddressError = true); return "Address Error"; }
                    return null;
                  },
                  initialValue: (widget.location == null) ? "" : widget.location!.locationAddress,
                ),

                const Padding(padding: EdgeInsets.all(5)),
                Container(height: 1, color: CommonTheme.whiteColor),
                const Padding(padding: EdgeInsets.all(5)),

                // City input
                Text("City", style: CommonTheme.getMediumTextStyle(context)),
                TextFormField(
                  cursorColor: CommonTheme.whiteColor,
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, errorStyle: TextStyle(fontSize: 0)),
                  style: CommonTheme.getSmallTextStyle(context),
                  onSaved:(newValue) => locationCity = newValue,
                  validator: (value) {
                    if (Validators.isNull(value) || Validators.isBlank(value)) { setState(() => locationAddressError = true); return "City Error"; }
                    return null;
                  },
                  initialValue: (widget.location == null) ? "" : widget.location!.locationCity,
                ),

                const Padding(padding: EdgeInsets.all(5)),
                Container(height: 1, color: CommonTheme.whiteColor),
                const Padding(padding: EdgeInsets.all(5)),

                // Post Code entry
                Text("Post Code", style: CommonTheme.getMediumTextStyle(context)),
                TextFormField(
                  cursorColor: CommonTheme.whiteColor,
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, errorStyle: TextStyle(fontSize: 0)),
                  style: CommonTheme.getSmallTextStyle(context),
                  onSaved:(newValue) {
                    newValue = newValue!.replaceAll(" ", "");
                    locationPostCode = newValue;
                  },
                  validator: (value) {
                    value = value!.replaceAll(" ", "");
                    if (Validators.isNull(value) || Validators.isBlank(value) || !Validators.isPostCode(value)) { setState(() => locationAddressError = true); return "Post Code Error"; }
                    return null;
                  },
                  initialValue: (widget.location == null) ? "" : widget.location!.locationPostCode,
                )
              ])
            );
          })
        ),
        const Padding(padding: EdgeInsets.all(3)),
        Center(child: getLocationAddressError()),
        const Padding(padding: EdgeInsets.all(15)),

        GestureDetector(
          onTap: () => handleButtonPress(context),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), gradient: CommonTheme.buttonGradient),
            height: MediaQuery.of(context).size.height * 0.08,
            child: Text("Save", style: CommonTheme.getLargeTextStyle(context))
          )
        )
      ])
    );
  }
}

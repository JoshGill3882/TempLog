import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/devices/pages/devices_page.dart';
import 'package:templog/src/features/devices/services/device_service.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/locations/pages/add_location.dart';
import 'package:templog/src/features/locations/pages/locations_list_page.dart';
import 'package:templog/src/features/locations/services/location_service.dart';
import 'package:templog/src/features/locations/widgets/location_picker.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/subscriptions/data/restrictions.dart';
import 'package:templog/src/features/subscriptions/data/subscription_info.dart';
import 'package:templog/src/features/subscriptions/pages/upgrade_page.dart';
import 'package:templog/src/features/subscriptions/repositories/subscriptions_repository.dart';
import 'package:templog/src/features/subscriptions/services/subscriptions_service.dart';
import 'package:templog/src/features/templogs/pages/add_log_page.dart';
import 'package:templog/src/features/templogs/services/templogs_service.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/services/shared_preference_service.dart';
import 'package:templog/src/util/services/util_service.dart';
import 'package:templog/src/util/widgets/initials_button.dart';

class HomePage extends StatefulWidget {
  final Function changePage;
  const HomePage({ super.key, required this.changePage });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final theme = CommonTheme.themeData;
  final deviceService = DeviceService();
  final subscriptionsService = SubscriptionsService();
  final subscriptionsRepo = SubscriptionsRepository();
  final templogsService = TemplogsService();
  final utilService = UtilService();

  bool manager = false;

  @override
  void initState() {
    super.initState();
    getHomePage();
  }

  refreshCurrentLocation(Location newLocation) {
    if (newLocation.locationName == "Edit Locations") { widget.changePage(LocationsListPage(changePage: widget.changePage)); return; }

    setState(() {  // Crashes due to not being "mounted" if page changed too quickly
      MainPage.currentLocation = newLocation;
      SharedPreferenceService().setStringPreference("currentLocationName", newLocation.locationName);
    });
    MainPage.hideLoader(context);
  }

  getHomePage() async {
    MainPage.showLoader(context, false, "");
    IdTokenResult userCustomClaims = await DefaultFirebaseOptions.auth.currentUser!.getIdTokenResult(true);

    String businessCode = userCustomClaims.claims!["businessCode"];
    SubscriptionInfo currentSubscriptionInfo = await subscriptionsService.getCurrentSubscriptionInfo(businessCode);
    switch (currentSubscriptionInfo.tier) {
      case "Free":
        setState(() => MainPage.currentRestrictions = Restrictions.freeTierRestrictions());
        break;
      case "Plus":
        setState(() => MainPage.currentRestrictions = Restrictions.plusTierRestrictions());
        break;
    }

    // If the customerId is null, assume new Manager, create RevenueCat Customer ID
    if (currentSubscriptionInfo.customerId == "") {
      String randomString = utilService.getRandomString();
      String newCustomerId = "$businessCode-$randomString";
      currentSubscriptionInfo.customerId = newCustomerId;
      await subscriptionsRepo.updateSubscriptionInfo(businessCode, newCustomerId, currentSubscriptionInfo.subscriptionId, currentSubscriptionInfo.tier);
    }

    // Configure RevenueCat with current customer details
    switch (MainPage.currentPlatform) {
      case TargetPlatform.android:
        await Purchases.configure(
          PurchasesConfiguration("goog_zClfGwDIVMePEYQYLYgwnbsxNKu")
            ..appUserID = currentSubscriptionInfo.customerId
        );
        break;
      case TargetPlatform.iOS:
        await Purchases.configure(
          PurchasesConfiguration("appl_cZqelluqJTtinogTkqZcwpAAppz")
            ..appUserID = currentSubscriptionInfo.customerId
        );
        break;
      default:
        break;
    }

    // Get customer info, and if there are no active entitlements but the customer is not on the Free Tier set the customer to the free tier
    // Designed for use if a customer cancels a subscription manually but does not update their subscription on the app
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    if (currentSubscriptionInfo.tier != "Free" && customerInfo.entitlements.active.isEmpty) {
      await subscriptionsRepo.updateSubscriptionInfo(businessCode, currentSubscriptionInfo.customerId, "", "Free");
      setState(() => MainPage.currentRestrictions = Restrictions.freeTierRestrictions());
    }

    MainPage.locations = await LocationService().getLocations();
    final sharedPrefLocationName = await SharedPreferenceService().getStringPreference("currentLocationName");

    setState(() => manager = userCustomClaims.claims!["admin"]);
    if (manager) {
      if (MainPage.locations.isEmpty) { widget.changePage(AddLocation(changePage: widget.changePage, showBackButton: false)); return; }
      MainPage.locations.add(Location("", "Edit Locations", "", "", "", []));
    }

    for (var element in MainPage.locations) {
      if (element.locationName == sharedPrefLocationName) { refreshCurrentLocation(element); return; }
    }

    refreshCurrentLocation(MainPage.locations[0]);
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
          Text("Maximum Number of Templogs reached this month", style: CommonTheme.getSmallTextStyle(context)),
          const Padding(padding: EdgeInsets.all(7)),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(gradient: CommonTheme.buttonGradient, borderRadius: BorderRadius.circular(35)),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.7,
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
    return FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      return SingleChildScrollView(child: Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: Column(children: <Widget>[
        const Padding(padding: EdgeInsets.all(5)),
        // Row for Name and Notification Button
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          InitialsButton(changePage: widget.changePage),
          Image(image: const AssetImage("lib/src/images/logo_full.png"), width: MediaQuery.of(context).size.width * 0.4),
          SizedBox(width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1) // Sized box to maintain even spacing while the notifications feature is not implemented
          // GestureDetector(
          //   onTap: () => {},
          //   child: Image(image: const AssetImage("lib/src/images/icons/home/notification.png"), width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1)
          // )
        ]),
        const Padding(padding: EdgeInsets.all(10)),

        // Location Picker
        LocationPicker(notifyParent: refreshCurrentLocation),
        const Padding(padding: EdgeInsets.all(10)),

        // New Log Button
        GestureDetector(
          onTap:() => addLogButton(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: CommonTheme.buttonGradient
            ),
            height: MediaQuery.of(context).size.height * 0.15,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,  crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Text("New Log", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.09, fontWeight: FontWeight.bold, height: 0.1)),
              const Padding(padding: EdgeInsets.all(15)),
              Image(image: const AssetImage("lib/src/images/icons/misc/plus.png"), width: MediaQuery.of(context).size.width * 0.15),
            ])
          )
        ),
        const Padding(padding: EdgeInsets.all(10)),

        ((MainPage.currentRestrictions.currentTier == "Free") && (manager))
          ? Column(children: <Widget>[
            GestureDetector(
              onTap: () => widget.changePage(UpgradePage(changePage: widget.changePage, previousPage: HomePage(changePage: widget.changePage))),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
                width: MediaQuery.of(context).size.width * 0.9,
                child: FractionallySizedBox(widthFactor: 0.93, child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  const Padding(padding: EdgeInsets.all(10)),

                  Text("Upgrade", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold, color: CommonTheme.whiteColor)),
                  const Padding(padding: EdgeInsets.all(3)),
                  Text(
                    "Need more locations, logs, & devices? We've got your business covered for £5.99 per month.",
                    style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.028, color: CommonTheme.whiteColor)
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.lightMidPurpleColor),
                      height: MediaQuery.of(context).size.height * 0.04, width: MediaQuery.of(context).size.width * 0.2,
                      child: Text("Upgrade", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.03, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold))
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.whiteColor),
                      height: MediaQuery.of(context).size.width * 0.08, width: MediaQuery.of(context).size.width * 0.08,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(90), color: CommonTheme.medPurpleColor),
                        height: MediaQuery.of(context).size.width * 0.08 - 3,
                        width: MediaQuery.of(context).size.width * 0.08 - 3,
                        child: Image(image: const AssetImage("lib/src/images/icons/home/up_arrow.png"), width: MediaQuery.of(context).size.width * 0.07)
                      )
                    )
                  ]),
                  const Padding(padding: EdgeInsets.all(10)),
                ]))
              )
            ),
            const Padding(padding: EdgeInsets.all(10)),
          ])
          : Container(),

        // Devices Section
        // Title and See All
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Text("Devices", style: CommonTheme.getMediumTextStyle(context)),
          GestureDetector(
            onTap:() { widget.changePage(DevicesPage(changePage: widget.changePage)); },
            child: Row(children: <Widget>[
              Text("See All", style: TextStyle(color: CommonTheme.lightPurpleColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.035, fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_right, color: CommonTheme.lightPurpleColor, size: 34)
            ])
          )
        ]),
        const Padding(padding: EdgeInsets.all(10)),

        // Buttons
        deviceService.getDeviceButtons(MainPage.currentLocation, widget.changePage, context),
        const Padding(padding: EdgeInsets.all(5))
      ])))));
    }, future: null);
  }
}

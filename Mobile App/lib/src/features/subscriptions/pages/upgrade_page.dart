import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/subscriptions/data/upgrade_page_states.dart';
import 'package:templog/src/features/subscriptions/services/subscriptions_service.dart';
import 'package:templog/src/features/subscriptions/widgets/benefit_display.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/widgets/coming_soon_alert.dart';

class UpgradePage extends StatefulWidget {
  final Function changePage;
  final Widget previousPage;
  const UpgradePage({ required this.changePage, required this.previousPage, super.key });

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final theme = CommonTheme.themeData;

  UpgradePageStates currentPage = UpgradePageStates.FREE;
  final subscriptionsService = SubscriptionsService();


  getBenefitsBox(BuildContext context) {
    Widget benefitsBox;

    switch (currentPage) {
      case UpgradePageStates.FREE:
        benefitsBox = Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: CommonTheme.medPurpleColor, borderRadius: BorderRadius.circular(35)),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Padding(padding: EdgeInsets.all(7)),

            // Text above the line
            FractionallySizedBox(widthFactor: 0.93, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text("Templog Free", style: CommonTheme.getMediumTextStyle(context)),
              Row(children: <Widget>[
                Text("£0", style: TextStyle(fontFamily: "Open Sans", color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold)),
                Text(" / free", style: TextStyle(fontFamily: "Open Sans", color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.04))
              ]),
              Text("Start logging temperatures with Templog free and make the switch from physical to online logs.", style: TextStyle(fontFamily: "Open Sans", color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.035), overflow: TextOverflow.visible)
            ])),

            // The separating line
            const Padding(padding: EdgeInsets.all(3)),
            Container(decoration: const BoxDecoration(color: CommonTheme.whiteColor), height: 1),
            const Padding(padding: EdgeInsets.all(3)),

            // Benefits
            FractionallySizedBox(widthFactor: 0.93, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text("Includes:", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "1 Location"),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "3 Devices"),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "100 Logs/Month")
            ])),

            const Padding(padding: EdgeInsets.all(10)),
          ])
        );
        break;
      case UpgradePageStates.PLUS:
        benefitsBox = Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: CommonTheme.medPurpleColor, borderRadius: BorderRadius.circular(35)),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            const Padding(padding: EdgeInsets.all(7)),

            FractionallySizedBox(widthFactor: 0.93, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text("Templog Plus", style: CommonTheme.getMediumTextStyle(context)),
              Row(children: <Widget>[
                Text("£5.99", style: TextStyle(fontFamily: "Open Sans", color: const Color(0xff5ADFE6), fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold)),
                Text(" / month, renews monthly", style: TextStyle(fontFamily: "Open Sans", color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.04))
              ]),
              Text("Give your business the tools it needs to succeed with Templog Pro.", style: TextStyle(fontFamily: "Open Sans", color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.035), overflow: TextOverflow.visible)
            ])),

            // The separating line
            const Padding(padding: EdgeInsets.all(3)),
            Container(decoration: const BoxDecoration(color: CommonTheme.whiteColor), height: 1),
            const Padding(padding: EdgeInsets.all(3)),

            // Benefits
            FractionallySizedBox(widthFactor: 0.93, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text("Includes:", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "5 Locations"),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "50 Devices"),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "5000 Logs/Month"),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "Download reports")
              // const Padding(padding: EdgeInsets.all(5)),
              // BenefitDisplay(text: "Notifications")
            ])),

            const Padding(padding: EdgeInsets.all(10)),
          ])
        );
        break;
      case UpgradePageStates.ENTERPRISE:
        benefitsBox = Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: CommonTheme.medPurpleColor, borderRadius: BorderRadius.circular(35)),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            const Padding(padding: EdgeInsets.all(7)),

            // Text above the line
            FractionallySizedBox(widthFactor: 0.93, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text("Templog Enterprise", style: CommonTheme.getMediumTextStyle(context)),
              Row(children: <Widget>[
                Text("Custom", style: TextStyle(fontFamily: "Open Sans", color: const Color(0xffE6AE5A), fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold)),
                Text(" / month, renews monthly", style: TextStyle(fontFamily: "Open Sans", color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.04))
              ]),
              Text("Built for large teams, contact us to find out more!", style: TextStyle(fontFamily: "Open Sans", color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.035), overflow: TextOverflow.visible)
            ])),

            // The separating line
            const Padding(padding: EdgeInsets.all(3)),
            Container(decoration: const BoxDecoration(color: CommonTheme.whiteColor), height: 1),
            const Padding(padding: EdgeInsets.all(3)),

            // Benefits
            FractionallySizedBox(widthFactor: 0.93, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text("Includes:", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045, color: CommonTheme.whiteColor, fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "Custom number of locations"),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "Unlimited Devices"),
              const Padding(padding: EdgeInsets.all(5)),
              BenefitDisplay(text: "Unlimited Logs")
            ])),

            const Padding(padding: EdgeInsets.all(10))
          ])
        );
        break;
    }

    return benefitsBox;
  }

  handleFreePageButtonPress() async {
    MainPage.showLoader(context, true, "Updating Subscription");
    MainPage.updateLoaderProgress(context, "Updating Subscription");

    await subscriptionsService.setFreeTier();

    await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: CommonTheme.deepPurpleColor,
        content: SingleChildScrollView(child: Column(children: <Widget>[
          Text("Hey, sorry to see you go. Unfortunately, Templog cannot cancel a client's subscription on their behalf. But don't worry you can easily cancel your subscription on the app store.", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.04)),
          const Padding(padding: EdgeInsets.all(10)),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Text("Close", style: CommonTheme.getMediumTextStyle(context))
            )
          )
        ]))
      );
    });

    setState(() {});

    MainPage.hideLoader(context);
  }

  handlePlusPageButtonPress() async {
    final offerings = await Purchases.getOfferings();
    final paywallResult = await RevenueCatUI.presentPaywall(offering: offerings.getOffering("default"), displayCloseButton: true);

    if (paywallResult.name == "cancelled" || paywallResult.name == "error") { setState(() {}); return; }

    MainPage.showLoader(context, true, "Updating Subscription");
    MainPage.updateLoaderProgress(context, "Updating Subscription");

    await subscriptionsService.setPlusTier();

    setState(() {});

    MainPage.hideLoader(context);
  }

  handleEnterprisePageButtonPress() {
    showDialog(context: context, builder: (BuildContext context) => const ComingSoonAlert());
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      // Back Button and Page Title
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        GestureDetector(
            onTap: () => widget.changePage(widget.previousPage),
            child: Image(image: const AssetImage("lib/src/images/icons/misc/left-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
        ),
        Text("Upgrade", style: CommonTheme.getLargeTextStyle(context)),
        SizedBox(width: MediaQuery.of(context).size.width * 0.3)
      ]),
      const Padding(padding: EdgeInsets.all(7)),

      // Change Page buttons
      Row(children: <Widget>[
        // Free Button
        GestureDetector(
          onTap: () => { setState(() { currentPage = UpgradePageStates.FREE; }) },
          child: Container(
            alignment: Alignment.center,
            decoration: (currentPage == UpgradePageStates.FREE)
              ? BoxDecoration(borderRadius: BorderRadius.circular(12), color: CommonTheme.whiteColor)
              : null,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text("Free", style: TextStyle(
              color: (currentPage == UpgradePageStates.FREE)
                ? CommonTheme.deepPurpleColor
                : CommonTheme.whiteColor,
              fontFamily: "Open Sans",
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold
            ))
          )
        ),

        // Pro Button
        GestureDetector(
          onTap: () => { setState(() { currentPage = UpgradePageStates.PLUS; }) },
          child: Container(
            alignment: Alignment.center,
            decoration: (currentPage == UpgradePageStates.PLUS)
              ? BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xff5ADFE6))
              : null,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text("Plus", style: TextStyle(
              color: (currentPage == UpgradePageStates.PLUS)
                ? CommonTheme.deepPurpleColor
                : CommonTheme.whiteColor,
              fontFamily: "Open Sans",
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold
            ))
          )
        ),

        // Enterprise Button - Not Yet Implemented
        GestureDetector(
          onTap: () => { setState(() { currentPage = UpgradePageStates.ENTERPRISE; }) },
          child: Container(
            alignment: Alignment.center,
            decoration: (currentPage == UpgradePageStates.ENTERPRISE)
              ? BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xffE6AE5A))
              : null,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text("Enterprise", style: TextStyle(
              color: (currentPage == UpgradePageStates.ENTERPRISE)
                ? CommonTheme.deepPurpleColor
                : CommonTheme.whiteColor,
              fontFamily: "Open Sans",
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold
            ))
          )
        ),
      ]),
      const Padding(padding: EdgeInsets.all(7)),

      getBenefitsBox(context),
      const Padding(padding: EdgeInsets.all(10)),

      // Enterprise page text
      (currentPage == UpgradePageStates.ENTERPRISE)
        ? Column(children: <Widget>[
          Text(
            "If you have an Enterprise agreement setup with us already, please press continue and enter the code provided by your corporation. You will then be subscribed and have all the benefits of our enterprise tier.",
            style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.027, color: CommonTheme.whiteColor, overflow: TextOverflow.visible)
          ),
          const Padding(padding: EdgeInsets.all(10))
        ])
        : Container(),

      // Continue Button
      (currentPage.name == MainPage.currentRestrictions.currentTier.toUpperCase())
        ? Container()
        : Column(children: <Widget>[
          GestureDetector(
            onTap: () { switch (currentPage) {
              case (UpgradePageStates.FREE):
                handleFreePageButtonPress();
                break;
              case (UpgradePageStates.PLUS):
                handlePlusPageButtonPress();
                break;
              case (UpgradePageStates.ENTERPRISE):
                handleEnterprisePageButtonPress();
                break;
            } },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: (currentPage == UpgradePageStates.FREE)
                  ? const Color(0xffFFFFFF)
                  : (currentPage == UpgradePageStates.PLUS)
                    ? const Color(0xff5ADFE6)
                    : const Color(0xffE6AE5A)
              ),
              height: MediaQuery.of(context).size.height * 0.07,
              child: Text("Continue", style: TextStyle(fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.05, color: CommonTheme.deepPurpleColor, fontWeight: FontWeight.w600))
            )
          ),
          const Padding(padding: EdgeInsets.all(5))
        ])
    ])))));
  }
}

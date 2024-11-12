import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/sign_out/services/sign_out_service.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/profile/pages/company_details_page.dart';
import 'package:templog/src/features/profile/pages/edit_profile_page.dart';
import 'package:templog/src/features/profile/services/profile_service.dart';
import 'package:templog/src/features/profile/widgets/profile_page_option.dart';
import 'package:templog/src/features/subscriptions/pages/upgrade_page.dart';
import 'package:templog/src/features/templogs/pages/download_data_page.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/widgets/confirm_current_password_dialogue.dart';
import 'package:templog/src/util/widgets/initials_button.dart';

class ProfilePage extends StatefulWidget {
  final Function changePage;
  const ProfilePage({ required this.changePage, super.key });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final theme = CommonTheme.themeData;
  final profileService = ProfileService();
  String businessCode = "";
  bool adminFlag = false;
  String displayName = DefaultFirebaseOptions.auth.currentUser!.displayName!;

  @override
  void initState() {
    super.initState();
    getParams();
  }

  getParams() async {
    IdTokenResult userCustomClaims = await DefaultFirebaseOptions.auth.currentUser!.getIdTokenResult(true);
    setState(() {
      businessCode = userCustomClaims.claims!["businessCode"];
      adminFlag = userCustomClaims.claims!["admin"];
    });
  }

  downloadDocument(String documentName) async {
    MainPage.showLoader(context, true, "Downloading Document");
    MainPage.updateLoaderProgress(context, "Getting File");
    final docStorageRef = DefaultFirebaseOptions.storage.refFromURL("gs://templog-986cd.appspot.com/$documentName");

    final tempDir = await getTemporaryDirectory();
    final filePath = "${tempDir.path}/$documentName";
    final file = File(filePath);

    final downloadTask = docStorageRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.running:
          MainPage.updateLoaderProgress(context, "Downloading File");
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          MainPage.updateLoaderProgress(context, "File Downloaded");
          MainPage.hideLoader(context);
          await OpenFile.open(file.path);
          break;
        case TaskState.canceled:
          MainPage.updateLoaderProgress(context, "Download Cancelled");
          MainPage.hideLoader(context);
          break;
        case TaskState.error:
          MainPage.updateLoaderProgress(context, "Download Error");
          MainPage.hideLoader(context);
          break;
      }
    });
  }

  handleDeleteAccount() async {
    bool? passwordCheckSuccess = await showDialog(context: context, builder: (context) => const ConfirmCurrentPasswordDialogue());
    if (passwordCheckSuccess != null && passwordCheckSuccess) {
      await profileService.deleteProfile();
      SignOutService.signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) { return FutureBuilder(future: null, builder: (BuildContext context, AsyncSnapshot snapshot) {
    return Align(alignment: Alignment.topCenter, child: FractionallySizedBox(widthFactor: 0.9, child: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Text(displayName, style: CommonTheme.getLargeTextStyle(context)),
        InitialsButton(changePage: widget.changePage)
      ]),
      const Padding(padding: EdgeInsets.all(10)),

      (adminFlag)
      ? Column(children: <Widget>[
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
          height: MediaQuery.of(context).size.height * 0.07,
          child: Text("Your Company Code", style: CommonTheme.getMediumTextStyle(context))
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
          height: MediaQuery.of(context).size.height * 0.16,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.lightMidPurpleColor),
                height: MediaQuery.of(context).size.height * 0.06,
                width: constraints.maxWidth - 150,
                child: Text(businessCode, style: CommonTheme.getMediumTextStyle(context))
              );
            }),
            const Padding(padding: EdgeInsets.all(5)),
            FractionallySizedBox(widthFactor: 0.9, child: Text(
              "Share with employees to join the company when signing up",
              style: TextStyle(color: CommonTheme.whiteColor, fontSize: MediaQuery.of(context).size.width * 0.038, fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ))
          ])
        ),
        const Padding(padding: EdgeInsets.all(10))
      ])
      : const Padding(padding: EdgeInsets.all(0)),

      Text("Profile", style: CommonTheme.getMediumTextStyle(context)),
      const Padding(padding: EdgeInsets.all(5)),
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
        child: FractionallySizedBox(widthFactor: 0.9, child: Column(children: <Widget>[
          const Padding(padding: EdgeInsets.all(5)),
          ProfilePageOption(
            changePage: widget.changePage,
            newPage: EditProfilePage(changePage: widget.changePage),
            image: "lib/src/images/icons/profile/profile.png",
            text: "Edit Profile"
          ),
          (adminFlag)
            ? ProfilePageOption(
              changePage: widget.changePage,
              newPage: CompanyDetailsPage(changePage: widget.changePage),
              image: "lib/src/images/icons/profile/company-details.png",
              text: "Company Details"
            )
            : Container(),
          (MainPage.currentRestrictions.downloadAllowed)
            ? ProfilePageOption(
              changePage: widget.changePage,
              newPage: DownloadDataPage(changePage: widget.changePage, previousPage: ProfilePage(changePage: widget.changePage)),
              image: "lib/src/images/icons/profile/data.png",
              text: "Download Your Data"
            )
            : Container()
        ]))
      ),
      const Padding(padding: EdgeInsets.all(10)),

      // Important stuff
      Text("Important Stuff", style: CommonTheme.getMediumTextStyle(context)),
      const Padding(padding: EdgeInsets.all(5)),
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
        child: FractionallySizedBox(widthFactor: 0.9, child: Column(children: <Widget>[
          const Padding(padding: EdgeInsets.all(5)),
          // Download Terms and Conditions Document
          GestureDetector(
            onTap: () => downloadDocument("terms_and_conditions.pdf"),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Image(image: const AssetImage("lib/src/images/icons/profile/ts-and-cs.png"), width: MediaQuery.of(context).size.width * 0.1),
                  const Padding(padding: EdgeInsets.all(5)),
                  Text("Terms and Conditions", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
                ]),
                Image(image: const AssetImage("lib/src/images/icons/misc/right-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
              ]
            )
          ),
          const Padding(padding: EdgeInsets.all(5)),

          // Download Privacy Policy Document
          GestureDetector(
            onTap: () => downloadDocument("privacy_policy.pdf"),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Image(image: const AssetImage("lib/src/images/icons/profile/privacy.png"), width: MediaQuery.of(context).size.width * 0.1),
                  const Padding(padding: EdgeInsets.all(5)),
                  Text("Privacy Policy", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
                ]),
                Image(image: const AssetImage("lib/src/images/icons/misc/right-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
              ]
            )
          ),
          const Padding(padding: EdgeInsets.all(5)),

          // Support - Not Yet Implemented
      //     ProfilePageOption(
      //       changePage: widget.changePage,
      //       newPage: Container(),
      //       image: "lib/src/images/icons/profile/support.png",
      //       text: "Support"
      //     )
        ]))
      ),
      const Padding(padding: EdgeInsets.all(15)),

      // Manage Subscription
      (adminFlag)
        ? Column(children: <Widget>[
          GestureDetector(
            onTap: () => widget.changePage(UpgradePage(changePage: widget.changePage, previousPage: ProfilePage(changePage: widget.changePage,),)),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
              child: FractionallySizedBox(widthFactor: 0.9, child: Column(children: <Widget>[
                const Padding(padding: EdgeInsets.all(5)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Row(children: <Widget>[
                    Image(image: const AssetImage("lib/src/images/icons/profile/manage-subscription.png"), width: MediaQuery.of(context).size.width * 0.1),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text("Manage Subscription", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
                  ]),
                  Image(image: const AssetImage("lib/src/images/icons/misc/right-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
                ]),
                const Padding(padding: EdgeInsets.all(5))
              ]))
            )
          ),
          const Padding(padding: EdgeInsets.all(15))
        ])
        : Container(),

      // Delete Account
      GestureDetector(
        onTap: () => handleDeleteAccount(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
          child: FractionallySizedBox(widthFactor: 0.9, child: Column(children: <Widget>[
            const Padding(padding: EdgeInsets.all(5)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Row(children: <Widget>[
                Image(image: const AssetImage("lib/src/images/icons/profile/delete.png"), width: MediaQuery.of(context).size.width * 0.1),
                const Padding(padding: EdgeInsets.all(5)),
                Text("Delete Account", style: TextStyle(color: CommonTheme.whiteColor, fontFamily: "Open Sans", fontSize: MediaQuery.of(context).size.width * 0.045))
              ]),
              Image(image: const AssetImage("lib/src/images/icons/misc/right-arrow.png"), width: MediaQuery.of(context).size.width * 0.1)
            ]),
            const Padding(padding: EdgeInsets.all(5))
          ]))
        )
      ),
      const Padding(padding: EdgeInsets.all(15)),

      Center(child: GestureDetector(
        onTap: () => SignOutService.signOut(context),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text("Sign Out", style: CommonTheme.getMediumTextStyle(context))
        )
      )),
      const Padding(padding: EdgeInsets.all(10)),
    ])))));
  }); }
}

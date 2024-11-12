import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:templog/src/features/home/pages/home_page.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/subscriptions/data/restrictions.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/widgets/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({ super.key });

  static List<Location> locations = [];
  static Location currentLocation = Location("", "", "", "", "", []);

  static Restrictions currentRestrictions = Restrictions.freeTierRestrictions();

  static TargetPlatform currentPlatform = defaultTargetPlatform;

  static showLoader(BuildContext context, bool downloadProgressSpinner, String titleText) {
    (downloadProgressSpinner)
      ? context.loaderOverlay.show(
        widgetBuilder: (progress) {
          return progress == null 
            ? Container()
            : AlertDialog(
              backgroundColor: CommonTheme.deepPurpleColor,
              title: Text(titleText, style: CommonTheme.themeData.textTheme.displayMedium),
              content: Text(progress, style: CommonTheme.themeData.textTheme.displaySmall)
            );
        }
      )
      : context.loaderOverlay.show(widgetBuilder: (_) => Container(), );
  }

  static hideLoader(BuildContext context) { context.loaderOverlay.hide(); }

  static updateLoaderProgress(BuildContext context, dynamic newProgress) { context.loaderOverlay.progress(newProgress); }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ThemeData theme = CommonTheme.themeData;
  late Widget currentPage = HomePage(changePage: changePage);

  changePage(Widget newPage) { setState(() { currentPage = newPage; }); }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent,
      child: PopScope(canPop: false, child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        bottomNavigationBar: BottomNavBar(changePage: changePage),
        body: currentPage
      ))
    );
  }
}

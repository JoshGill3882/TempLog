import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/profile/pages/profile_page.dart';
import 'package:templog/src/theme/common_theme.dart';

class InitialsButton extends StatelessWidget {
  final Function changePage;
  const InitialsButton({ required this.changePage, super.key });

  getUserInitials() {
    String? userDisplayName = DefaultFirebaseOptions.auth.currentUser!.displayName;
    if (userDisplayName != null && userDisplayName.isNotEmpty) {
      return userDisplayName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase();
    }
    return 'TL';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => changePage(ProfilePage(changePage: changePage)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          border: Border.all(color: CommonTheme.whiteColor, width: 3)
        ),
        width: MediaQuery.of(context).size.width * 0.12,
        height: MediaQuery.of(context).size.width * 0.12,
        child: Center(child: Text(getUserInitials(), style: TextStyle(color: CommonTheme.whiteColor, fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold, height: 0.1)))
      )
    );
  }
}
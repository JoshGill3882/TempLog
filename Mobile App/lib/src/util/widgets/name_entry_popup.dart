import 'package:flutter/material.dart';
import 'package:templog/src/theme/common_theme.dart';
import 'package:templog/src/util/validators.dart';

// ignore: must_be_immutable
class NameEntryPopup extends StatefulWidget {
  String? initialName;
  NameEntryPopup({ required this.initialName, super.key });

  @override
  State<NameEntryPopup> createState() => _NameEntryPopupState();
}

class _NameEntryPopupState extends State<NameEntryPopup> {
  final _formKey = GlobalKey<FormState>();
  final theme = CommonTheme.themeData;

  bool nameError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CommonTheme.deepPurpleColor,
      content: SingleChildScrollView(
        child: Form(key: _formKey, child: Column(children: <Widget>[
          Text("Enter Full Name", style: CommonTheme.getMediumTextStyle(context)),
          const Padding(padding: EdgeInsets.all(3)),

          // Name Entry Field
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.7,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.07 - 10,
              width: MediaQuery.of(context).size.width * 0.7 - 40,
              child: TextFormField(
                cursorColor: CommonTheme.whiteColor,
                decoration: const InputDecoration(border: InputBorder.none, errorStyle: TextStyle(fontSize: 0)),
                style: CommonTheme.getSmallTextStyle(context),
                onSaved:(newValue) => widget.initialName = newValue!,
                validator: (value) {
                  if (Validators.isNull(value) || Validators.isBlank(value)) { setState(() => nameError = true); return "Name Error"; }
                  return null;
                },
                initialValue: widget.initialName
              )
            )
          ),

          // Error Display
          const Padding(padding: EdgeInsets.all(3)),
          (nameError)
            ? Align(alignment: Alignment.center, child: Text("Please enter a valid name", style: CommonTheme.getErrorTextStyle(context)))
            : Container(),
          const Padding(padding: EdgeInsets.all(10)),

          // Confirm Button
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pop(context, widget.initialName);
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
              height: MediaQuery.of(context).size.height * 0.065,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text("Confirm", style: CommonTheme.getMediumTextStyle(context))
            )
          ),
          const Padding(padding: EdgeInsets.all(5)),

          // Cancel Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: CommonTheme.buttonGradient),
              height: MediaQuery.of(context).size.height * 0.065,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: CommonTheme.medPurpleColor),
                height: MediaQuery.of(context).size.height * 0.065 - 10,
                width: MediaQuery.of(context).size.width * 0.5 - 10,
                child: Text("Cancel", style: CommonTheme.getMediumTextStyle(context))
              )
            )
          ),
          const Padding(padding: EdgeInsets.all(5))
        ]))
      )
    );
  }
}

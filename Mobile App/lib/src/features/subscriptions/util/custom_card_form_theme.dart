import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:templog/src/theme/common_theme.dart';

class CustomCardFormTheme implements CreditCardTheme {
  @override
  Color backgroundColor = CommonTheme.deepPurpleColor;
  @override
  Color textColor = CommonTheme.whiteColor;
  @override
  Color borderColor = CommonTheme.medPurpleColor;
  @override
  Color labelColor = CommonTheme.whiteColor;
}

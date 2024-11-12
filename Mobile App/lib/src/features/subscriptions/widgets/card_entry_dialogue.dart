import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:templog/src/features/subscriptions/data/card_validator.dart';
import 'package:templog/src/features/subscriptions/util/custom_card_form_theme.dart';
import 'package:templog/src/theme/common_theme.dart';

class CardEntryDialogue extends StatefulWidget {
  const CardEntryDialogue({ super.key });

  @override
  State<CardEntryDialogue> createState() => _CardEntryDialogueState();
}

class _CardEntryDialogueState extends State<CardEntryDialogue> {
  CreditCardController cardController = CreditCardController();
  final theme = CommonTheme.themeData;

  CreditCardResult? currentCard;

  Widget cardError = Container();

  handleCardSubmit() {
    if (currentCard == null) {
      setState(() {
        cardError = Column(children: <Widget>[
          Text("Card Invalid", style: theme.textTheme.bodySmall),
          const Padding(padding: EdgeInsets.all(7))
        ]);
      });
      return;
    }

    if (!CardValidator.validateCreditCard(currentCard!.cardNumber, currentCard!.expirationMonth, currentCard!.expirationYear, currentCard!.cvc)) {
      setState(() {
        cardError = Column(children: <Widget>[
          Text("Card Invalid", style: theme.textTheme.bodySmall),
          const Padding(padding: EdgeInsets.all(7))
        ]);
      });
      return;
    }

    Navigator.pop(
      context,
      currentCard
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CommonTheme.deepPurpleColor,
      title: Text("Enter Card Details", style: theme.textTheme.displayMedium),
      content: SingleChildScrollView(child: Column(children: <Widget>[
        // Credit Card Form
        CreditCardForm(
          controller: cardController,
          onChanged: (CreditCardResult result) => currentCard = result,
          theme: CustomCardFormTheme()
        ),
        const Padding(padding: EdgeInsets.all(7)),

        // Error Message
        cardError,

        // Submit Button
        GestureDetector(
          onTap: () => handleCardSubmit(),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(gradient: CommonTheme.buttonGradient, borderRadius: BorderRadius.circular(35)),
            height: 50,
            width: 500,
            child: Text("Submit", style: theme.textTheme.displayMedium)
          )
        ),
        const Padding(padding: EdgeInsets.all(7)),

        // Cancel Button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(gradient: CommonTheme.buttonGradient, borderRadius: BorderRadius.circular(35)),
            height: 50,
            width: 500,
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: CommonTheme.deepPurpleColor, borderRadius: BorderRadius.circular(35)),
                height: constraints.maxHeight - 7,
                width: constraints.maxWidth - 7,
                child: Text("Cancel", style: theme.textTheme.displayMedium)
              );
            })
          )
        ),
        const Padding(padding: EdgeInsets.all(5))
      ])
    ));
  }
}

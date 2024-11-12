class CardValidator {
  // Checks card number is valid using the "Luhn" method
  static bool isValidLuhn(String cardNumber) {
    int sum = 0;
    bool isAlternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);
      if (isAlternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      isAlternate = !isAlternate;
    }
    return sum % 10 == 0;
  }

  // Checks the card hasn't expired
  static bool isNotExpired(String expiryMonth, String expiryYear) {
    final currentDate = DateTime.now();
    final int expMonth = int.parse(expiryMonth);
    final int expYear = int.parse('20$expiryYear'); // assuming expiryYear is in YY format

    if (expMonth < 1 || expMonth > 12) {
      return false;
    }

    // Check if the current year is greater than expiry year or
    // if the current month is greater than expiry month when the years are the same
    if (expYear < currentDate.year || (expYear == currentDate.year && expMonth < currentDate.month)) {
      return false;
    }

    return true;
  }

  // Checks security code is valid
  static bool isValidCVV(String cvv, String cardNumber) {
    // American Express cards have a 4-digit CVV, others have a 3-digit CVV
    if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) {
      // American Express
      return cvv.length == 4 && RegExp(r'^\d{4}$').hasMatch(cvv);
    } else {
      // Other cards
      return cvv.length == 3 && RegExp(r'^\d{3}$').hasMatch(cvv);
    }
  }

  static bool validateCreditCard(String cardNumber, String expiryMonth, String expiryYear, String cvv) {
    if (!isValidLuhn(cardNumber)) { return false; }

    if (!isNotExpired(expiryMonth, expiryYear)) { return false; }

    if (!isValidCVV(cvv, cardNumber)) { return false; }

    return true;
  }
}
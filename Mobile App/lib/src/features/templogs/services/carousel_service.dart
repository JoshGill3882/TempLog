import 'package:templog/src/features/templogs/widgets/carousel_display.dart';

class CarouselService {
  final daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  getCarouselListLength(int month, bool leapYear) {
    switch (month) {
      case 1:
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;

      case 2:
        if (leapYear) { return 29; }
        return 28;
    }
  }

  getCarouselObjects(DateTime monthYear) {
    final month = monthYear.month;
    final year = monthYear.year;
    bool leapYear = false;

    // If the year is divisible by 4 or 400, it might be a leap year
    if ((year % 4 == 0) || (year % 400 == 0)) {
      // If the year is divisible by 100 but NOT 400, it is not a leap year
      if ((year % 100 == 0) && (year % 400 != 0)) {
        leapYear = false;
      }
      leapYear = true;
    }

    final int numOfDays = getCarouselListLength(month, leapYear);

    List<CarouselDisplay> carouselObjects = [];
    for (int x = 0; x < numOfDays; x++) {
      DateTime date = DateTime(year, month, x+1);
      carouselObjects.add(CarouselDisplay(daysOfWeek[date.weekday - 1], x+1));
    }
    return carouselObjects;
  }
}

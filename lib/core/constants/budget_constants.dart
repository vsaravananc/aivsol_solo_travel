import '../enums/travel_style.dart';

abstract final class BudgetConstants {
  static const double travelRPK = 10.0;
  static const double hotelRPN = 800.0;
  static const double foodRPD = 800.0;
  static const double localTRPD = 1000.0;

  static double getMultiplier(TravelStyle travelStyle) {
    switch (travelStyle) {
      case TravelStyle.budget:
        return 1.0;
      case TravelStyle.standard:
        return 1.25;
      case TravelStyle.comfort:
        return 1.5;
    }
  }
}

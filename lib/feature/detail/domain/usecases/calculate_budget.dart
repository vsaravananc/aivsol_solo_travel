import '../../../../core/constants/budget_constants.dart';
import '../../../../core/enums/travel_style.dart';
import '../entities/budget_entity.dart';

class CalculateBudget {
  const CalculateBudget();

  BudgetEntity calculate({
    required double distanceInKm,
    required int tripDays,
    required int hotelNights,
    required TravelStyle travelStyle,
  }) {
    final multiplier = BudgetConstants.getMultiplier(travelStyle);

    final baseTravel = distanceInKm * BudgetConstants.travelRPK;
    final baseHotel = hotelNights * BudgetConstants.hotelRPN;
    final baseFood = tripDays * BudgetConstants.foodRPD;
    final baseLocalTransport = tripDays * BudgetConstants.localTRPD;

    final travelCost = (baseTravel * multiplier).roundToDouble();
    final hotelCost = (baseHotel * multiplier).roundToDouble();
    final foodCost = (baseFood * multiplier).roundToDouble();
    final localTransportCost = (baseLocalTransport * multiplier)
        .roundToDouble();

    final totalCost = travelCost + hotelCost + foodCost + localTransportCost;

    return BudgetEntity(
      travelCost: travelCost,
      hotelCost: hotelCost,
      foodCost: foodCost,
      localTransportCost: localTransportCost,
      totalCost: totalCost,
      distanceInKm: distanceInKm,
      tripDays: tripDays,
      hotelNights: hotelNights,
    );
  }
}

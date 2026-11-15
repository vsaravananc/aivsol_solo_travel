import '../../../../core/constants/budget_constants.dart';
import '../../../../core/enums/travel_style.dart';
import '../entities/budget_entity.dart';

class CalculateBudget {
  const CalculateBudget();

  BudgetEntity calculate({
    double? rawDistance,
    DateTime? startDate,
    DateTime? endDate,
    required TravelStyle travelStyle,
    double? distanceInKm,
    int? tripDays,
    int? hotelNights,
  }) {
    final start = DateTime(startDate!.year, startDate.month, startDate.day);
    final end = DateTime(endDate!.year, endDate.month, endDate.day);
    final diffDays = end.difference(start).inDays;
    final finalTripDays = diffDays + 1;
    final finalHotelNights = diffDays;
    final finalRoundTripKm = (rawDistance! / 1000) * 2;

    final multiplier = BudgetConstants.getMultiplier(travelStyle);

    final baseTravel = finalRoundTripKm * BudgetConstants.travelRPK;
    final baseHotel = finalHotelNights * BudgetConstants.hotelRPN;
    final baseFood = finalTripDays * BudgetConstants.foodRPD;
    final baseLocalTransport = finalTripDays * BudgetConstants.localTRPD;

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
      distanceInKm: finalRoundTripKm,
      tripDays: finalTripDays,
      hotelNights: finalHotelNights,
    );
  }
}

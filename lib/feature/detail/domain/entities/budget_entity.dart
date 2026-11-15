import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  final double travelCost;
  final double hotelCost;
  final double foodCost;
  final double localTransportCost;
  final double totalCost;
  final double distanceInKm;
  final int tripDays;
  final int hotelNights;

  const BudgetEntity({
    required this.travelCost,
    required this.hotelCost,
    required this.foodCost,
    required this.localTransportCost,
    required this.totalCost,
    required this.distanceInKm,
    required this.tripDays,
    required this.hotelNights,
  });

  @override
  List<Object?> get props => [
        travelCost,
        hotelCost,
        foodCost,
        localTransportCost,
        totalCost,
        distanceInKm,
        tripDays,
        hotelNights,
      ];
}

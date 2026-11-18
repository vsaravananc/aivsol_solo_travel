import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String? from;
  final double? fromLatitude;
  final double? fromLongitude;
  final String? to;
  final double? toLatitude;
  final double? toLongitude;
  final DateTime? startDate;
  final DateTime? endDate;
  final TravelStyle? travelStyle;

  const HomeState({
    this.from,
    this.fromLatitude,
    this.fromLongitude,
    this.to,
    this.toLatitude,
    this.toLongitude,
    this.startDate,
    this.endDate,
    this.travelStyle,
  });

  bool get isFormValid =>
      (from?.trim().isNotEmpty ?? false) &&
      fromLatitude != null &&
      fromLongitude != null &&
      (to?.trim().isNotEmpty ?? false) &&
      toLatitude != null &&
      toLongitude != null &&
      startDate != null &&
      endDate != null &&
      travelStyle != null;

  @override
  List<Object?> get props => [
        from,
        fromLatitude,
        fromLongitude,
        to,
        toLatitude,
        toLongitude,
        startDate,
        endDate,
        travelStyle,
      ];

  HomeState copyWith({
    String? from,
    double? fromLatitude,
    double? fromLongitude,
    String? to,
    double? toLatitude,
    double? toLongitude,
    DateTime? startDate,
    DateTime? endDate,
    TravelStyle? travelStyle,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    return HomeState(
      from: clearFrom ? null : (from ?? this.from),
      fromLatitude: clearFrom ? null : (fromLatitude ?? this.fromLatitude),
      fromLongitude: clearFrom ? null : (fromLongitude ?? this.fromLongitude),
      to: clearTo ? null : (to ?? this.to),
      toLatitude: clearTo ? null : (toLatitude ?? this.toLatitude),
      toLongitude: clearTo ? null : (toLongitude ?? this.toLongitude),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelStyle: travelStyle ?? this.travelStyle,
    );
  }
}

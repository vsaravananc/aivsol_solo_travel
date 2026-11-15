import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String? from;
  final String? to;
  final DateTime? startDate;
  final DateTime? endDate;
  final TravelStyle? travelStyle;

  const HomeState({
    this.from,
    this.to,
    this.startDate,
    this.endDate,
    this.travelStyle,
  });

  bool get isFormValid =>
      (from?.trim().isNotEmpty ?? false) &&
      (from!.length > 3) &&
      (to?.trim().isNotEmpty ?? false) &&
      (to!.length > 3) &&
      startDate != null &&
      endDate != null &&
      travelStyle != null;

  @override
  List<Object?> get props => [from, to, startDate, endDate, travelStyle];
  HomeState copyWith({
    String? from,
    String? to,
    DateTime? startDate,
    DateTime? endDate,
    TravelStyle? travelStyle,
  }) {
    return HomeState(
      from: from ?? this.from,
      to: to ?? this.to,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelStyle: travelStyle ?? this.travelStyle,
    );
  }
}

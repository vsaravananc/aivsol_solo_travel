import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/save_trip_history_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/save_trip_history_event.dart';
import 'package:aivsol_solo_travel/feature/home/domain/entities/location_entity.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/location_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/location_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateTripPlanButtonWidget extends StatelessWidget {
  const GenerateTripPlanButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isFormValid = context.select<HomeBloc, bool>(
      (bloc) => bloc.state.isFormValid,
    );
    final isLocationLoading = context.select<LocationBloc, bool>(
      (bloc) => bloc.state is LocationLoading,
    );

    final isLoading = isLocationLoading;
    final isEnabled = isFormValid && !isLocationLoading;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.themeData.primaryColor,
          foregroundColor: context.themeData.scaffoldBackgroundColor,
          disabledBackgroundColor: context.themeData.disabledColor.withAlpha(
            25,
          ),
          disabledForegroundColor: context.themeData.disabledColor,
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: isEnabled
            ? () {
                context.read<SaveTripHistoryBloc>().add(
                  const RestartSaveTripHistoryEvent(),
                );
                final homeState = context.read<HomeBloc>().state;
                if (homeState.fromLatitude != null &&
                    homeState.fromLongitude != null &&
                    homeState.toLatitude != null &&
                    homeState.toLongitude != null) {
                  context.read<LocationBloc>().add(
                    SetPredefinedLocationsEvent(
                      fromLocation: LocationEntity(
                        name: homeState.from!,
                        latitude: homeState.fromLatitude!,
                        longitude: homeState.fromLongitude!,
                      ),
                      toLocation: LocationEntity(
                        name: homeState.to!,
                        latitude: homeState.toLatitude!,
                        longitude: homeState.toLongitude!,
                      ),
                    ),
                  );
                } else {
                  context.read<LocationBloc>().add(
                    ResolveTripLocationsEvent(
                      fromCity: homeState.from!,
                      toCity: homeState.to!,
                    ),
                  );
                }
              }
            : null,
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.themeData.scaffoldBackgroundColor,
                  ),
                ),
              )
            : const Text('Generate Trip Plan'),
      ),
    );
  }
}

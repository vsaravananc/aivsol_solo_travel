import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../map_picker/domain/entities/selected_location_entity.dart';
import '../../../map_picker/presentation/screens/map_screen.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class FromToInputWidget extends StatefulWidget {
  const FromToInputWidget({super.key});

  @override
  State<FromToInputWidget> createState() => _FromToInputWidgetState();
}

class _FromToInputWidgetState extends State<FromToInputWidget> {
  final ValueNotifier<double> rotationTurns = ValueNotifier(0.0);

  @override
  void dispose() {
    rotationTurns.dispose();
    super.dispose();
  }

  void _handleSwap() {
    rotationTurns.value += 0.5;
    context.read<HomeBloc>().add(const LocationsSwappedEvent());
  }

  Future<void> _selectLocation({required bool isFrom}) async {
    final homeState = context.read<HomeBloc>().state;
    final existingCoord = isFrom
        ? (homeState.fromLatitude != null && homeState.fromLongitude != null
            ? LatLng(homeState.fromLatitude!, homeState.fromLongitude!)
            : null)
        : (homeState.toLatitude != null && homeState.toLongitude != null
            ? LatLng(homeState.toLatitude!, homeState.toLongitude!)
            : null);

    final result = await Navigator.push<SelectedLocationEntity>(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          initialLocation: existingCoord,
          title: isFrom ? 'Select Departure Location' : 'Select Destination',
        ),
      ),
    );

    if (result != null && mounted) {
      if (isFrom) {
        context.read<HomeBloc>().add(
              FromLocationSelectedEvent(
                address: result.address,
                latitude: result.latitude,
                longitude: result.longitude,
              ),
            );
      } else {
        context.read<HomeBloc>().add(
              ToLocationSelectedEvent(
                address: result.address,
                latitude: result.latitude,
                longitude: result.longitude,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final fromText = state.from;
        final toText = state.to;

        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: context.themeData.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: context.themeData.disabledColor.withAlpha(12),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.themeData.shadowColor.withAlpha(20),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: context.themeData.primaryColor.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.themeData.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1.2,
                          height: 35,
                          color: context.themeData.primaryColor.withAlpha(30),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: context.themeData.primaryColor.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.location_on_rounded,
                              color: context.themeData.primaryColor,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LocationSelectField(
                            label: 'From',
                            value: fromText,
                            placeholder: 'Bengaluru , Kerala , etc ...',
                            onTap: () => _selectLocation(isFrom: true),
                          ),
                          const SizedBox(height: 16),
                          _LocationSelectField(
                            label: 'To',
                            value: toText,
                            placeholder: 'Chennai , Coimbatore , etc ...',
                            onTap: () => _selectLocation(isFrom: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 44),  
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleSwap,
                    borderRadius: BorderRadius.circular(22),
                    child: Ink(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: context.themeData.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.themeData.dividerColor.withAlpha(20),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.themeData.shadowColor.withAlpha(18),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: rotationTurns,
                          builder: (context, _) {
                            return AnimatedRotation(
                              turns: rotationTurns.value,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Icon(
                                Icons.swap_vert_rounded,
                                color: context.themeData.primaryColor,
                                size: 22,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LocationSelectField extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  const _LocationSelectField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value! : placeholder,
                    style: hasValue
                        ? context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )
                        : context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

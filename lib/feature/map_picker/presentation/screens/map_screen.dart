import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/map_picker_bloc.dart';
import '../bloc/map_picker_event.dart';
import '../bloc/map_picker_state.dart';
import '../widgets/map_center_pin.dart';
import '../widgets/map_confirm_button.dart';
import '../widgets/map_search_bar.dart';

class MapScreen extends StatelessWidget {
  final LatLng? initialLocation;
  final String? title;

  const MapScreen({super.key, this.initialLocation, this.title});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<MapPickerBloc>();
      return _MapScreenView(initialLocation: initialLocation, title: title);
    } catch (_) {
      return BlocProvider<MapPickerBloc>(
        create: (_) => sl<MapPickerBloc>(),
        child: _MapScreenView(initialLocation: initialLocation, title: title),
      );
    }
  }
}

class _MapScreenView extends StatefulWidget {
  final LatLng? initialLocation;
  final String? title;

  const _MapScreenView({this.initialLocation, this.title});

  @override
  State<_MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<_MapScreenView> {
  late final MapController _mapController;
  late LatLng _currentCenter;
  bool _isMoving = false;

  static const LatLng _chennaiDefault = LatLng(13.0827, 80.2707);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = widget.initialLocation ?? _chennaiDefault;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onCurrentLocationPressed() {
    final target = widget.initialLocation ?? _chennaiDefault;
    _mapController.move(target, 14.0);
    setState(() {
      _currentCenter = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapPickerBloc, MapPickerState>(
      listenWhen: (previous, current) =>
          previous.confirmedLocation != current.confirmedLocation ||
          previous.confirmationError != current.confirmationError,
      listener: (context, state) {
        if (state.confirmedLocation != null) {
          Navigator.pop(context, state.confirmedLocation);
        } else if (state.confirmationError != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.confirmationError!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
          context.read<MapPickerBloc>().add(
            const ClearConfirmationErrorEvent(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 3,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: AppColors.textPrimary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            title: Text(
              widget.title ?? 'Select Location',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentCenter,
                  initialZoom: 14.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onPositionChanged: (camera, hasGesture) {
                    setState(() {
                      _currentCenter = camera.center;
                    });
                  },
                  onMapEvent: (event) {
                    if (event is MapEventMoveStart) {
                      setState(() => _isMoving = true);
                    } else if (event is MapEventMoveEnd) {
                      setState(() => _isMoving = false);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'http://mt{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                    subdomains: ['0', '1', '2', '3'],
                    tileProvider: NetworkTileProvider(
                      cachingProvider:
                          BuiltInMapCachingProvider.getOrCreateInstance(
                            maxCacheSize: 1_000_000_000,
                          ),
                    ),
                  ),
                ],
              ),

              MapCenterPin(isMoving: _isMoving),

              Positioned(
                top: MediaQuery.of(context).padding.top + 60,
                left: 16,
                right: 16,
                child: MapSearchBar(
                  onPlaceSelected: (place) {
                    final latLng = LatLng(place.latitude, place.longitude);
                    _mapController.move(latLng, 15.0);
                    setState(() {
                      _currentCenter = latLng;
                    });
                  },
                ),
              ),

              Positioned(
                right: 16,
                bottom: 90,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _onCurrentLocationPressed,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: MapConfirmButton(
                  isLoading: state.isConfirming,
                  onConfirm: () {
                    context.read<MapPickerBloc>().add(
                      ConfirmLocationEvent(
                        latitude: _currentCenter.latitude,
                        longitude: _currentCenter.longitude,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

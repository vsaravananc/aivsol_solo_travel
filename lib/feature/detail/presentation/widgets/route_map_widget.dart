import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/route_map_bloc.dart';
import '../bloc/route_map_state.dart';
import 'route_map_loading_widget.dart';

class RouteMapWidget extends StatefulWidget {
  final String fromName;
  final String toName;
  final LatLng fromLocation;
  final LatLng destinationLocation;
  final double height;

  const RouteMapWidget({
    super.key,
    required this.fromName,
    required this.toName,
    required this.fromLocation,
    required this.destinationLocation,
    this.height = 280,
  });

  @override
  State<RouteMapWidget> createState() => _RouteMapWidgetState();
}

class _RouteMapWidgetState extends State<RouteMapWidget> {
  late final MapController _mapController;
  bool _hasFittedCamera = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _fitCameraToBounds(List<LatLng> points) {
    if (points.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(40, 50, 40, 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteMapBloc, RouteMapState>(
      listener: (context, state) {
        if (state is RouteMapLoaded && !_hasFittedCamera) {
          _hasFittedCamera = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _fitCameraToBounds(state.route.coordinates);
            }
          });
        }
      },
      builder: (context, state) {
        if (state is RouteMapInitial || state is RouteMapLoading) {
          return RouteMapLoadingWidget(height: widget.height);
        }

        if (state is RouteMapFailure) {
          return const SizedBox.shrink();
        }

        if (state is RouteMapLoaded) {
          final coordinates = state.route.coordinates;
          final initialBounds = LatLngBounds.fromPoints(
            coordinates.isNotEmpty
                ? coordinates
                : [widget.fromLocation, widget.destinationLocation],
          );

          return Container(
            width: double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCameraFit: CameraFit.bounds(
                        bounds: initialBounds,
                        padding: const EdgeInsets.fromLTRB(40, 50, 40, 40),
                      ),
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onMapReady: () {
                        _fitCameraToBounds(coordinates);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'http://mt{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                        subdomains: ['0', '1', '2', '3'],
                        tileProvider: NetworkTileProvider(
                          cachingProvider:
                              BuiltInMapCachingProvider.getOrCreateInstance(
                                maxCacheSize: 1_000_000_000,
                              ),
                        ),
                      ),

                      if (coordinates.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: coordinates,
                              strokeWidth: 4.5,
                              color: AppColors.primary,
                              borderStrokeWidth: 1.5,
                              borderColor: Colors.white,
                              strokeCap: StrokeCap.round,
                              strokeJoin: StrokeJoin.round,
                            ),
                          ],
                        ),

                      MarkerLayer(
                        markers: [
                          Marker(
                            point: widget.fromLocation,
                            width: 110,
                            height: 52,
                            alignment: Alignment.topCenter,
                            child: _RouteMarker(
                              label: widget.fromName,
                              color: const Color(0xFF2E7D32),
                              icon: Icons.trip_origin,
                            ),
                          ),

                          Marker(
                            point: widget.destinationLocation,
                            width: 110,
                            height: 52,
                            alignment: Alignment.topCenter,
                            child: _RouteMarker(
                              label: widget.toName,
                              color: const Color(0xFFD32F2F),
                              icon: Icons.location_on,
                            ),
                          ),
                        ],
                      ),

                      const SimpleAttributionWidget(
                        source: Text('OpenStreetMap contributors'),
                      ),
                    ],
                  ),

                  Positioned(
                    right: 10,
                    bottom: 24,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _fitCameraToBounds(coordinates),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.center_focus_strong,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Driving Route',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _RouteMarker extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _RouteMarker({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 13, color: Colors.white),
        ),
      ],
    );
  }
}

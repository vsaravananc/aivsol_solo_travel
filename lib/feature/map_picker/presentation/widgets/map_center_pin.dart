import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MapCenterPin extends StatelessWidget {
  final bool isMoving;

  const MapCenterPin({
    super.key,
    this.isMoving = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: FractionalTranslation(
          // Shift vertically by -0.5 so that the bottom tip of the pin aligns with the exact center
          translation: const Offset(0.0, -0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform: Matrix4.translationValues(0, isMoving ? -6.0 : 0.0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    // Small stem connecting circle to center point
                    Container(
                      width: 3,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              // Shadow dot at the exact center touch point
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: isMoving ? 5 : 8,
                height: isMoving ? 2 : 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: isMoving ? 0.2 : 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

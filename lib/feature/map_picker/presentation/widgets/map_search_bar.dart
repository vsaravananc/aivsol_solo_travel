import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/place_search_entity.dart';
import '../bloc/map_picker_bloc.dart';
import '../bloc/map_picker_event.dart';
import '../bloc/map_picker_state.dart';

class MapSearchBar extends StatefulWidget {
  final ValueChanged<PlaceSearchEntity> onPlaceSelected;

  const MapSearchBar({super.key, required this.onPlaceSelected});

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      if (query.trim().length >= 2) {
        context.read<MapPickerBloc>().add(SearchPlacesEvent(query.trim()));
      } else {
        context.read<MapPickerBloc>().add(const ClearSearchEvent());
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    _debounceTimer?.cancel();
    context.read<MapPickerBloc>().add(const ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapPickerBloc, MapPickerState>(
      builder: (context, state) {
        final hasResults = state.searchResults.isNotEmpty;
        final isSearching = state.isSearching;
        final hasError =
            state.searchError != null && state.searchError!.isNotEmpty;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.themeData.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onQueryChanged,
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                textInputAction: TextInputAction.search,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search city, landmark, or area...',
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : (_controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 20),
                                onPressed: _clearSearch,
                              )
                            : null),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            if (hasResults || hasError)
              Container(
                margin: const EdgeInsets.only(top: 8),
                constraints: const BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  color: context.themeData.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: hasError
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            state.searchError!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 13,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: state.searchResults.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1, thickness: 0.8),
                          itemBuilder: (context, index) {
                            final place = state.searchResults[index];
                            return Material(
                              child: ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                title: Text(
                                  place.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  place.displayName,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  _focusNode.unfocus();
                                  _controller.text = place.name;
                                  context.read<MapPickerBloc>().add(
                                    const ClearSearchEvent(),
                                  );
                                  widget.onPlaceSelected(place);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
          ],
        );
      },
    );
  }
}

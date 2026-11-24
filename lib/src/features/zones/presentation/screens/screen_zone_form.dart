import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';
import 'package:hajjmate/src/core/utils/validators.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_bloc.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_event.dart';
import 'package:hajjmate/src/features/zones/presentation/bloc/zone_form_state.dart';
import 'package:hajjmate/src/shared/models/coordinates.dart';
import 'package:hajjmate/src/shared/widgets/buttons/base_button.dart';
import 'package:hajjmate/src/shared/widgets/inputfields/base_input.dart';
import 'package:hajjmate/src/shared/widgets/map/osm_tile_layer.dart';
import 'package:hajjmate/src/shared/widgets/toast/app_toast.dart';
import 'package:latlong2/latlong.dart';

class ScreenZoneForm extends StatefulWidget {
  const ScreenZoneForm({super.key});

  @override
  State<ScreenZoneForm> createState() => _ScreenZoneFormState();
}

class _ScreenZoneFormState extends State<ScreenZoneForm> {
  static const LatLng _fallbackCenter = LatLng(21.4225, 39.8262);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mapController = MapController();
  bool _mapReady = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // The position can arrive before or after the map is ready.
  void _moveToStart(Coordinates? start) {
    if (!_mapReady || start == null) return;
    _mapController.move(LatLng(start.latitude, start.longitude), 16);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ZoneFormBloc>().add(ZoneSubmitted(_nameController.text));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<ZoneFormBloc, ZoneFormState>(
          listener: (context, state) {
            if (state.status == ZoneFormStatus.success) context.pop();
            if (state.status == ZoneFormStatus.failure) {
              showAppToast(
                context,
                state.message ?? 'Could not save the zone.',
              );
            }
          },
        ),
        BlocListener<ZoneFormBloc, ZoneFormState>(
          listenWhen: (before, after) =>
              before.startPosition != after.startPosition,
          listener: (context, state) => _moveToStart(state.startPosition),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('New zone')),
        body: BlocBuilder<ZoneFormBloc, ZoneFormState>(
          builder: (context, state) {
            final centre = state.centre;
            final point = centre == null
                ? null
                : LatLng(centre.latitude, centre.longitude);

            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _fallbackCenter,
                          initialZoom: 14,
                          onMapReady: () {
                            _mapReady = true;
                            _moveToStart(state.startPosition);
                          },
                          onTap: (_, tapped) =>
                              context.read<ZoneFormBloc>().add(
                                ZoneCentreSelected(
                                  Coordinates(
                                    latitude: tapped.latitude,
                                    longitude: tapped.longitude,
                                  ),
                                ),
                              ),
                        ),
                        children: [
                          OsmTileLayer(),
                          if (point != null)
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                  point: point,
                                  radius: state.radiusM,
                                  useRadiusInMeter: true,
                                  color: colors.primary.withValues(alpha: 0.2),
                                  borderColor: colors.primary,
                                  borderStrokeWidth: 2,
                                ),
                              ],
                            ),
                          if (point != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: point,
                                  child: Icon(
                                    Icons.pin_drop_rounded,
                                    color: colors.primary,
                                    size: 36,
                                  ),
                                ),
                              ],
                            ),
                          const RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                'OpenStreetMap contributors',
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (point == null)
                        const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Text('Tap the map to place the zone'),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BaseInput(
                            label: 'Zone name',
                            controller: _nameController,
                            validator: Validators.zoneName,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Radius'),
                              Text(
                                '${state.radiusM.round()} m',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          Slider(
                            min: AppConstants.minZoneRadiusM,
                            max: AppConstants.maxZoneRadiusM,
                            divisions: 40,
                            value: state.radiusM,
                            onChanged: (value) => context
                                .read<ZoneFormBloc>()
                                .add(ZoneRadiusChanged(value)),
                          ),
                          const SizedBox(height: 8),
                          BaseButton(
                            label: 'Save zone',
                            isLoading:
                                state.status == ZoneFormStatus.submitting,
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter_map/flutter_map.dart';
import 'package:hajjmate/src/core/constants/app_constants.dart';

class OsmTileLayer extends TileLayer {
  OsmTileLayer({super.key})
    : super(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: AppConstants.packageName,
      );
}

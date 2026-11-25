import 'dart:convert';

import 'package:hajjmate/src/features/zones/domain/entities/geofence_context.dart';
import 'package:hajjmate/src/features/zones/domain/services/geofence_context_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesGeofenceContextStore implements GeofenceContextStore {
  static const String _userIdKey = 'geofence_user_id';
  static const String _userNameKey = 'geofence_user_name';
  static const String _groupIdKey = 'geofence_group_id';
  static const String _zoneNamesKey = 'geofence_zone_names';

  // The async variant does not cache, so the geofence callback, which runs
  // in another isolate, always reads what the app saved last.
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<void> save(GeofenceContext context) async {
    await _preferences.setString(_userIdKey, context.userId);
    await _preferences.setString(_userNameKey, context.userName);
    await _preferences.setString(_groupIdKey, context.groupId);
    await _preferences.setString(_zoneNamesKey, jsonEncode(context.zoneNames));
  }

  @override
  Future<GeofenceContext?> load() async {
    final userId = await _preferences.getString(_userIdKey);
    final userName = await _preferences.getString(_userNameKey);
    final groupId = await _preferences.getString(_groupIdKey);
    final zoneNames = await _preferences.getString(_zoneNamesKey);
    if (userId == null ||
        userName == null ||
        groupId == null ||
        zoneNames == null) {
      return null;
    }
    return GeofenceContext(
      userId: userId,
      userName: userName,
      groupId: groupId,
      zoneNames: (jsonDecode(zoneNames) as Map<String, dynamic>).map(
        (id, name) => MapEntry(id, name as String),
      ),
    );
  }

  @override
  Future<void> clear() async {
    for (final key in [_userIdKey, _userNameKey, _groupIdKey, _zoneNamesKey]) {
      await _preferences.remove(key);
    }
  }
}

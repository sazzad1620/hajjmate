# HajjMate: Viva Preparation Guide

A short guide to explain the project to a teacher who knows **Object-Oriented Programming in Java** but not Flutter. Every point names the file to open. Paths are relative to the project root.

Read it in this order: 1 (what it is), 2 (Flutter in Java terms), 4 (OOP and SOLID), 5 (one full walkthrough), 8 (questions).

---

## 1. What HajjMate is (one minute)

HajjMate helps a **Hajj group leader** keep every **Hajji** in sight.

- A **Hajji** shares their live location from the phone, even with the app in the background.
- The **Leader** sees all Hajjis on one map and draws **safe zones** (a circle: centre and radius).
- When a Hajji **enters or leaves a zone**, the Hajji's phone shows a notification and writes an **alert**. The Leader's phone shows a notification too, and keeps a list of all alerts.

Built with Flutter (Dart), Firebase (Auth, Firestore, Realtime Database), Clean Architecture and BLoC.

**Why this is an OOP project:** the code is split so that business rules never depend on Firebase or on Android. Everything is reached through interfaces, and one file wires the real classes in.

---

## 2. Flutter in Java terms

| Flutter / Dart | Java equivalent | Where to see it |
|---|---|---|
| Dart `class`, `abstract class` | `class`, `interface` / abstract class. Dart has no `interface` keyword: any class can be implemented with `implements` | `lib/src/features/zones/domain/repositories/zone_repository.dart` |
| `extends`, `implements` | same | `lib/src/features/auth/domain/entities/leader.dart` |
| `_name` (underscore) | `private`. Privacy is per file (library), not per class | `Zone._centre` in `zone.dart` |
| `final` | `final` | everywhere |
| `Future<T>` / `async`, `await` | `CompletableFuture<T>` | every repository method |
| `Stream<T>` | an observable sequence (like RxJava `Observable`, or a `Flow`) | `ZoneRepository.watchZones` |
| `Widget` | a View class. It describes the screen; Flutter redraws it when state changes | `lib/src/features/zones/presentation/screens/screen_zones.dart` |
| **BLoC** (`Bloc<Event, State>`) | A controller. The screen sends an **Event**; the bloc runs the use case and emits a new immutable **State**; the screen redraws. This is the Observer pattern | `lib/src/features/zones/presentation/bloc/zone_list_bloc.dart` |
| `pubspec.yaml` | `pom.xml` (dependencies) | `pubspec.yaml` |
| `get_it` | A small dependency-injection container (like a hand-written Spring `ApplicationContext`) | `lib/src/config/di/injection_container.dart` |
| `Equatable` | Auto `equals()` and `hashCode()` from a `props` list | `Alert`, `Zone` |
| `Either<Failure, T>` (`dartz`) | A result that is either a `Failure` (`Left`) or a value (`Right`). Used instead of throwing exceptions across layers | every use case |
| Isolate | A thread that shares **no memory** with others. The background alert code runs in its own isolate | `lib/src/features/alerts/data/geofence_callback.dart` |
| Null safety (`String?`) | `@Nullable`, but the compiler enforces it | everywhere |

One-sentence summary for the teacher: *"A Flutter screen is a class that draws itself from an immutable state object. A BLoC is the controller that produces that state, like MVC with the Observer pattern."*

---

## 3. Architecture

Three layers inside each feature. Arrows point **inward**.

```
presentation (screens, BLoC)  ->  domain (entities, interfaces, use cases)  <-  data (models, Firebase code)
```

| Layer | Contains | Knows about |
|---|---|---|
| **domain** | `Zone`, `Alert`, `User`, repository **interfaces**, use cases | Pure Dart only. No Flutter, no Firebase |
| **data** | `FirestoreZoneRepository`, `ZoneModel`, services | Domain + Firebase and plugins |
| **presentation** | Screens, BLoCs | Domain + Flutter |

Folder map (open these):

```
lib/src/
  core/        errors (Failure), interfaces (UseCase, StreamUseCase), constants, utils
  shared/      Coordinates, theme, reusable widgets
  config/      di/injection_container.dart, router/app_router.dart
  features/
    auth/      sign up, login, sign out, User / Leader / Hajji
    tracking/  share live location (foreground service)
    map/       live group map
    zones/     zones CRUD + register geofences on the phone
    alerts/    enter/exit alerts, Leader notification, alert list
```

**Dependency Inversion in one line:** a use case is written against `ZoneRepository` (an interface). It never imports Firebase.

---

## 4. OOP and SOLID with real code

### 4.1 Abstraction: interfaces hide Firebase

`lib/src/features/zones/domain/repositories/zone_repository.dart`

```dart
abstract class ZoneRepository {
  Stream<Either<Failure, List<Zone>>> watchZones(String groupId);
  Future<Either<Failure, int>> countZones(String groupId);
  Future<Either<Failure, Unit>> createZone(Zone zone);
  Future<Either<Failure, Unit>> updateZone(Zone zone);
  Future<Either<Failure, Unit>> deleteZone(String zoneId);
}
```

The real class is `lib/src/features/zones/data/repositories/firestore_zone_repository.dart` (`class FirestoreZoneRepository implements ZoneRepository`). Other interfaces: `AlertRepository`, `LocationRepository`, `GeofenceRegistry`, `Notifier`, `DeviceLocationProvider`, `LocationSharingService`, `AlertMonitorService`.

### 4.2 Inheritance and polymorphism

`lib/src/features/auth/domain/entities/user.dart`, `leader.dart`, `hajji.dart`

```dart
abstract class User extends Equatable {
  final String id, name, phone, email, groupId;
  const User({required this.id, ...});
  Role get role;               // abstract: each subclass answers differently
}

class Leader extends User { @override Role get role => Role.leader; ... }
class Hajji  extends User { @override Role get role => Role.hajji;  ... }
```

Code that receives a `User` never checks the exact class. After login, the splash and login screens send the user to the right home with `AppRoutes.homeFor(user.role)` (`lib/src/config/router/app_routes.dart`).

The same idea for errors: `lib/src/core/errors/failures.dart`

```dart
abstract class Failure extends Equatable { final String message; ... }
class NetworkFailure    extends Failure { ... }
class AuthFailure       extends Failure { ... }
class PermissionFailure extends Failure { ... }
class ValidationFailure extends Failure { ... }
```

A BLoC handles a `Failure` and shows `failure.message` without knowing which subclass it is (polymorphism).

### 4.3 Encapsulation: `Zone` protects its own rules

`lib/src/features/zones/domain/entities/zone.dart`

```dart
class Zone extends Equatable {
  final Coordinates _centre;     // private
  final double _radiusM;         // private

  Zone({required this.id, required this.groupId, required this.name,
        required Coordinates centre, required double radiusM})
      : _centre = centre, _radiusM = radiusM {
    if (name.trim().isEmpty) throw ArgumentError('Enter a zone name.');
    if (radiusM < AppConstants.minZoneRadiusM) {
      throw ArgumentError('The radius must be at least ...');
    }
  }

  Coordinates get centre => _centre;
  double get radiusM => _radiusM;

  bool contains(Coordinates point) => _centre.distanceTo(point) <= _radiusM;
}
```

An invalid `Zone` cannot exist: the constructor rejects it. The behaviour (`contains`) lives with the data it uses.

### 4.4 Composition

`Zone` **has a** `Coordinates` (`lib/src/shared/models/coordinates.dart`, which also has `distanceTo`, the haversine distance). A BLoC **has** use cases. A use case **has** a repository.

### 4.5 Factory pattern

`lib/src/features/auth/domain/entities/user_factory.dart`

```dart
static User fromRole({required Role role, ...}) {
  return switch (role) {
    Role.leader => Leader(...),
    Role.hajji  => Hajji(...),
  };
}
```

### 4.6 Strategy pattern: `Notifier`

`lib/src/features/alerts/domain/services/notifier.dart` is the interface. `LocalNotifier` (`data/services/local_notifier.dart`) is one strategy. A push-message notifier could be added without touching `ReportZoneEventUseCase` (Open/Closed).

### 4.7 Observer pattern

Firestore and Realtime Database `Stream`s push changes to the repository, the BLoC listens, and widgets rebuild when the BLoC emits a new state. This is why a zone edited on the Leader's phone appears on the Hajji's phone within seconds.

### 4.8 SOLID table

| Principle | Example |
|---|---|
| **S**ingle responsibility | One use case per action (`CreateZoneUseCase`, `DeleteZoneUseCase`). A model only converts data (`AlertModel`). A repository only talks to storage |
| **O**pen/closed | New `Notifier` or new repository implementation added without editing callers |
| **L**iskov | Any `ZoneRepository` (the Firestore one or a test fake) can replace another. Tests do this with mocks |
| **I**nterface segregation | Small interfaces: `ZoneRepository`, `AlertRepository`, `Notifier`, not one big `DataService` |
| **D**ependency inversion | Use cases depend on interfaces. `get_it` chooses the implementations in one file |

### 4.9 Use cases: one class, one action

`lib/src/core/interfaces/use_case.dart`

```dart
abstract interface class UseCase<Input, Output> {
  Future<Either<Failure, Output>> execute(Input input);
}
```

`lib/src/features/zones/domain/usecases/create_zone_use_case.dart` checks the business rules (valid zone, at most `maxZonesPerGroup` zones) and only then calls `_repository.createZone(zone)`. The rule is in the domain, not in the screen and not in Firebase.

### 4.10 Dependency injection in one file

`lib/src/config/di/injection_container.dart`

```dart
void _registerAlerts() {
  getIt
    ..registerLazySingleton<AlertRepository>(
      () => RealtimeAlertRepository(getIt(), getIt()),
    )
    ..registerLazySingleton<AlertMonitorService>(
      ForegroundAlertMonitorService.new,
    )
    ..registerFactory<AlertListBloc>(() => AlertListBloc(getIt(), getIt()));
}
```

Left side is the interface, right side is the class that serves it. To swap Firebase for something else, only this file and the data layer change.

### 4.11 Errors as values

`lib/src/core/errors/error_handler.dart` turns any exception (Firebase, timeout) into one of the `Failure` subclasses at the **data** boundary. The layers above never see Firebase exceptions.

```dart
Failure handle(Object error) {
  if (error is TimeoutException) return const NetworkFailure();
  if (error is FirebaseAuthException) return _fromAuth(error);
  if (error is FirebaseException) return _fromFirebase(error);
  return const UnknownFailure();
}
```

---

## 5. Full walkthrough: from a Hajji entering a zone to the Leader's notification

This is the best story to tell. Five steps, five files.

**Step 1: The Leader creates a zone.**
`ScreenZoneForm` -> `ZoneFormBloc` -> `CreateZoneUseCase` -> `ZoneRepository` -> `FirestoreZoneRepository` -> Firestore `zones` collection.

**Step 2: The Hajji's phone registers the zone with the operating system.**
`lib/src/features/zones/presentation/bloc/geofence_sync_bloc.dart` listens to the zone stream (live). Each change calls `SyncGeofencesUseCase`, which saves a small context (user, group, zone names) and calls `GeofenceRegistry.sync`. The real class `NativeGeofenceRegistry` (`data/services/native_geofence_registry.dart`) adds only the geofences that changed. Android's own geofencing then watches the circle, so it works with the app closed and uses almost no battery.

```dart
// native_geofence_registry.dart
triggers: {ng.GeofenceEvent.enter, ng.GeofenceEvent.exit},
androidSettings: const ng.AndroidGeofenceSettings(
  initialTriggers: {ng.GeofenceEvent.enter},   // already inside -> alert at once
  notificationResponsiveness: Duration(seconds: 30),
),
```

**Step 3: The phone enters or leaves the circle. Android wakes our callback.**
`lib/src/features/alerts/data/geofence_callback.dart`

```dart
@pragma('vm:entry-point')
Future<void> onGeofenceTriggered(GeofenceCallbackParams params) async {
  ...
  final context = await SharedPreferencesGeofenceContextStore().load();
  ...
  final reportZoneEvent = ReportZoneEventUseCase(
    RealtimeAlertRepository(FirebaseDatabase.instance, ErrorHandler()),
    LocalNotifier(),
  );
  ...
}
```

This runs in its **own isolate** with no shared memory, so `get_it` is not set up. The callback builds the few objects it needs by hand and reads the cached context from `shared_preferences`. This is why the context store exists.

**Step 4: Notify the Hajji, then record the alert.**
`lib/src/features/alerts/domain/usecases/report_zone_event_use_case.dart`

```dart
Future<Either<Failure, Unit>> execute(Alert alert) async {
  try {
    await _notifier.show(title: 'Zone alert', body: 'You $action ${alert.zoneName}');
  } catch (_) {}
  return _repository.publish(alert);   // Realtime DB alerts/{groupId}
}
```

The notification comes first, because it is local and works without internet. A failed upload cannot hide it.

**Step 5: The Leader is told.**
- *List:* `AlertListBloc` -> `WatchAlertsUseCase` -> `RealtimeAlertRepository.watchLatest` (last 50, newest first) -> `ScreenAlerts`.
- *Notification:* when the Leader signs in, `AlertMonitorBloc` starts a foreground service (`ForegroundAlertMonitorService`). Its handler (`alert_task_handler.dart`) listens to `watchNew` and shows a notification for each new alert.

"New" means "added after listening started". The repository finds the last key and listens after it (`orderByKey().startAfter(lastKey)`). Push keys grow with time, so this does not depend on the two phones' clocks.

### Same story as a diagram

```
Leader phone                       Firebase                         Hajji phone
 create zone  ------------------> Firestore zones ----(live)----> GeofenceSyncBloc
                                                                      | registers circle with Android
                                                                      v
                                                          Android geofence fires (even if app closed)
                                                                      |
                                                          onGeofenceTriggered (own isolate)
                                                                      |-- local notification
                                                                      '-- publish alert
 alert service  <--- Realtime DB alerts/{group} <----------------------'
 notification + Alerts list
```

---

## 6. Other features in short

| Feature | How | Files |
|---|---|---|
| **Auth** | Firebase Auth. The role (Leader/Hajji) and name are stored in Firestore `users/{uid}`. After login the app builds a `Leader` or `Hajji` through `UserFactory` | `features/auth/` |
| **Live location** | A foreground service (separate isolate) sends the position to Realtime DB `locations/{groupId}/{uid}` every few seconds. Realtime DB is used because it is fast for frequent small writes | `features/tracking/data/services/location_task_handler.dart` |
| **Map** | `flutter_map` with OpenStreetMap tiles (free, no API key). Zones are drawn as circles in metres | `features/map/`, `features/zones/presentation/widgets/zone_layers.dart` |
| **Navigation** | `go_router` with a bottom-bar shell per role | `config/router/app_router.dart` |
| **Sign out** | Clears the geofences and cached context, and stops the alert service, so the next user of the phone starts clean | `features/auth/presentation/bloc/sign_out_bloc.dart` |

Data placement: **Firestore** for structured data that is read often and queried (`users`, `zones`). **Realtime Database** for fast-changing data (`locations`, `alerts`). Security rules are described in `docs/TRD.md` section 6.

---

## 7. Testing

Unit tests live under `test/src/...` and mirror the `lib` folders. They use `mocktail` to replace interfaces with fakes. That is Liskov substitution in practice: a use case does not know it is talking to a mock.

Examples:

- `test/src/features/zones/domain/entities/zone_test.dart`: the constructor rejects a blank name or a small radius; `contains` includes a point on the edge.
- `test/src/features/zones/domain/usecases/create_zone_use_case_test.dart`: zone limit and validation.
- `test/src/features/alerts/domain/usecases/report_zone_event_use_case_test.dart`: the notification is shown even when publishing fails.
- `test/src/features/alerts/presentation/bloc/alert_list_bloc_test.dart`: the bloc emits `ready` or `failure`.

Run all: `flutter test`. Static checks: `flutter analyze` (no issues).

---

## 8. Likely questions and short answers

**Q1. Why Clean Architecture for a small app?**
So rules do not depend on tools. `Zone` and the use cases do not import Firebase. Swapping Firestore for another database changes only the data layer. It also makes each part testable alone.

**Q2. What is the difference between an entity and a model?**
The entity (`Zone`) is the business object and has rules. The model (`ZoneModel`) only converts between the entity and a Firestore document. The domain stays free of Firebase.

**Q3. Where is polymorphism used?**
`User` -> `Leader`/`Hajji` through `role`; `Failure` subclasses; any `Repository` or `Notifier` implementation behind its interface.

**Q4. Where is encapsulation used?**
`Zone` keeps `_centre` and `_radiusM` private, validates in the constructor and exposes `contains()`. Nobody can build an invalid zone or change the radius from outside.

**Q5. What is BLoC and why not call Firebase from the screen?**
A BLoC receives events and emits states. The screen only draws the current state. Business logic and I/O stay out of the UI, so the UI is simple and the logic is testable.

**Q6. Why `Either` instead of exceptions?**
The possible failure is part of the method's type, so the caller must handle it. Exceptions are invisible in the signature. We convert exceptions to `Failure` once, at the data boundary.

**Q7. What is dependency injection here?**
Classes receive their dependencies through the constructor. `get_it` is the container that builds them, registered by hand in `injection_container.dart`. There is no code generation or magic.

**Q8. Why does the background code not use `get_it`?**
Android starts the geofence callback in a **separate isolate** (like a separate process: no shared memory). Objects from the main app, including `get_it`, do not exist there. The callback builds what it needs and reads cached data from `shared_preferences`.

**Q9. How does it work with the app closed?**
Hajji: Android's geofencing service watches the circle and wakes the callback. Leader: a foreground service keeps a Realtime Database listener alive and shows a persistent notification. This avoids a paid server for push messages.

**Q10. Why use Android's geofencing instead of checking the distance ourselves?**
Checking ourselves would need the GPS running all the time, which drains the battery. The operating system does this efficiently. Our `Zone.contains()` is used for rules and tests, while the OS does the live watching.

**Q11. How do you stop duplicate alerts?**
Alerts are written with `push()` (a new unique key each time, never overwritten) and the security rule allows a write only when the entry does not exist. Zones are re-registered only when their id, centre or radius changed, so a restart does not re-register them. The geofence is cleared only on sign out.

**Q12. Which design patterns?**
Repository, Factory (`UserFactory`), Strategy (`Notifier`), Observer (streams and BLoC), Dependency Injection.

**Q13. What are the limits?**
- A Hajji's app must be opened once to receive new zones if it was fully closed (zones already registered still fire).
- The alert time comes from the Hajji's phone clock.
- Long-run behaviour under battery saver on real phones needs more testing. The Leader's foreground service can be stopped by Android after some hours (Android 15 limits `dataSync` services).
- Push messages (FCM) would be the production answer for the Leader, but they need a paid Firebase plan for server code.

**Q14. What would you add next?**
Groups with join codes, Hajji checklists, an SOS button, and per-group security rules (Demo 2 in `docs/ROADMAP.md`).

**Q15. Show an example of Open/Closed.**
`ReportZoneEventUseCase` depends on `Notifier`. To add vibration or SMS, write a new `Notifier` and register it in `injection_container.dart`. The use case is not edited.

---

## 9. Demo script (3 minutes)

1. Two phones: Leader (real phone), Hajji (emulator). Both signed in.
2. Hajji: **Start sharing**. Leader's Map shows the Hajji.
3. Leader: **Zones** -> add a zone around the Hajji. Show the circle on the map. Hajji's map shows the same circle at once.
4. Move the Hajji's location out of the zone. Hajji gets "You left ...". Leader gets the notification and sees it in **Alerts**.
5. Move back in. "You entered ..." appears on both.
6. Close the Hajji app from recents and repeat to show it works in the background.
7. Open `ZoneRepository` and `FirestoreZoneRepository` side by side to show the interface and the implementation (Abstraction, Dependency Inversion). Open `Zone` to show Encapsulation.

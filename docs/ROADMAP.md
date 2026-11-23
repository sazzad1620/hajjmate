# HajjMate: Roadmap

| Version | Last updated | Author |
|---|---|---|
| 1.0 | 23 November 2026 | Md. Sazzad Hossain |

> **Note:** This is a living document. Tasks may be split, reordered or added as the work shows what is really needed. Product scope is in [PRD.md](PRD.md); technical decisions are in [TRD.md](TRD.md).

## How to use this roadmap

- **One sub-task = one branch = one pull request**, with 2–4 small commits inside. Branch name `feat/short-name`; commit style `type(scope): description` (see TRD §11).
- Tick the box when the sub-task is merged into `main`.
- After each sub-task the AI assistant suggests one short commit message; the developer commits and pushes (the assistant never does).
- Each sub-task has a **Done when** line: if it is true, the task is finished.
- **Reference** lines point to files in the two earlier projects to read before starting (see References). Ideas only; nothing is copied.

## References (local, for the developer and the AI assistant)

- **field-track** (own earlier project): `/Users/admin/Desktop/Sazzad Personal/Projects/field-track`
- **sokrio-retailer-app** (industry-standard structure): `/Users/admin/Desktop/flutter_projects/sokrio-retailer-app`

## Already done (setup)

- [x] Flutter project created, app name set to HajjMate
- [x] Firebase connected (`hajjmate-app`)
- [x] `docs/PRD.md` and `docs/TRD.md`
- [ ] `docs/ROADMAP.md` (this file)
- [ ] `docs/DESIGN.md` (screens and navigation), **to be written before task 3**

## Demo 1: single group, core tracking (stories 1 to 5)

- [ ] **1. Core skeleton** `core`
  Folder structure from TRD §3, theme, `go_router` shell, `get_it` file, `Failure` hierarchy, `IUseCase`, constants (default group id, zone limits).
  *Done when:* the app starts on an empty home screen through the new structure and `flutter analyze` is clean.
  *Reference:* retailer `core/errors/failures.dart`, `core/interfaces/interface_use_case.dart`; field-track `core/di/injection.dart`.

- [ ] **2. Domain model** `core`
  `Coordinates`, `Zone` (validation and `contains`), `User` → `Leader`, `Hajji`, `UserFactory`, `Alert`, `LocationUpdate`, with unit tests.
  *Done when:* the tests pass, including a point inside, on and outside a zone, and a radius below 100 m rejected.

- [ ] **3. Email login** `auth`
  `AuthRepository`, use cases, `FirebaseAuthRepository`, `LoginBloc`, login and sign-up screen, `users` document.
  *Done when:* a user can sign up and sign in with email and the user document is saved.
  *Reference:* retailer `features/auth/` (use case, repository impl, bloc) and its use case tests.

- [ ] **4. Google sign-in, role and routing** `auth`
  Google Sign-In, role selection on first sign-in, session restore, role-based redirect (leader home vs Hajji home).
  *Done when:* story 1 passes: role saved on first sign-in and the user stays signed in after restart.

- [ ] **5. Background spike** `geofence`
  Throw-away experiment on a real Android phone: foreground service stays alive, a `native_geofence` callback runs in the background and writes to Realtime Database.
  *Done when:* the result is written into TRD §12 (works, or what to change). **If it fails, the plan below is revised before going further.**
  *Reference:* field-track `features/geofence/geofence_callback.dart`, `data/native_geofence_registry.dart`.

- [ ] **6. Location sharing** `location`
  `DeviceLocationProvider`, permissions, Hajji publishes location every 30–60 s through the foreground service, `RealtimeLocationRepository`.
  *Done when:* a Hajji's position appears and updates in the database while the app is in the background.

- [ ] **7. Leader live map** `map`
  `flutter_map` with OpenStreetMap, one pin per Hajji, last-update time.
  *Done when:* story 2 passes: pins update at least every 60 s with the time shown.
  *Reference:* field-track `features/locations/presentation/widgets/location_map_preview.dart`.

- [ ] **8. Zones: create and list** `zone`
  `ZoneRepository`, use cases, create zone (tap a point, radius default 150 m, min 100 m), list, 10-zone limit.
  *Done when:* a leader creates and lists zones and an 11th is refused.
  *Reference:* field-track `features/locations/` (`geofence_radius_slider.dart`, `location_radius_limits.dart`).

- [ ] **9. Zones: edit, delete, show on maps** `zone`
  Edit name and radius, delete, zones drawn on the leader's and the Hajji's map.
  *Done when:* story 3 passes.

- [ ] **10. Geofence registration** `geofence`
  `GeofenceRegistry` / `NativeGeofenceRegistry` registers the zones on the Hajji's phone and re-syncs when zones change.
  *Done when:* adding, editing or deleting a zone updates the phone's registered geofences.

- [ ] **11. Geofence alerts** `geofence`
  Callback shows a local notification to the Hajji and writes an enter/exit `Alert` to `alerts/{groupId}`.
  *Done when:* story 5 passes, including with the app in the background.

- [ ] **12. Leader alerts** `geofence`
  Alert listener in the foreground service, notification on the leader's phone, alert list screen (all alerts, newest first).
  *Done when:* story 4 passes: alert arrives within about 60 s and stays in the list.

**Demo 1 is complete here:** a leader creates a zone, a Hajji walks out, both phones show the alert.

## Demo 2: groups, checklist, SOS, polish (stories 6 to 9)

- [ ] **13. Groups and join code** `group`
  Create a group, unique join code, join with the code, cap of 50, `groupId` taken from the user.
  *Done when:* story 6 passes.

- [ ] **14. Group-scoped data and security rules** `firebase`
  Rules filter by `groupId`, alert rule checks `userId == auth.uid` and membership (TRD §6.3).
  *Done when:* a user from group A cannot read or write group B's data.

- [ ] **15. Checklist: leader** `checklist`
  Create tasks, see done / not done per Hajji.
  *Done when:* story 7 passes.

- [ ] **16. Checklist: Hajji** `checklist`
  Hajji sees and ticks tasks, leader's status updates within seconds.
  *Done when:* story 8 passes.

- [ ] **17. SOS** `sos`
  SOS button with confirmation, alert with the Hajji's location to the leader.
  *Done when:* story 9 passes.

- [ ] **18. Bangla and English** `i18n`
  Localization for all screens, language switch.
  *Done when:* every screen is readable in both languages.

- [ ] **19. Tests and polish** `core`
  Fill missing tests, large buttons and simple screens for senior users, error and empty states.
  *Done when:* `flutter test` and `flutter analyze` are clean.

- [ ] **20. Final docs and release check** `core`
  README with screenshots and setup, docs updated to match the code, release build runs.
  *Done when:* a new person can clone, set up and run the app from the README.

## Added during work

Tasks that appear while building are added here (with the reason), instead of being hidden.

- (none yet)

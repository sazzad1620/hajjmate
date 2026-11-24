# HajjMate: Roadmap

| Version | Last updated | Author |
|---|---|---|
| 1.0 | 24 November 2026 | Md. Sazzad Hossain |

> **Note:** This is a living document. Tasks may be split, reordered or added as the work shows what is really needed. Product scope is in [PRD.md](PRD.md); technical decisions are in [TRD.md](TRD.md).

## How to use this roadmap

- **One sub-task = 2–4 small commits directly on `main`.** Commit style `type(scope): description` (see TRD §11). Only the spike (task 4) uses a local branch.
- Each task builds its own domain classes, data layer, screens and unit tests inside its feature folder, the same way the reference project is organised. There is no separate "domain model" task.
- Tick the box when the sub-task is finished and committed.
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
- [x] `docs/ROADMAP.md` (this file)
- [x] `docs/DESIGN.md` (screens and navigation)

## Demo 1: single group, core tracking (stories 1 to 5)

- [x] **1. Core skeleton** `core`
  Folder structure from TRD §3, theme (Anek Bangla font bundled in assets), `go_router` shell, `get_it` file, `Failure` hierarchy, `UseCase`, constants (default group id, zone limits), and the shared `Coordinates` class (with `distanceTo`).
  *Done when:* the app starts on an empty home screen through the new structure, the `Coordinates` test passes and `flutter analyze` is clean.
  *Reference:* retailer `core/errors/failures.dart`, `core/interfaces/interface_use_case.dart`; field-track `core/di/injection.dart`.

- [x] **2. Email login** `auth`
  `User` → `Leader`, `Hajji` and `UserFactory`, `AuthRepository`, use cases, `FirebaseAuthRepository`, `LoginBloc`, login screen, sign-up with two buttons ("Sign up as Leader" and "Sign up as Hajji"), `users` document with the role.
  *Done when:* a user can sign up as a Leader or a Hajji and sign in with email, and the user document is saved with the role.
  *Reference:* retailer `features/auth/` (entities, use case, repository impl, bloc) and its use case tests.

- [x] **3. Session restore and role routing** `auth`
  Splash that restores the session on app start, role-based redirect after sign-in (leader home vs Hajji home), sign out. The two home screens are temporary placeholders (title and a sign-out button) that later tasks replace.
  *Done when:* story 1 passes: the role is saved at sign-up, each role lands on its own home, the user stays signed in after restart, and sign out returns to login.

- [x] **4. Background spike** `geofence`
  Throw-away experiment on a real Android phone: foreground service stays alive, a `native_geofence` callback runs in the background and writes to Realtime Database. Done on a local branch that is never pushed; only the result is committed.
  *Done when:* the result is written into TRD §12 (works, or what to change). **If it fails, the plan below is revised before going further.**
  *Reference:* field-track `features/geofence/geofence_callback.dart`, `data/native_geofence_registry.dart`.

- [x] **5. Location sharing** `location`
  `LocationUpdate`, `DeviceLocationProvider`, permissions, Hajji publishes location every 30–60 s through the foreground service, `RealtimeLocationRepository`.
  *Done when:* a Hajji's position appears and updates in the database while the app is in the background.

- [x] **6. Leader live map** `map`
  `flutter_map` with OpenStreetMap, one pin per Hajji, last-update time.
  *Done when:* story 2 passes: pins update at least every 60 s with the time shown.
  *Reference:* field-track `features/locations/presentation/widgets/location_map_preview.dart`.

- [ ] **7. Zones: create and list** `zone`
  `Zone` (private centre and radius, validation, `contains`) with unit tests, `ZoneRepository`, use cases, create zone (tap a point, radius default 150 m, min 100 m), list, 10-zone limit.
  *Done when:* the `Zone` tests pass (a point inside, on and outside; a radius below 100 m rejected), a leader creates and lists zones and an 11th is refused.
  *Reference:* field-track `features/locations/` (`geofence_radius_slider.dart`, `location_radius_limits.dart`).

- [ ] **8. Zones: edit, delete, show on maps** `zone`
  Edit name and radius, delete, zones drawn on the leader's and the Hajji's map.
  *Done when:* story 3 passes.

- [ ] **9. Geofence registration** `geofence`
  `GeofenceRegistry` / `NativeGeofenceRegistry` registers the zones on the Hajji's phone and re-syncs when zones change.
  *Done when:* adding, editing or deleting a zone updates the phone's registered geofences.

- [ ] **10. Geofence alerts** `geofence`
  `Alert` and `AlertType`, callback shows a local notification to the Hajji and writes an enter/exit `Alert` to `alerts/{groupId}`.
  *Done when:* story 5 passes, including with the app in the background.

- [ ] **11. Leader alerts** `geofence`
  Alert listener in the foreground service, notification on the leader's phone, alert list screen (all alerts, newest first).
  *Done when:* story 4 passes: alert arrives within about 60 s and stays in the list.

**Demo 1 is complete here:** a leader creates a zone, a Hajji walks out, both phones show the alert. Tag `demo-1`.

## Demo 2: groups, checklist, SOS, polish (stories 6 to 9)

- [ ] **12. Groups and join code** `group`
  Create a group, unique join code, join with the code, cap of 50, `groupId` taken from the user.
  *Done when:* story 6 passes.

- [ ] **13. Group-scoped data and security rules** `firebase`
  Rules filter by `groupId`, alert rule checks `userId == auth.uid` and membership (TRD §6.3).
  *Done when:* a user from group A cannot read or write group B's data.

- [ ] **14. Checklist: leader** `checklist`
  Create tasks, see done / not done per Hajji.
  *Done when:* story 7 passes.

- [ ] **15. Checklist: Hajji** `checklist`
  Hajji sees and ticks tasks, leader's status updates within seconds.
  *Done when:* story 8 passes.

- [ ] **16. SOS** `sos`
  SOS button with confirmation, alert with the Hajji's location to the leader.
  *Done when:* story 9 passes.

- [ ] **17. Bangla and English** `i18n`
  Localization for all screens, language switch.
  *Done when:* every screen is readable in both languages.

- [ ] **18. Tests and polish** `core`
  Fill missing tests, large buttons and simple screens for senior users, error and empty states.
  *Done when:* `flutter test` and `flutter analyze` are clean.

- [ ] **19. Final docs and release check** `core`
  README with screenshots and setup, docs updated to match the code, release build runs. Tag `demo-2`.
  *Done when:* a new person can clone, set up and run the app from the README.

## Backlog (not scheduled, can be picked up inside any task)

- **Google Sign-In** `auth`: sign in with Google, and ask "Leader or Hajji?" the first time a Google user signs in (there is no sign-up step for Google). Left out of the first pass because email and password already cover story 1.

## Added during work

Tasks that appear while building are added here (with the reason), instead of being hidden.

- [x] **Home shells** `core` (to do before task 5)
  Replace the two temporary home screens with the real navigation from DESIGN §3: a bottom bar for the Leader (`Map | Zones | Alerts | More`) and for the Hajji (`Home | Map | Profile`; `Tasks` comes in Demo 2). Each tab is an empty screen with a title for now, and Sign out moves into More (Leader) and Profile (Hajji).
  *Why added:* the first plan had no task for the app's navigation structure, so the first real screens would have been bolted onto temporary pages. Doing it once, now, gives every later task its place.
  *Done when:* both roles open to their bottom bar, every tab opens, and Sign out works from More or Profile.

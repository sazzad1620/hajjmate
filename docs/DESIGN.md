# HajjMate: Design

| Version | Last updated | Author |
|---|---|---|
| 1.0 | 24 November 2026 | Md. Sazzad Hossain |

> **Note:** This is a living document. Screens and visuals may change while the app is built. Product scope is in [PRD.md](PRD.md), technical rules in [TRD.md](TRD.md), task order in [ROADMAP.md](ROADMAP.md).

## 1. Principles

The main users are senior Hajjis, often outdoors in bright sun, and a leader who needs the whole group at a glance.

- **Big and clear:** large text, large buttons, high contrast.
- **One main action per screen.** Few choices at a time.
- **Always show the state:** is location sharing on, is the Hajji inside a zone, when was the last update.
- **SOS is never hidden.** It sits on the Hajji's home screen.
- **Map first for the leader**, big status and SOS first for the Hajji.

## 2. Theme

**Light theme only** in the first version (reads best outdoors). A dark theme is future scope. All colours are defined once in the app theme and screens read them from there, so dark can be added without touching each screen (TRD §10.2).

### 2.1 Colours (emerald and sand)

| Role | Colour | Use |
|---|---|---|
| Background | `#FAF6EC` | Screen background |
| Surface | `#FFFFFF` | Cards, sheets |
| Border | `#E8DFC8` | Card outline, dividers |
| Primary | `#0F5C4D` | Main buttons, active tab, links |
| Accent | `#C9A24B` | Decoration only (icons, progress fill) |
| Text | `#1F2A26` | Main text |
| Text secondary | `#5C6B64` | Hints, timestamps |
| Danger | `#D64545` | SOS, errors |
| Warning | `#B7791F` | Exit alert |

Rules:
- **Gold is never used for text**: it is too light on white or sand. Use primary or text colours for anything that must be read.
- Alert colours: enter = primary, exit = warning, SOS = danger.
- Colour is never the only signal: pair it with an icon and a word (for example "Left Mina zone").
- Text contrast is checked with a contrast checker before release.

### 2.2 Typography

- **Font:** Anek Bangla for everything, bundled in the app's assets so it works offline. One font covers both Bangla and English letters, so mixed lines (a Hajji's English name inside a Bangla sentence) look consistent, and no second font or fallback is needed.
- **Sizes:** body 18, heading 22, title 28, small text 14 (the minimum, used only for timestamps and hints).
- **Weights:** regular and semi-bold only.

### 2.3 Sizing and shape

- Minimum tap target **56 dp**; main buttons full width.
- Spacing scale: 4, 8, 12, 16, 24, 32.
- Corner radius: cards 16, buttons 14.
- Icons 24 dp, with a text label next to or under them.

## 3. Navigation

```
Splash → Login / Sign up (email, Google) → Choose role (first sign-in only) → Role home
```

The role decides the home. A signed-in user returns directly to their home (session restore).

### 3.1 Leader: bottom bar `Map | Zones | Alerts | More`

| Tab | Screen | Content | Demo |
|---|---|---|---|
| Map | Group map | Pin per Hajji, tap a pin for name and last update, zones drawn as circles | 1 |
| Zones | Zone list | List with name and radius, add button | 1 |
| | Zone form | Tap the map to set the centre, name, radius slider (minimum 100 m, default 150 m), save, delete | 1 |
| Alerts | Alert list | All alerts, newest first, with icon, Hajji name, zone and time | 1 |
| More | Profile | Name, role, sign out | 1 |
| | Group | Join code, member count | 2 |
| | Checklist | Create tasks, done / not done per Hajji | 2 |
| | Language | English / Bangla | 2 |

### 3.2 Hajji: bottom bar `Home | Map | Tasks | Profile`

| Tab | Screen | Content | Demo |
|---|---|---|---|
| Home | Status | Big card: inside or outside a zone, "location sharing is on", last sent time | 1 |
| | SOS | Large SOS button with a confirmation step | 2 |
| Map | Own map | The Hajji's position and the group's zones | 1 |
| Tasks | Checklist | Tasks to tick off | 2 |
| Profile | Profile | Name, join code entry (Demo 2), sign out | 1 |

In Demo 1 the Hajji's bar has three tabs (no Tasks).

### 3.3 First-run permission screens

A Hajji must allow location (all the time) and notifications for geofence alerts, and a leader must allow notifications. Each permission gets a short screen that says **why** in plain words before the system dialog appears. If a permission is refused, the home screen shows a clear warning with a button to open settings.

## 4. Common states

Every list and data screen has all three:

- **Loading:** a simple progress indicator.
- **Empty:** one friendly line and the action to fix it (for example "No zones yet. Add your first zone.").
- **Error:** what happened and a retry button, never a raw error text.

## 5. Open items

| # | Item | Plan |
|---|---|---|
| 1 | Maximum zone radius is not decided | Suggest 1000 m; decide in task 7 |
| 2 | Exact screen layouts | Sketch on paper or Figma before each UI task if needed |

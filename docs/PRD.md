# HajjMate: Product Requirements Document

| | |
|---|---|
| **Version** | 1.0 |
| **Last updated** | 23 November 2026 |
| **Author** | Md. Sazzad Hossain |

> **Note:** This is a living document. Scope, constraints and technology choices may change as the project evolves (for example, while writing the TRD).

## 1. Overview

HajjMate is a mobile app (Flutter) that helps a Hajj group leader keep every Haji in sight. Hajis share their live location; the leader sees the group on one map, sets safe zones, and gets automatic alerts when someone leaves a zone or presses SOS. The leader also assigns checklists and sees who is ready.

## 2. Problem

1. **No live visibility.** Leaders don't know where each Haji is without calling them.
2. **Constant map watching.** Even with location sharing, someone must keep checking the map.
3. **Untracked instructions.** Instructions like "be ready at 7 AM" are passed by word of mouth; the leader can't tell who has followed them.

## 3. Goals and non-goals

**Goal:** *No Haji left behind.* See every Haji live, get alerted automatically, know who is ready.

**Non-goals for the first version:** store release, iOS build, server push (FCM), phone OTP login, leader announcements, multiple groups per leader, offline maps, web dashboard, SMS fallback.

## 4. Users

| User | Needs |
|---|---|
| **Haji** (often a senior citizen) | Simple screens, large buttons, Bangla; help if lost; clear instructions |
| **Group leader (admin)** | See everyone at a glance; be told when someone strays; know who is ready |

Rules: one leader manages one group of **up to 50 Hajis**; Hajis join with a code.

## 5. First version scope

**Must have**

1. Login with Firebase Authentication (email/password and Google Sign-In), the same for both roles
2. Live group map with each Haji's last update time (updates every 30–60 s)
3. Zone management: create (point + radius), name, change radius, list and delete; **up to 10 per group**
4. Geofence enter/exit alerts on both the Haji's and the leader's phone
5. Groups: a leader creates a group and shares a join code; Hajis join with it
6. Checklist: leader assigns tasks, Hajis tick them, leader sees status per Haji
7. SOS button that alerts the leader with the Haji's location

**Should have**

8. Bangla and English UI

## 6. User stories and acceptance criteria

| # | Story | Acceptance criteria | Demo |
|---|---|---|---|
| 1 | As a user, I sign in with email or Google and choose my role (leader or Haji) | Account and role are saved on first sign-in; I stay signed in after reopening the app | 1 |
| 2 | As a leader, I see all Hajis on a map | Each pin updates at least every 60 s while tracking is on; last-update time is shown | 1 |
| 3 | As a leader, I manage zones | I tap a point and set a radius (min. 100 m, default 150 m); I can name, edit, list and delete zones; max 10; zones show on Hajis' maps | 1 |
| 4 | As a leader, I'm alerted when a Haji leaves a zone | Alert reaches my phone within about 60 s while my app runs in the background | 1 |
| 5 | As a Haji, I'm told when I leave a zone | Local notification on my phone, even with the app in the background | 1 |
| 6 | As a leader, I create a group and share a join code | Code is unique; a Haji who enters it appears in the group; group is capped at 50 | 2 |
| 7 | As a leader, I assign a checklist task | Task appears for every Haji in my group; I see done/not done per Haji | 2 |
| 8 | As a Haji, I tick off a task | Leader's status view updates within a few seconds | 2 |
| 9 | As a Haji, I press SOS | Leader gets an alert with my location; I see a confirmation | 2 |

## 7. Constraints and assumptions

- Flutter (Dart), Clean Architecture with BLoC; OOP and SOLID principles applied throughout for maintainability (also a course requirement)
- The UI starts in English; Bangla support is added later (Demo 2)
- Firebase Spark (free) plan: Realtime Database for live location and alerts, Firestore for everything else
- Android first, tested on real phones; developer machine is an Intel Mac
- Leader's app must run in the background to receive alerts (no server push in the first version)
- **Every record carries a `groupId` from the start.** In Demo 1 all users share one default group; Demo 2 adds real groups without changing existing data or code structure
- **Demo 1 is single-tenant:** all leaders and Hajis are in the default group (`groupId = "default"`). Any leader can create, edit and delete zones, and every leader is alerted when any Haji enters or leaves a zone; Hajis are notified on their own phones
- **Demo 2 is multi-tenant:** each group is its own tenant. A leader sees and manages only their group's zones and gets alerts only for their own Hajis, enforced by filtering on `groupId` and by Firebase Security Rules

## 8. Delivery plan

| Milestone | Content | Stories | Share |
|---|---|---|---|
| **Demo 1** | Project setup, login (email and Google) with role, live map, full zone management, geofence alerts on both phones (one default group) | 1–5 | ~55% |
| **Demo 2** | Groups and join code, checklist, SOS, Bangla/English, unit tests and polish | 6–9 | ~45% |

The detailed 15–20 sub-tasks live in the implementation plan (`ROADMAP.md`), each finished with its own commit.

## 9. Success criteria

- **Demo 1:** the leader creates a zone, a Haji walks out of it, and both phones show the alert
- **Demo 2:** a Haji joins with a code; checklist status updates on the leader's phone; SOS reaches the leader with the correct location

## 10. Future scope

QR code join: the leader's join code shown as a QR code that Hajis can scan instead of typing. Planned only if time allows within the project timeline.

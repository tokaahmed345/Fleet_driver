<h1 align="center">🚌 Fleet Driver</h1>
<p align="center">
  <b>Transit Driver Mobile Application — Built with Flutter</b><br/>
  A driver-centric, offline-first app for real-time route navigation, live updates, and passenger (free seats) logging.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10-02569B?logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.10-0175C2?logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/State%20Management-Cubit-purple" />
  <img src="https://img.shields.io/badge/Offline%20First-Hive-orange" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-green" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey" />
</p>

---

## 📖 Overview

**Fleet Driver** is a prototype mobile application built for bus drivers operating on fixed transit routes. It allows drivers to:

- 🗺️ Navigate their assigned route and track progress across stations.
- 📡 Receive real-time updates (congestion, delays, station closures) via a simulated WebSocket connection.
- 🧾 Log the number of **free seats** at each station with a fast, low-distraction interface.
- 📴 Keep working seamlessly even with **no internet connection**, thanks to offline-first local storage and background sync.

The app was designed with a strong focus on **driver safety and usability** — large tap targets, high-contrast UI, and minimal steps to complete any action while driving.

---

## ✨ Key Features

### 🔐 Authentication
- Driver login screen with credential-based authentication.
- Restricted **Admin** registration flow for provisioning new driver accounts.

### 🗺️ Route Navigation
- Dashboard showing the current route, the upcoming station, and live progress along the path.
- GPS-based location tracking using the device's real coordinates.
- **Geofencing validation** — free seat logging is only enabled when the driver is within a defined radius of the target station.

### 🪑 Passenger / Free Seats Logging
- A streamlined modal for logging free seats in minimal taps.
- Logs are timestamped and linked to the station and route.

### 📡 Real-Time Live Updates (Simulated WebSocket)
- Custom `LiveUpdatesSimulatorService` that mimics a real socket lifecycle:
  - Connection states: `connecting` → `connected` → `disconnected`.
  - **Heartbeat** mechanism to keep the connection alive.
  - **Randomized live events**: congestion, station closures, delays, and trip-start notifications.
  - **Auto-reconnect with exponential backoff** when the connection drops.
  - Listens to real device connectivity (`connectivity_plus`) and verifies actual internet reachability (not just network interface state) before reconnecting.

### 📴 Offline-First & Local Sync
- All free-seats logs are cached locally first (Hive) before attempting to sync.
- A background sync queue automatically pushes cached logs once the connection is restored.
- Every log entry tracks a `synced` flag for reliable state recovery.

### 🎨 Driver-Centric UI/UX
- High-contrast, large-tap-target design optimized for use while driving.
- Clear connection/status indicators (connecting, live, offline).
- Loading and error states throughout the app.

---

## 🏗️ Architecture — Clean Architecture

The project strictly follows **Clean Architecture** principles, with a clear separation between the **Presentation**, **Domain**, and **Data** layers, plus a shared **Core** layer. Dependencies always point inward — the UI depends on the domain, never the other way around.

```
lib/
├── core/
│   ├── utils/
│   │   └── service_locator/          # Dependency injection setup (get_it)
│   ├── network/                      # Dio client, network info, connectivity checks
│   ├── error/                        # Failures & exceptions
│   ├── constants/                    # Themes, routes, strings
│   └── services/
│       └── live_updates_simulator_service.dart   # WebSocket-like real-time simulation
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/          # Mock/remote data sources
│   │   │   ├── models/               # DTOs (fromJson/toJson)
│   │   │   └── repositories/         # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/             # Pure business objects
│   │   │   ├── repositories/         # Abstract repository contracts
│   │   │   └── usecases/             # Login, RegisterDriver, etc.
│   │   └── presentation/
│   │       ├── cubit/                # AuthCubit (state)
│   │       ├── screens/              # Login & Admin registration screens
│   │       └── widgets/
│   │
│   ├── route_navigation/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/             # Route dashboard, upcoming station, progress UI
│   │
│   └── seat_logging/
│       ├── data/
│       │   ├── datasources/          # Hive local data source + mock remote sync
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/             # LogFreeSeats, SyncPendingLogs, ValidateGeofence
│       └── presentation/             # Free-seats logging modal
│
├── shared/
│   └── widgets/                      # Reusable cross-feature UI components
│
└── main.dart
```

### Layer Responsibilities

| Layer            | Responsibility                                                                 |
|-------------------|---------------------------------------------------------------------------------|
| **Presentation**  | Widgets/screens + Cubit (state management). No business logic, only UI + method calls that emit new states. |
| **Domain**        | Entities, repository contracts (abstract), and use cases. Pure Dart — no Flutter, no packages. |
| **Data**          | Repository implementations, data sources (Hive local / mock remote), and DTO models. |
| **Core**          | Cross-cutting concerns shared by all features: DI, networking, connectivity, error handling, the live-updates socket simulator. |

**Data flow (unidirectional):**

```
UI (Widget) → Cubit method call → UseCase → Repository (interface)
                                             │
                              ┌──────────────┴──────────────┐
                        Local DataSource              Remote/Mock DataSource
                          (Hive cache)                  (Mock API / Socket)
                                             │
                                      Entity → Cubit emit(State) → UI rebuild (BlocBuilder/BlocListener)
```

- **State Management:** [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (using **Cubit**, not Bloc) manages predictable state transitions per feature with simple, direct method calls instead of events — keeping async operations (network calls, live update streams, sync queue) simple and easy to trace.
- **Dependency Injection:** [`get_it`](https://pub.dev/packages/get_it) wires up data sources, repositories, use cases, and Cubits, keeping every layer decoupled from its concrete dependencies.
- **Navigation:** [`go_router`](https://pub.dev/packages/go_router) handles declarative, deep-link-friendly navigation between features.
- **Dependency Rule:** `presentation → domain ← data`. The domain layer never imports Flutter or any data-layer/package code, which keeps business rules fully testable in isolation.

---

## 🛠️ Tech Stack

| Category               | Package                                                   |
|-------------------------|------------------------------------------------------------|
| State Management        | `flutter_bloc` (Cubit), `bloc`, `equatable`                |
| Dependency Injection    | `get_it`                                                    |
| Networking              | `dio`                                                       |
| Routing                 | `go_router`                                                 |
| Local Storage (Offline) | `hive`, `hive_flutter`, `shared_preferences`                |
| Connectivity            | `connectivity_plus`                                         |
| Location / GPS          | `geolocator`                                                |
| Functional Programming  | `dartz`                                                      |
| UI / Fonts              | `google_fonts`, `shimmer`, `cupertino_icons`                |
| Code Generation         | `build_runner`, `hive_generator`                             |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.10.4`
- Android Studio / Xcode
- A physical device or emulator (with GPS mock location support for testing geofencing)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/fleet-driver.git
cd fleet-driver

# 2. Install dependencies
flutter pub get

# 3. Generate Hive adapters (if models were modified)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Test Credentials (Mock Backend)

| Role   | Email              | Password |
|--------|---------------------|----------|
| Driver | driver1@test.com    | 123456   |
| Admin  | admin@test.com      | 123456   |

> ⚠️ These are mock credentials for demo/testing purposes only — no real backend is connected.

---

## 📱 Screenshots

<p align="center">
  <img src="screenshots/1.png" width="200"/>
  <img src="screenshots/2.png" width="200"/>
  <img src="screenshots/3.png" width="200"/>
</p>
<p align="center">
  <img src="screenshots/4.png" width="200"/>
  <img src="screenshots/5.png" width="200"/>
  <img src="screenshots/6.png" width="200"/>
</p>

> 📌 Place your 6 screenshots inside a `screenshots/` folder in the repo root, named `1.png` through `6.png` (or update the paths above to match your file names).

---

## 🧪 Testing the Offline Flow (for the Demo)

1. Log in as a driver and start a route.
2. Turn off device connectivity (airplane mode).
3. Log free seats at a station — the entry is saved locally (Hive) with `synced: false`.
4. Re-enable connectivity.
5. Watch the background sync queue automatically push the pending log and mark it `synced: true`.

## 🧪 Testing Real-Time Updates & Reconnection

1. Start a route to trigger the socket `connecting → connected` states.
2. Wait for randomized live events (congestion, delay, station closed) to appear.
3. Disable connectivity mid-trip to observe the `disconnected` state and automatic reconnect with exponential backoff once connectivity returns.

---

## 📌 Notes & Possible Improvements

- Replace the mock database / simulated socket service with a real REST API and WebSocket backend.
- Add unit and widget tests for Cubits and repositories.
- Add a real map view (e.g., `google_maps_flutter`) for route visualization instead of a station list.
- Add push notifications for critical live updates (station closures, major delays).

---

## 👤 Author

Built as part of a technical assessment task — *Fleet Driver Mobile Application (Flutter)*.

<p align="center">Made with ❤️ using Flutter</p>
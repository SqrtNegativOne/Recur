# Recur

A Routinery-inspired checklist timer app for **Windows** and **Android**. Create timed routines, run them step-by-step with a countdown ring, and keep your files synced via Syncthing.

## Features

- **Checklists** — Create routines with a name, description, color, and icon
- **Tasks** — Add time-boxed tasks to each checklist; drag to reorder
- **Timer/Runner** — Real-time countdown per task with a circular progress ring
- **Auto-advance** — Optionally move to the next task automatically after a configurable delay
- **Controls** — Pause, resume, skip, or stop a run at any time
- **Wakelock** — Screen stays on during active runs
- **File-based storage** — Each checklist is a JSON file; point the app at any folder (e.g. a Syncthing-shared directory)
- **Syncthing-aware** — Conflict files are filtered out when loading
- **Theming** — Light, dark, or system theme

## Platforms

| Platform | Status |
|----------|--------|
| Windows  | ✅ Primary target |
| Android  | ✅ Supported |

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.7.0 (Dart SDK ≥ 3.7.0)
- For Windows builds: Visual Studio with "Desktop development with C++" workload

### Install dependencies

```powershell
flutter pub get
```

### Run code generation (required after modifying models/providers)

```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Launch

```powershell
# Windows (no code generation)
./run.ps1
# or
flutter run -d windows

# Windows (with code generation first)
./buildrun.ps1

# Android
flutter run -d android
```

### Build release

```powershell
# Windows
flutter build windows --release

# Android APK
flutter build apk --release
```

## Project Structure

```
lib/
├── main.dart                    # App entry point (ProviderScope)
├── app.dart                     # Root widget (MaterialApp + GoRouter + theming)
├── core/
│   ├── router/app_router.dart   # GoRouter route definitions
│   ├── theme/app_theme.dart     # Material 3 light/dark themes
│   └── utils/
│       ├── duration_formatter.dart  # MM:SS and human-readable formatters
│       └── slug_utils.dart          # Filename slug generation
└── features/
    ├── checklist/               # Checklist & task management
    │   ├── data/
    │   │   ├── models/          # Freezed immutable models (+ generated files)
    │   │   └── repositories/    # JSON file I/O, folder watching
    │   ├── presentation/
    │   │   ├── screens/         # List, detail, checklist form, task form
    │   │   └── widgets/         # ChecklistCard, TaskTile, DurationPicker
    │   └── providers/           # Riverpod providers (list & detail)
    ├── runner/                  # Timer execution engine
    │   ├── data/models/         # RunState (state machine) + RunPhase enum
    │   ├── presentation/
    │   │   ├── screens/         # RunScreen, RunCompleteScreen
    │   │   └── widgets/         # CountdownRing, RunControls, TaskProgressBar
    │   └── providers/           # RunSessionNotifier (timer logic)
    └── settings/                # App configuration
        ├── data/
        │   ├── models/          # AppSettings (theme, storage path)
        │   └── repositories/    # SharedPreferences persistence
        ├── presentation/screens/ # SettingsScreen
        └── providers/           # SettingsNotifier, StoragePathProvider
```

## Architecture

- **Data layer** — Freezed models, JSON repositories, SharedPreferences
- **Presentation layer** — Screens and widgets
- **State layer** — Riverpod `AsyncNotifier` / `Notifier` providers

**Key libraries:**

| Library | Role |
|---------|------|
| `flutter_riverpod` + `riverpod_annotation` | State management |
| `freezed` + `json_serializable` | Immutable models & JSON codegen |
| `go_router` | Declarative navigation |
| `path_provider` | Platform document directory |
| `file_picker` | Storage folder selection |
| `shared_preferences` | Settings persistence |
| `wakelock_plus` | Prevent screen sleep during runs |

## Storage

By default, checklists are saved to `Documents/Recur/checklists/`. You can change this in **Settings** to any folder — useful for pointing at a Syncthing-shared directory.

Each checklist is stored as a JSON file named `<slug>_<id-prefix>.json` (e.g. `morning-routine_a1b2c3.json`).

## Code Generation

This project uses `build_runner` to generate:
- `.freezed.dart` — Immutable class boilerplate (copyWith, equality, pattern matching)
- `.g.dart` — JSON serialization and Riverpod provider boilerplate

Run after any change to annotated model or provider files:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Use `watch` instead of `build` during active development:

```powershell
dart run build_runner watch --delete-conflicting-outputs
```

# Recur — Claude Code Context

Routinery-inspired checklist timer app. Flutter, targets Windows (primary) and Android.

## Build & Run

```powershell
# Install deps
flutter pub get

# Code generation (required after modifying models or providers)
dart run build_runner build --delete-conflicting-outputs

# Run on Windows
flutter run -d windows          # or: ./run.ps1
./buildrun.ps1                  # codegen + run in one step

# Run on Android
flutter run -d android

# Build release
flutter build windows --release
flutter build apk --release
```

## Code Generation — Critical Rule

**Always run `build_runner` after modifying:**
- Any file annotated with `@freezed`, `@JsonSerializable`
- Any Riverpod provider using `@riverpod`

Generated files follow the pattern:
- `foo.freezed.dart` — immutable class boilerplate
- `foo.g.dart` — JSON / Riverpod codegen

Do **not** manually edit `*.freezed.dart` or `*.g.dart` files.

## Architecture

Feature-based clean architecture: `lib/features/{checklist,runner,settings}/`

Each feature has three layers:
```
data/
  models/       ← Freezed immutable data classes
  repositories/ ← File I/O or SharedPreferences
presentation/
  screens/      ← Full-page UI
  widgets/      ← Reusable UI components
providers/      ← Riverpod state (AsyncNotifier / Notifier)
```

Cross-cutting concerns live in `lib/core/`:
- `router/app_router.dart` — GoRouter configuration (8 routes)
- `theme/app_theme.dart` — Material 3 light/dark themes
- `utils/` — Duration formatter, slug generator

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point, wraps with `ProviderScope` |
| `lib/app.dart` | Root widget, wires theme + router |
| `lib/core/router/app_router.dart` | All route definitions |
| `lib/features/checklist/data/repositories/checklist_repository.dart` | JSON file I/O, folder watching, Syncthing conflict filtering |
| `lib/features/checklist/providers/checklist_list_provider.dart` | Master list state, file-watch auto-reload |
| `lib/features/runner/providers/run_session_provider.dart` | Timer state machine (start/pause/resume/skip/stop) |
| `lib/features/runner/data/models/run_state.dart` | `RunState` + `RunPhase` enum |
| `lib/features/settings/providers/storage_path_provider.dart` | Resolves storage directory (custom or Documents/Recur/checklists/) |

## State Management

Riverpod with code generation. Provider types used:
- `AsyncNotifier` — async state with loading/error (checklists, settings)
- `Notifier` — synchronous state machine (runner)
- `FutureProvider.family` — loading a single checklist by ID

## Data Models

All models are **Freezed + JSON-serializable**. Key models:

- `ChecklistModel` — id, name, description, color, icon, tasks, settings, timestamps
  - Computed: `fileName` (slug + id prefix), `totalDuration`
- `TaskModel` — id, name, description, durationSeconds, icon
- `ChecklistSettings` — autoAdvance bool, delaySeconds
- `RunState` — checklist, taskIndex, elapsedSeconds, phase
  - Computed: currentTask, remainingSeconds, progress (0–1), isOvertime
- `AppSettings` — storageFolderPath, themeMode

## Navigation (GoRouter)

Routes defined in `app_router.dart`:
- `/` — Checklist list (home)
- `/create` — New checklist form
- `/:id` — Checklist detail
- `/:id/edit` — Edit checklist
- `/:id/run` — Run screen (timer)
- `/:id/complete` — Run complete screen
- `/settings` — App settings

## Storage

Checklists are JSON files on disk. Default path: `Documents/Recur/checklists/`
Configurable via Settings → custom folder (e.g. for Syncthing sync).
Filename format: `<slug>_<6-char-id-prefix>.json`
Syncthing `.sync-conflict-*` files are filtered out when loading.

## Conventions

- Prefer `const` constructors everywhere possible
- Use `ref.watch` in build, `ref.read` in callbacks
- Navigate via `GoRouter` (never `Navigator.push` directly)
- Checklist mutations: load → modify → save via repository → invalidate provider
- The runner screen disables the back button (shows confirmation dialog instead)

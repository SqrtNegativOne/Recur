# Recur — Agent Instructions

Routinery-inspired checklist timer app. Flutter, targets Windows (primary) and Android.

## Build & Run

```powershell
# Install deps
flutter pub get

# Code generation (required after modifying models or providers)
dart run build_runner build --delete-conflicting-outputs

# Run on Windows
flutter run -d windows

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
  repositories/ ← File I/O (checklists, run history) or SharedPreferences (settings)
presentation/
  screens/      ← Full-page UI
  widgets/      ← Reusable UI components
providers/      ← Riverpod state (AsyncNotifier / Notifier)
```

Cross-cutting concerns live in `lib/core/`:
- `router/app_router.dart` — GoRouter configuration (12 routes)
- `theme/app_theme.dart` — Material 3 light/dark themes
- `providers/time_theme_provider.dart` — time-based theme (light 06:00–18:00)
- `services/audio_service.dart` — timer chime (generated WAV) + TTS prompts
- `services/overlay_service.dart` — Android floating-timer overlay bridge
- `overlay/overlay_main.dart` — overlay isolate entry point (separate `@pragma('vm:entry-point')`)
- `utils/` — duration formatter, slug generator, logger, Android all-files-access helper

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point; window_manager setup (desktop close interception), global error logging, `ProviderScope` |
| `lib/app.dart` | Root widget, wires theme + router |
| `lib/core/router/app_router.dart` | All route definitions + Tasker deep-link redirect |
| `lib/features/checklist/data/repositories/checklist_repository.dart` | JSON file I/O, folder watching, Syncthing conflict filtering, import, stale-filename cleanup |
| `lib/features/checklist/providers/checklist_list_provider.dart` | Master list state, file-watch auto-reload |
| `lib/features/checklist/providers/checklist_detail_provider.dart` | Single checklist by ID (`FutureProvider.family`) |
| `lib/features/runner/providers/run_session_provider.dart` | Timer state machine (start/pause/resume/skip/stop), audio + overlay + history integration |
| `lib/features/runner/data/models/run_state.dart` | `RunState` + `RunPhase` enum |
| `lib/features/runner/data/models/run_record.dart` | Completed-run record (actual vs. planned per task) |
| `lib/features/runner/data/repositories/run_history_repository.dart` | Run history JSON in app support dir (NOT the checklists folder) |
| `lib/features/settings/data/repositories/settings_repository.dart` | SharedPreferences-backed settings I/O |
| `lib/features/settings/providers/storage_path_provider.dart` | Resolves storage directory (custom or Documents/Recur/checklists/) |

## State Management

Riverpod with code generation. Provider types used:
- `AsyncNotifier` — async state with loading/error (checklists, settings)
- `Notifier` — synchronous state machine (runner)
- `FutureProvider.family` — loading a single checklist by ID

## Data Models

All models are **Freezed + JSON-serializable**. Key models:

- `ChecklistModel` — id, name, createdAt, updatedAt, version, description, color, icon, tasks, settings
  - Computed: `fileName` (slug + 8-char id prefix), `totalDuration`
- `TaskModel` — id, name, description, durationSeconds, icon
- `ChecklistSettings` — autoAdvance bool, autoAdvanceDelaySeconds int
- `RunState` — checklist, currentTaskIndex, elapsedSeconds, phase, startedAt, taskElapsedTimes
  - Computed: currentTask, remainingSeconds, progress (0–1), isOvertime, completedTaskCount, totalTaskCount
- `RunRecord` — id, checklistId/Name, startedAt, completedAt, taskCount, taskActualSeconds, taskPlannedSeconds, taskNames
- `AppSettings` — storageFolderPath, themeMode, soundEnabled, ttsEnabled

## Navigation (GoRouter)

Routes defined in `app_router.dart`:
- `/` — Checklist list (home)
- `/run/:id` — redirect to `/checklist/:id/run` (Tasker deep link: `recur:///run/<id>`)
- `/checklist/new` — New checklist form
- `/checklist/:id` — Checklist detail
- `/checklist/:id/edit` — Edit checklist
- `/checklist/:id/task/new` — New task form
- `/checklist/:id/task/:tid/edit` — Edit task form
- `/checklist/:id/run` — Run screen (timer)
- `/checklist/:id/run/complete` — Run complete screen
- `/history` — Run history (all checklists)
- `/checklist/:id/history` — Run history (filtered, checklist name via query param)
- `/settings` — App settings

## Storage

Checklists are JSON files on disk. Default path: `Documents/Recur/checklists/`
Configurable via Settings → custom folder (e.g. for Syncthing sync).
Filename format: `<slug>_<8-char-id-prefix>.json`
Syncthing `.sync-conflict-*` files are filtered out when loading.
Renaming a checklist cleans up old files with the same ID.
On Android, shared-storage folders need the "All files access" flow
(`lib/core/utils/storage_access.dart`) to see synced files.

Run history is stored separately at `getApplicationSupportDirectory()/run_history.json`
so it never lands in the synced checklists folder.

## Cross-Feature Integrations

- **Audio** (`AudioService`): plays a generated two-tone chime when a task timer expires;
  TTS speaks task prompts and completion messages. Both gated by settings
  (`soundEnabled`, `ttsEnabled`).
- **Android overlay** (`OverlayService`): floating always-on-top timer widget in a
  separate isolate; the run session relays timer state to it. No-op on other platforms.
- **Run history**: on `allComplete`, the run session saves a `RunRecord` and the
  history provider reloads.
- **Window management** (desktop, `window_manager`): close is intercepted to
  `windowManager.destroy() + exit(0)` to avoid plugin teardown bugs.

## Conventions

- Prefer `const` constructors everywhere possible
- Use `ref.watch` in build, `ref.read` in callbacks
- Navigate via `GoRouter` (never `Navigator.push` directly)
- Checklist mutations: load → modify → save via repository → invalidate provider
- The runner screen disables the back button (`PopScope(canPop: false)` shows a stop confirmation dialog instead)
- Use the shared `logger` (`lib/core/utils/logger.dart`) for diagnostics; `main.dart` installs global `FlutterError`/`PlatformDispatcher` handlers

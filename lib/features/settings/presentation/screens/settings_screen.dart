import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recur/core/utils/storage_access.dart';
import 'package:recur/features/checklist/providers/checklist_list_provider.dart';
import 'package:recur/features/settings/providers/settings_provider.dart';
import 'package:recur/features/settings/providers/storage_path_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (settings) {
          return ListView(
            children: [
              // Storage folder
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Storage Folder'),
                subtitle: FutureBuilder(
                  future: resolveStorageDirectory(settings.storageFolderPath),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return Text(
                        snap.data!.path,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    return const Text('Loading...');
                  },
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pickStorageFolder(context, ref),
              ),
              // Scoped storage: only relevant when a custom folder in
              // shared storage (e.g. a Syncthing sync target) is set.
              if (Platform.isAndroid &&
                  StorageAccess.needsAllFilesAccess(settings.storageFolderPath))
                const _StorageAccessTile(),
              const Divider(),
              // Theme mode
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                trailing: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Auto'),
                      icon: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (modes) {
                    unawaited(
                      ref
                          .read(settingsProvider.notifier)
                          .setThemeMode(modes.first),
                    );
                  },
                ),
              ),
              const Divider(),
              // Sound effects toggle
              SwitchListTile(
                secondary: const Icon(Icons.volume_up_outlined),
                title: const Text('Timer Sound'),
                subtitle: const Text('Play a chime when a task timer expires'),
                value: settings.soundEnabled,
                onChanged: (value) {
                  unawaited(
                    ref
                        .read(settingsProvider.notifier)
                        .setSoundEnabled(enabled: value),
                  );
                },
              ),
              const Divider(),
              // TTS toggle
              SwitchListTile(
                secondary: const Icon(Icons.record_voice_over_outlined),
                title: const Text('Voice Prompts'),
                subtitle: const Text(
                  'Announce each task with "Get X done in Y"',
                ),
                value: settings.ttsEnabled,
                onChanged: (value) {
                  unawaited(
                    ref
                        .read(settingsProvider.notifier)
                        .setTtsEnabled(enabled: value),
                  );
                },
              ),
              const Divider(),
              // Reset storage path
              if (settings.storageFolderPath.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('Reset to Default Storage'),
                  subtitle: const Text('Use Documents/Recur/checklists/'),
                  onTap: () async {
                    await ref
                        .read(settingsProvider.notifier)
                        .setStoragePath('');
                    ref.invalidate(checklistListProvider);
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickStorageFolder(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await FilePicker.getDirectoryPath(
      dialogTitle: 'Choose storage folder for checklists',
    );
    if (result != null) {
      await ref.read(settingsProvider.notifier).setStoragePath(result);
      ref.invalidate(checklistListProvider);
      if (StorageAccess.needsAllFilesAccess(result) &&
          !await StorageAccess.isGranted()) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 6),
              content: Text(
                'This folder is in shared storage. Grant "All files access" '
                'in Settings (below Storage Folder) to see checklists synced '
                'here, e.g. via Syncthing.',
              ),
            ),
          );
      }
    }
  }
}

/// Shows the Android "All files access" grant state for the current
/// shared-storage folder and opens the system screen when tapped.
class _StorageAccessTile extends ConsumerStatefulWidget {
  const _StorageAccessTile();

  @override
  ConsumerState<_StorageAccessTile> createState() => _StorageAccessTileState();
}

class _StorageAccessTileState extends ConsumerState<_StorageAccessTile> {
  bool? _granted;

  @override
  void initState() {
    super.initState();
    unawaited(StorageAccess.isGranted().then(
      (granted) {
        if (mounted) setState(() => _granted = granted);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final granted = _granted ?? false;
    return ListTile(
      leading: Icon(granted ? Icons.lock_open : Icons.lock_outline),
      title: const Text('All files access'),
      subtitle: Text(
        granted
            ? 'Granted. Files synced into this folder are visible.'
            : 'Required on Android 11+ to see checklists synced into this '
                'folder (e.g. via Syncthing). Tap to grant.',
      ),
      trailing: !granted ? const Icon(Icons.chevron_right) : null,
      enabled: !granted,
      onTap: granted
          ? null
          : () async {
              final nowGranted = await StorageAccess.request();
              if (!mounted) return;
              setState(() => _granted = nowGranted);
              if (nowGranted) {
                ref.invalidate(checklistListProvider);
              }
            },
    );
  }
}

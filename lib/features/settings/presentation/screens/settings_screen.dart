import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:recur/features/settings/providers/settings_provider.dart';
import 'package:recur/features/settings/providers/storage_path_provider.dart';
import 'package:recur/features/checklist/providers/checklist_list_provider.dart';

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
              const Divider(),
              // Theme mode
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                trailing: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
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
                    ref
                        .read(settingsProvider.notifier)
                        .setThemeMode(modes.first);
                  },
                ),
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
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choose storage folder for checklists',
    );
    if (result != null) {
      await ref.read(settingsProvider.notifier).setStoragePath(result);
      ref.invalidate(checklistListProvider);
    }
  }
}

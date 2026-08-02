import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/theme_mode_provider.dart';
import '../../downloads/domain/models/download_models.dart';
import '../../downloads/domain/providers/download_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: textTheme.headlineMedium),
              const SizedBox(height: 28),
              const _SettingsSection(
                title: 'Global',
                child: _ThemeModeSetting(),
              ),
              const SizedBox(height: 28),
              const _SettingsSection(
                title: 'Downloads',
                child: _DownloadSettings(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadSettings extends ConsumerWidget {
  const _DownloadSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(downloadSettingsProvider)
        .when(
          data: (settings) => _DownloadSettingsForm(
            key: ValueKey(
              Object.hash(
                settings.endpoint,
                settings.apiKey,
                settings.seriesRoot,
                settings.moviesRoot,
                settings.checkIntervalMinutes,
                settings.startAtLogin,
              ),
            ),
            initialSettings: settings,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text('Could not load settings: $error'),
        );
  }
}

class _DownloadSettingsForm extends ConsumerStatefulWidget {
  const _DownloadSettingsForm({required this.initialSettings, super.key});

  final DownloadSettings initialSettings;

  @override
  ConsumerState<_DownloadSettingsForm> createState() =>
      _DownloadSettingsFormState();
}

class _DownloadSettingsFormState extends ConsumerState<_DownloadSettingsForm> {
  late final TextEditingController _endpoint;
  late final TextEditingController _apiKey;
  late final TextEditingController _seriesRoot;
  late final TextEditingController _moviesRoot;
  late final TextEditingController _interval;
  late bool _startAtLogin;
  var _obscureApiKey = true;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    final settings = widget.initialSettings;
    _endpoint = TextEditingController(text: settings.endpoint);
    _apiKey = TextEditingController(text: settings.apiKey);
    _seriesRoot = TextEditingController(text: settings.seriesRoot);
    _moviesRoot = TextEditingController(text: settings.moviesRoot);
    _interval = TextEditingController(
      text: settings.checkIntervalMinutes.toString(),
    );
    _startAtLogin = settings.startAtLogin;
  }

  @override
  void dispose() {
    _endpoint.dispose();
    _apiKey.dispose();
    _seriesRoot.dispose();
    _moviesRoot.dispose();
    _interval.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _endpoint,
          decoration: const InputDecoration(
            labelText: 'qBittorrent endpoint',
            hintText: 'https://server.example:8080',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _apiKey,
          obscureText: _obscureApiKey,
          decoration: InputDecoration(
            labelText: 'API key (qBittorrent 5.2+)',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              tooltip: _obscureApiKey ? 'Show API key' : 'Hide API key',
              onPressed: () {
                setState(() => _obscureApiKey = !_obscureApiKey);
              },
              icon: Icon(
                _obscureApiKey
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final fields = [
              TextField(
                controller: _seriesRoot,
                decoration: const InputDecoration(
                  labelText: 'Series root on server',
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: _moviesRoot,
                decoration: const InputDecoration(
                  labelText: 'Movies root on server',
                  border: OutlineInputBorder(),
                ),
              ),
            ];
            if (constraints.maxWidth < 580) {
              return Column(
                children: [fields[0], const SizedBox(height: 12), fields[1]],
              );
            }
            return Row(
              children: [
                Expanded(child: fields[0]),
                const SizedBox(width: 12),
                Expanded(child: fields[1]),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 240,
          child: TextField(
            controller: _interval,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Check interval (minutes)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _startAtLogin,
          onChanged: (value) => setState(() => _startAtLogin = value),
          title: const Text('Start at login'),
          subtitle: const Text(
            'Keep future-episode checks running from the desktop tray.',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save'),
            ),
            OutlinedButton.icon(
              onPressed: _busy ? null : _testConnection,
              icon: const Icon(Icons.cable_rounded),
              label: const Text('Test connection'),
            ),
          ],
        ),
      ],
    );
  }

  DownloadSettings _settings() {
    final interval = int.tryParse(_interval.text.trim()) ?? 30;
    return DownloadSettings(
      endpoint: _endpoint.text.trim(),
      apiKey: _apiKey.text.trim(),
      seriesRoot: _seriesRoot.text.trim(),
      moviesRoot: _moviesRoot.text.trim(),
      checkIntervalMinutes: interval.clamp(15, 1440),
      startAtLogin: _startAtLogin,
    );
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await ref.read(downloadSettingsControllerProvider).save(_settings());
      if (mounted) {
        _showMessage('Download settings saved.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _testConnection() async {
    setState(() => _busy = true);
    try {
      final info = await ref
          .read(downloadSettingsControllerProvider)
          .testConnection(_settings());
      if (mounted) {
        _showMessage(
          'Connected to ${info.applicationVersion} (Web API ${info.webApiVersion}).',
        );
      }
    } catch (error) {
      if (mounted) {
        _showMessage('$error');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(padding: const EdgeInsets.all(20), child: child),
        ),
      ],
    );
  }
}

class _ThemeModeSetting extends ConsumerWidget {
  const _ThemeModeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Row(
      children: [
        const Expanded(
          child: Text('Theme', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<ThemeMode>(
            initialValue: themeMode,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            items: const [
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }

              ref.read(themeModeProvider.notifier).setThemeMode(value);
            },
          ),
        ),
      ],
    );
  }
}

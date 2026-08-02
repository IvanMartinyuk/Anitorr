import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:window_manager/window_manager.dart';

import '../features/downloads/domain/models/download_models.dart';
import '../features/downloads/domain/providers/download_providers.dart';
import '../features/downloads/domain/services/download_coordinator.dart';

class DesktopBackgroundHost extends ConsumerStatefulWidget {
  const DesktopBackgroundHost({
    required this.child,
    this.startHidden = false,
    super.key,
  });

  final Widget child;
  final bool startHidden;

  @override
  ConsumerState<DesktopBackgroundHost> createState() =>
      _DesktopBackgroundHostState();
}

class _DesktopBackgroundHostState extends ConsumerState<DesktopBackgroundHost>
    with WindowListener, tray.TrayListener, WidgetsBindingObserver {
  late final DownloadScheduler _scheduler;
  ProviderSubscription<AsyncValue<DownloadSettings>>? _settingsSubscription;
  DownloadSettings _settings = const DownloadSettings();
  var _automationPaused = false;

  @override
  void initState() {
    super.initState();
    _scheduler = DownloadScheduler(ref.read(downloadCoordinatorProvider));
    windowManager.addListener(this);
    tray.trayManager.addListener(this);
    WidgetsBinding.instance.addObserver(this);
    _settingsSubscription = ref.listenManual(downloadSettingsProvider, (
      previous,
      next,
    ) {
      next.whenData((settings) {
        _settings = settings;
        if (!_automationPaused) {
          _scheduler.start(Duration(minutes: settings.checkIntervalMinutes));
        }
      });
    }, fireImmediately: true);
    _initializeTray();
  }

  Future<void> _initializeTray() async {
    final executableDirectory = path.dirname(Platform.resolvedExecutable);
    final asset = Platform.isWindows
        ? 'windows/runner/resources/app_icon.ico'
        : 'docs/design/assets/images/logo.png';
    await tray.trayManager.setIcon(
      path.join(executableDirectory, 'data', 'flutter_assets', asset),
    );
    await _updateTrayMenu();
    if (Platform.isWindows) {
      await tray.trayManager.setToolTip('Anitorr');
    }

    if (widget.startHidden) {
      await windowManager.hide();
    }
  }

  Future<void> _updateTrayMenu() {
    return tray.trayManager.setContextMenu(
      tray.Menu(
        items: [
          tray.MenuItem(key: 'open', label: 'Open Anitorr'),
          tray.MenuItem(
            key: 'pause',
            label: _automationPaused ? 'Resume automation' : 'Pause automation',
          ),
          tray.MenuItem(key: 'check', label: 'Check now'),
          tray.MenuItem.separator(),
          tray.MenuItem(key: 'exit', label: 'Exit'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _settingsSubscription?.close();
    _scheduler.stop();
    windowManager.removeListener(this);
    tray.trayManager.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  Future<void> onWindowClose() => windowManager.hide();

  @override
  void onTrayIconMouseDown() {
    _showWindow();
  }

  @override
  void onTrayIconRightMouseDown() {
    if (Platform.isWindows) {
      tray.trayManager.popUpContextMenu();
    }
  }

  @override
  void onTrayMenuItemClick(tray.MenuItem menuItem) {
    switch (menuItem.key) {
      case 'open':
        _showWindow();
      case 'pause':
        _automationPaused = !_automationPaused;
        if (_automationPaused) {
          _scheduler.stop();
        } else {
          _scheduler.start(Duration(minutes: _settings.checkIntervalMinutes));
        }
        _updateTrayMenu();
      case 'check':
        ref.read(downloadCoordinatorProvider).checkNow();
      case 'exit':
        _exit();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_automationPaused) {
      ref.read(downloadCoordinatorProvider).checkNow();
    }
  }

  Future<void> _showWindow() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _exit() async {
    _scheduler.stop();
    await tray.trayManager.destroy();
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
  }
}

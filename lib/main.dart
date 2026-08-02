import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'app/desktop_background_host.dart';

Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  final desktop = Platform.isLinux || Platform.isWindows;
  if (desktop) {
    await windowManager.ensureInitialized();
    await windowManager.setPreventClose(true);
  }
  runApp(
    ProviderScope(
      child: desktop
          ? DesktopBackgroundHost(
              startHidden: arguments.contains('--background'),
              child: const AnitorrApp(),
            )
          : const AnitorrApp(),
    ),
  );
}

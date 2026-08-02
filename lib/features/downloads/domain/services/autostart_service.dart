import 'dart:io';

import 'package:path/path.dart' as path;

final class AutostartService {
  const AutostartService();

  Future<void> setEnabled(bool enabled) async {
    if (Platform.isWindows) {
      await _setWindows(enabled);
    } else if (Platform.isLinux) {
      await _setLinux(enabled);
    }
  }

  Future<void> _setWindows(bool enabled) async {
    final arguments = enabled
        ? [
            'add',
            r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
            '/v',
            'Anitorr',
            '/t',
            'REG_SZ',
            '/d',
            '"${Platform.resolvedExecutable}" --background',
            '/f',
          ]
        : [
            'delete',
            r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
            '/v',
            'Anitorr',
            '/f',
          ];
    final result = await Process.run('reg', arguments);
    if (result.exitCode != 0 && enabled) {
      throw FileSystemException('Could not configure Windows startup.');
    }
  }

  Future<void> _setLinux(bool enabled) async {
    final configHome = Platform.environment['XDG_CONFIG_HOME'];
    final home = Platform.environment['HOME'];
    if ((configHome == null || configHome.isEmpty) &&
        (home == null || home.isEmpty)) {
      throw const FileSystemException('Could not locate the config folder.');
    }
    final directory = Directory(
      configHome?.isNotEmpty == true
          ? path.join(configHome!, 'autostart')
          : path.join(home!, '.config', 'autostart'),
    );
    final file = File(path.join(directory.path, 'anitorr.desktop'));
    if (!enabled) {
      if (await file.exists()) {
        await file.delete();
      }
      return;
    }

    await directory.create(recursive: true);
    final executable = Platform.resolvedExecutable.replaceAll('"', r'\"');
    await file.writeAsString(
      '[Desktop Entry]\n'
      'Type=Application\n'
      'Name=Anitorr\n'
      'Exec="$executable" --background\n'
      'Terminal=false\n'
      'X-GNOME-Autostart-enabled=true\n',
    );
  }
}

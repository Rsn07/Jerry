import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static Future<String> _projectsDir() async {
    final d = await getApplicationDocumentsDirectory();
    final dir = Directory('\${d.path}/jerry_projects');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir.path;
  }

  static Future<String> saveProject(String name, Map<String, String> files) async {
    final base = await _projectsDir();
    final dir = Directory('\$base/\$name');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    for (final e in files.entries) {
      final f = File('\${dir.path}/\${e.key}');
      await f.writeAsString(e.value);
    }
    return dir.path;
  }
}

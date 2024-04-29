import 'dart:io';
import 'package:path_provider/path_provider.dart';

sealed class PathProviderService {
  static late Directory _directory;
  static late File _file;

  static Future<String> get _getLocation async {
    _directory = await getApplicationDocumentsDirectory();
    return _directory.path;
  }

  static String readFile(String path) => File(path).readAsStringSync();

  static void deleteFile(String path) => File(path).deleteSync();

  static Future<void> createFile({required PathProviderKey key, required String text}) async {
    final String path = await _getLocation;
    _file = File("$path/${DateTime.now().toIso8601String()}${key.name}.txt");
    await _file.writeAsString(text);
  }

  static Future<void> updateFile({required String path, required String text}) async {
    _file = File(path);
    await _file.writeAsString(text);
  }

  static Future<List<String>> getAllFiles(PathProviderKey key) async {
    List<String> filesPath = [];
    await _getLocation;
    Stream<FileSystemEntity> files = _directory.list();

    await for(FileSystemEntity s in files){
      if(s.path.endsWith('${key.name}.txt')){
        filesPath.add(s.path);
      }
    }
    return filesPath;
  }
}

enum PathProviderKey {
  contacts,
  last
}

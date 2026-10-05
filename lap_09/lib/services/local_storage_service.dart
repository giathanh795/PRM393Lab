import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  /// Get local file handle in application documents directory
  static Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  /// Read JSON list from a local file
  static Future<List<dynamic>> readJson(String fileName) async {
    try {
      final file = await _getLocalFile(fileName);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      if (contents.trim().isEmpty) {
        return [];
      }
      return json.decode(contents) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  /// Write List of JSON objects to a local file
  static Future<void> writeJson(String fileName, List<Map<String, dynamic>> data) async {
    try {
      final file = await _getLocalFile(fileName);
      final jsonString = json.encode(data);
      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Failed to write JSON to storage: $e');
    }
  }
}

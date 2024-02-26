import 'dart:async';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Future<Box>? _box;

  DatabaseHelper._internal();

  Future<Box> get _database async {
    if (_box != null) {
      return _box!;
    }

    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    _box = Hive.openBox('weather');
    return _box!;
  }

  Future<void> saveLastWeather(double temperature, int humidity, int pressure, String description, int weatherId) async {
    final box = await _database;
    await box.put('lastWeather', {
      'temperature': temperature,
      'humidity': humidity,
      'pressure': pressure,
      'description': description,
      'weatherId': weatherId,
    });
  }

  Future<Map<String, dynamic>> getLastWeather() async {
    final box = await _database;
    final lastWeather = box.get('lastWeather');
    return lastWeather ?? {};
  }
}

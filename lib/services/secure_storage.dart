import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage(this.storage);

  final FlutterSecureStorage storage;

  Future<String?> getValue(String key) => storage.read(key: key);

  Future<Map<String, String>> get allValues => storage.readAll();

  Future<void> deleteValue(String key) {
    return storage.delete(key: key);
  }

  Future<void> get deleteAll => storage.deleteAll();

  Future<void> writeValue(String key, String value) {
    return storage.write(key: key, value: value);
  }
}

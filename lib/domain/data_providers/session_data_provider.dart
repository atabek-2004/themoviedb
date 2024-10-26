import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionKey = 'session_key';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> getSessionId() => _secureStorage.read(key: _Keys.sessionKey);

  Future<void> setSessionId(String? value) async {
    if (value != null) {
      await _secureStorage.write(key: _Keys.sessionKey, value: value);
    } else {
      await _secureStorage.delete(key: _Keys.sessionKey);
    }
  }
}

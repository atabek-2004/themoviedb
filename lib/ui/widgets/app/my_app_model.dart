import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

class MyAppModel {
  final _sessionId = SessionDataProvider();

  bool _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await _sessionId.getSessionId();
    if (sessionId != null) {
      _isAuth = true;
    } else {
      _isAuth = false;
    }
  }
}
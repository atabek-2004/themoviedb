import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigations/main_navigation.dart';

class AuthWidgetModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  final textNameController = TextEditingController();
  final passwordNameController = TextEditingController();
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool _isAuth = false;
  bool? get canAuth => !_isAuth;
  bool get isAuth => _isAuth;

  Future<void> showMainScreen(BuildContext context) async {
    final login = textNameController.text;
    final password = passwordNameController.text;
    _isAuth = true;
    notifyListeners();
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      _isAuth = false;
      notifyListeners();
      return;
    }
    String? sessionId;
    try {
      sessionId = await _apiClient.auth(username: login, password: password);
      await _sessionDataProvider.setSessionId(sessionId);
      _errorMessage = null;
      notifyListeners();
    } on ApiClientExeption catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          _errorMessage =
              'Нед доступа к интернету. Пожалуйста проверьте подключение к интернету.';
        case ApiClientExceptionType.auth:
          _errorMessage = 'Неправильный логин пароль!';

        case ApiClientExceptionType.other:
          _errorMessage = 'Произошло ошибка, попробуйте позже!';
      }
      _isAuth = false;
      notifyListeners();
      return;
    }

    _isAuth = false;
    Navigator.of(context).pushNamed(MainNavigationRouteNames.mainScreen);

    notifyListeners();
  }
}

class AuthWidgetModelProvider extends InheritedNotifier {
  final AuthWidgetModel model;
  const AuthWidgetModelProvider(
      {super.key, required super.child, required this.model})
      : super(notifier: model);

  static AuthWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthWidgetModelProvider>();
  }

  static AuthWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<AuthWidgetModelProvider>()
        ?.widget;
    return widget is AuthWidgetModelProvider ? widget : null;
  }
}

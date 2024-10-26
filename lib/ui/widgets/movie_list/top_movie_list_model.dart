import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/topmovie.dart';
import 'package:themoviedb/domain/entity/topmovie_response.dart';
import 'package:themoviedb/ui/navigations/main_navigation.dart';

class TopMovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  var _listTopMovies = <TopMovie>[];
  List<TopMovie> get listTopMovies => _listTopMovies;
  late DateFormat _dateFormat;
  String _locale = '';
  late int _currentPage;
  late int _totalPage;
  bool _isActivateTotal = false;
  String? _searchQuery;
  Timer? _timer;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetListMovie();
  }

  Future<void> _resetListMovie() async {
    _currentPage = 0;
    _totalPage = 1;
    _listTopMovies.clear();
    await _loadNextPage();
  }

  String stringRelaseDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<TopmovieResponse> _loadTopMovies(int page, String locale) async {
    final query = _searchQuery;
    if (query != null) {
      return await _apiClient.searchTopMovies(page, locale, query);
    } else {
      return await _apiClient.topReatedMovies(page, locale);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isActivateTotal || _currentPage >= _totalPage) return;
    final nextPage = _currentPage + 1;
    _isActivateTotal = true;

    try {
      final responseMovies = await _loadTopMovies(nextPage, _locale);
      _listTopMovies.addAll(responseMovies.movies);

      _currentPage = responseMovies.page;
      _totalPage = responseMovies.totalPages;
      _isActivateTotal = false;

      notifyListeners();
    } catch (e) {
      _isActivateTotal = false;
    }
  }

  void showedTopMovieAtIndex(int index) {
    if (index < _listTopMovies.length - 1) return;
    _loadNextPage();
  }

  Future<void> searchTopMovie(String text) async {
    _timer?.cancel();
    _timer = Timer(const Duration(microseconds: 300), () async {
      _searchQuery = text.isNotEmpty ? text : null;
      await _resetListMovie();
    });
  }

  void onTap(BuildContext context, int index) {
    final id = _listTopMovies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.topMovieDetail, arguments: id);
  }
}

class TopMovieListModelProvider extends InheritedNotifier {
  final TopMovieListModel model;
  const TopMovieListModelProvider(
      {super.key, required super.child, required this.model})
      : super(notifier: model);

  static TopMovieListModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TopMovieListModelProvider>();
  }

  static TopMovieListModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TopMovieListModelProvider>()
        ?.widget;
    return widget is TopMovieListModelProvider ? widget : null;
  }
}

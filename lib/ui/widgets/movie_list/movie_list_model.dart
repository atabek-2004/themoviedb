import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/ui/navigations/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  var _movieList = <Movie>[];
  List<Movie> get movieList => List.unmodifiable(_movieList);

  late DateFormat _dateFormat;
  String _locale = '';
  late int _currentPage;
  bool _isActivateTotal = false;
  late int _totalPage;
  String? _querySearch;
  Timer? _timer;

  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    _resetListMovie();
  }

  Future<void> _resetListMovie() async {
    _currentPage = 0;
    _totalPage = 1;
    _movieList.clear();
    await _loadNextPage();
  }

  String stringRelaseDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<PopularMovieResponse> _loadMovies(int page, String locale) async {
    var query = _querySearch;
    if (query != null) {
      return await _apiClient.searchMovies(page, locale, query);
    } else {
      return await _apiClient.popularMovies(page, locale);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isActivateTotal || _currentPage >= _totalPage) return;
    _isActivateTotal = true;
    final nextPage = _currentPage + 1;
    try {
      final movieResponse = await _loadMovies(nextPage, _locale);
      _movieList.addAll(movieResponse.movies);
      _currentPage = movieResponse.page;
      _totalPage = movieResponse.totalPages;
      _isActivateTotal = false;
      notifyListeners();
    } catch (e) {
      _isActivateTotal = false;
    }
  }

  void showedMovieAtIndex(int index) {
    if (index < _movieList.length - 1) return;
    _loadNextPage();
  }

  Future<void> serachMovie(String text) async {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () async {
      _querySearch = text.isNotEmpty ? text : null;
      await _resetListMovie();
    });
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movieList[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetail, arguments: id);
  }
}

class MovieListModelProvider extends InheritedNotifier {
  final MovieListModel model;
  const MovieListModelProvider(
      {super.key, required super.child, required this.model})
      : super(notifier: model);

  static MovieListModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MovieListModelProvider>();
  }

  static MovieListModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MovieListModelProvider>()
        ?.widget;
    return widget is MovieListModelProvider ? widget : null;
  }
}

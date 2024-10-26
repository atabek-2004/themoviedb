import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';

class TopMovieDetailsModel extends ChangeNotifier {
  final int movieId;
  TopMovieDetailsModel(this.movieId);

  final _apiClient = ApiClient();

  MovieDetails? _movieDetails;
  MovieDetails? get movieDetails => _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();

    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);

    await _setupMovieDetail(movieId, _locale);
  }

  Future<void> _setupMovieDetail(int movieId, String locale) async {
    _movieDetails = await _apiClient.movieDetails(movieId, locale);
    notifyListeners();
  }

  String stringRelaseDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';
}

class TopMovieDetailsModelProvider extends InheritedNotifier {
  final TopMovieDetailsModel model;
  const TopMovieDetailsModelProvider(
      {super.key, required super.child, required this.model})
      : super(notifier: model);

  static TopMovieDetailsModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TopMovieDetailsModelProvider>();
  }

  static TopMovieDetailsModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TopMovieDetailsModelProvider>()
        ?.widget;
    return widget is TopMovieDetailsModelProvider ? widget : null;
  }
}

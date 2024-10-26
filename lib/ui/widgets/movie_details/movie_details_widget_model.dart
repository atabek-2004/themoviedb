import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';

class MovieDetailsWidgetModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final int movieId;

  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;
  MovieDetailsWidgetModel({required this.movieId});

  MovieDetails? get movieDetails => _movieDetails;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;

    _locale = locale;
    _dateFormat = DateFormat.yMMMd(_locale);
    await _loadDetails();
  }

  Future<void> _loadDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    notifyListeners();
  }

  String stringRelaseDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';
}

class MovieDetailsWidgetModelProvider extends InheritedNotifier {
  final MovieDetailsWidgetModel model;
  const MovieDetailsWidgetModelProvider(
      {super.key, required super.child, required this.model})
      : super(notifier: model);

  static MovieDetailsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MovieDetailsWidgetModelProvider>();
  }

  static MovieDetailsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            MovieDetailsWidgetModelProvider>()
        ?.widget;
    return widget is MovieDetailsWidgetModelProvider ? widget : null;
  }
}

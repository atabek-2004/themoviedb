import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget_model.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:themoviedb/ui/widgets/movie_details/top_movie_details.dart';
import 'package:themoviedb/ui/widgets/movie_details/top_movie_details_model.dart';
import 'package:themoviedb/ui/widgets/movie_trailer/movie_trailer_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = 'auth/main_screen';
  static const movieDetail = 'auth/main_screen/movie_detail';
  static const topMovieDetail = 'auth/main_screen/top_movie_detail';
  static const movieTrailer = 'auth/main_screen/movie_detail/movie_railer';
}

class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.auth;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.auth: (context) => AuthWidgetModelProvider(
          model: AuthWidgetModel(),
          child: const AuthWidget(),
        ),
    MainNavigationRouteNames.mainScreen: (context) => const MainScreenWidget(),
  };
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetail:
        final argument = settings.arguments;
        final movieIndex = argument is int ? argument : 0;
        return MaterialPageRoute(
          builder: (context) => MovieDetailsWidgetModelProvider(
            model: MovieDetailsWidgetModel(movieId: movieIndex),
            child: MovieDetailsWidget(
              movieId: movieIndex,
            ),
          ),
        );
      case MainNavigationRouteNames.topMovieDetail:
        final argument = settings.arguments;
        final movieIndex = argument is int ? argument : 0;
        return MaterialPageRoute(
          builder: (context) => TopMovieDetailsModelProvider(
            model: TopMovieDetailsModel(movieIndex),
            child: TopMovieDetailsWidget(
              movieId: movieIndex,
            ),
          ),
        );
      case MainNavigationRouteNames.movieTrailer:
        final argument = settings.arguments;
        final movieKey = argument is String ? argument : '';
        return MaterialPageRoute(
          builder: (context) => MovieTrailerWidget(
            movieKey: movieKey,
          ),
        );
      default:
        const widget = Text('Error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}

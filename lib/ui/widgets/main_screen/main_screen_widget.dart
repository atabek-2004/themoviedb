import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/Theme/app_color.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/widgets/movie_list/top_movie_list.dart';
import 'package:themoviedb/ui/widgets/movie_list/top_movie_list_model.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _currentIndex = 0;

  final _movieListModel = MovieListModel();
  final _topMovieListModel = TopMovieListModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _movieListModel.setupLocale(context);
    _topMovieListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    void onTap(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
        backgroundColor: AppColor.appColor,
        foregroundColor: AppColor.foreGroundColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColor.appColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Сериалы',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ElevatedButton(
              onPressed: () => SessionDataProvider().setSessionId(null),
              child: const Text('BB')),
          MovieListModelProvider(
            model: _movieListModel,
            child: const MovieListWidget(),
          ),
          TopMovieListModelProvider(
            model: _topMovieListModel,
            child: const TopMovieListWidget(),
          ),
        ],
      ),
    );
  }
}

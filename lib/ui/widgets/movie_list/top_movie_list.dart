import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/ui/widgets/movie_list/top_movie_list_model.dart';

class TopMovieListWidget extends StatelessWidget {
  const TopMovieListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TopMovieListModelProvider.watch(context)?.model;
    if (model == null) const SizedBox.shrink();
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
              padding: const EdgeInsets.only(top: 70),
              itemExtent: 163,
              itemCount: model?.listTopMovies.length,
              itemBuilder: (BuildContext context, index) {
                model?.showedTopMovieAtIndex(index);
                final movie = model!.listTopMovies[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                          children: [
                            movie.posterPath != null
                                ? Image.network(
                                    ApiClient.imageUrl(movie.posterPath!))
                                : const SizedBox.shrink(),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    movie.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    model.stringRelaseDate(movie.releaseDate),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    movie.overview,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          onTap: () => model.onTap(context, index),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              onChanged: model?.searchTopMovie,
              decoration: InputDecoration(
                hintText: 'Поиск',
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white.withAlpha(225),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

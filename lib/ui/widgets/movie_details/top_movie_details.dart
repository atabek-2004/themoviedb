import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie_details_credits.dart';
import 'package:themoviedb/ui/Theme/app_color.dart';
import 'package:themoviedb/ui/navigations/main_navigation.dart';
import 'package:themoviedb/ui/widgets/movie_details/top_movie_details_model.dart';

class TopMovieDetailsWidget extends StatefulWidget {
  final int movieId;
  const TopMovieDetailsWidget({super.key, required this.movieId});

  @override
  State<TopMovieDetailsWidget> createState() => _TopMovieDetailsWidgetState();
}

class _TopMovieDetailsWidgetState extends State<TopMovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TopMovieDetailsModelProvider.read(context)?.model.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColor.foreGroundColor,
        backgroundColor: AppColor.appColor,
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
        color: Color.fromARGB(255, 15, 13, 13),
        child: _MovieDetailsWidgetBody(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    final title =
        TopMovieDetailsModelProvider.watch(context)?.model.movieDetails?.title;
    return Text(title ?? 'Загрузка...');
  }
}

class _MovieDetailsWidgetBody extends StatelessWidget {
  const _MovieDetailsWidgetBody();

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    final movieDetails = model?.model.movieDetails;
    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        _HeaderImageWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Column(
            children: [
              _MovieNameWidget(),
              SizedBox(height: 20),
              _UserScoreWidget(),
            ],
          ),
        ),
        _DescriptionDateWidget(),
        SizedBox(height: 20),
        _OverViewWidget(),
        SizedBox(height: 30),
        ColoredBox(
          color: Colors.white,
          child: _ActorsWidget(),
        ),
      ],
    );
  }
}

class _HeaderImageWidget extends StatelessWidget {
  const _HeaderImageWidget();

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    final backdropPath = model?.model.movieDetails?.backdropPath;
    final posterPath = model?.model.movieDetails?.posterPath;
    return Stack(
      children: [
        backdropPath != null
            ? Image.network(ApiClient.imageUrl(backdropPath))
            : const SizedBox.shrink(),
        Positioned(
          top: 25,
          child: SizedBox(
            width: 140,
            height: 140,
            child: posterPath != null
                ? Image.network(ApiClient.imageUrl(posterPath))
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget();

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    final title = model?.model.movieDetails?.title;
    final releaseDate = model?.model.movieDetails?.releaseDate?.year;
    if (title == null) {
      return const SizedBox.shrink();
    }

    var text = '';
    releaseDate != null ? text = ' ($releaseDate)' : null;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}

class _UserScoreWidget extends StatelessWidget {
  const _UserScoreWidget();

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    final voteAverage = model?.model.movieDetails?.voteAverage;
    if (voteAverage == null) {
      return const SizedBox.shrink();
    }
    final score = voteAverage * 10;
    final videos = model?.model.movieDetails?.videos.results;
    if (videos == null || videos.isEmpty) {
      return const SizedBox.shrink();
    }
    final videoKey = videos.first.key;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              CircularPercentIndicator(
                animationDuration: 1000,
                radius: 27.0,
                lineWidth: 5.0,
                animation: true,
                percent: score / 100,
                center: Text(
                  "${score.toInt()}%",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: score > 70
                    ? Colors.green
                    : score < 70 && score > 40
                        ? Colors.yellow
                        : Colors.red,
              ),
              const SizedBox(width: 10),
              const Text(
                'User score',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        Container(
          width: 2,
          height: 15,
          color: Colors.grey,
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(
              MainNavigationRouteNames.movieTrailer,
              arguments: videoKey),
          child: const Row(
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Text(
                'Play Trailer',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DescriptionDateWidget extends StatelessWidget {
  const _DescriptionDateWidget();

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    if (model == null) {
      return const SizedBox.shrink();
    }
    var texts = <String>[];
    final releaseDate = model.model.movieDetails?.releaseDate;
    releaseDate != null
        ? texts.add(model.model.stringRelaseDate(releaseDate))
        : null;
    final productionCountries = model.model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }
    final runtime = model.model.movieDetails?.runtime;
    if (runtime != null) {
      final hour = Duration(minutes: runtime).inHours;
      final minutes = Duration(minutes: runtime).inMinutes;
      texts.add('${hour}h ${minutes}m');
    }
    final genres = model.model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }

    return ColoredBox(
      color: const Color.fromARGB(255, 21, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              textAlign: TextAlign.center,
              texts.join(' '),
              style: AppColor.movieDescriptionDateDescriptionCol0r,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverViewWidget extends StatelessWidget {
  const _OverViewWidget();

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    final overview = model?.model.movieDetails?.overview;
    if (overview == null) {
      return const SizedBox.shrink();
    }

    var crew = model?.model.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) {
      return const SizedBox.shrink();
    }
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<Employee>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: AppColor.movieDescriptionDateDescriptionCol0r,
          ),
          const SizedBox(height: 20),
          Text(
            overview,
            style: AppColor.movieDescriptionDateDescriptionCol0r,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: crewChunks
                .map((chunk) => Expanded(
                      child: _EmployeeWidgetColumn(
                        employes: chunk,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _EmployeeWidgetColumn extends StatelessWidget {
  final List<Employee> employes;
  const _EmployeeWidgetColumn({required this.employes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: employes
          .map(
            (employee) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _EmployeeWidgetItem(
                employee: employee,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _EmployeeWidgetItem extends StatelessWidget {
  final Employee employee;
  const _EmployeeWidgetItem({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style: AppColor.movieDescriptionDateDescriptionCol0r,
              ),
              Text(
                employee.job,
                style: AppColor.movieDescriptionDateDescriptionCol0r,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActorsWidget extends StatelessWidget {
  const _ActorsWidget();

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    final countActors = model?.model.movieDetails?.credits.cast.length ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Series Cast',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
              itemCount: countActors,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: _ActorsWidgetBody(index: index),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: () {},
            child: const Text('Full Cast & Crew'),
          ),
        ),
      ],
    );
  }
}

class _ActorsWidgetBody extends StatelessWidget {
  final int index;
  const _ActorsWidgetBody({required this.index});

  @override
  Widget build(BuildContext context) {
    final model = TopMovieDetailsModelProvider.watch(context);
    final cast = model?.model.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) {
      return const SizedBox.shrink();
    }
    final profilePath = cast[index].profilePath;
    final name = cast[index].name;
    final character = cast[index].character;

    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          width: 100,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(1, 3),
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              profilePath != null
                  ? Image.network(ApiClient.imageUrl(profilePath))
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      character,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 7),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'topmovie.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TopMovie {
  final String? posterPath;
  final bool adult;
  final String overview;
  @JsonKey(fromJson: _parseDateFrromString)
  final DateTime? releaseDate;
  final List<int> genreIds;
  final int id;
  final String originalTitle;
  final String originalLanguage;
  final String title;
  final String? backdropPath;
  final double popularity;
  final int voteCount;
  final bool video;
  final double voteAverage;

  TopMovie(
      {required this.posterPath,
      required this.adult,
      required this.overview,
      required this.releaseDate,
      required this.genreIds,
      required this.id,
      required this.originalTitle,
      required this.originalLanguage,
      required this.title,
      required this.backdropPath,
      required this.popularity,
      required this.voteCount,
      required this.video,
      required this.voteAverage});

  factory TopMovie.fromJson(Map<String, dynamic> json) => _$TopMovieFromJson(json);
  Map<String, dynamic> toJson() => _$TopMovieToJson(this);

  static DateTime? _parseDateFrromString(String? rawdate) {
    if (rawdate == null || rawdate.isEmpty) return null;
    return DateTime.tryParse(rawdate);
  }
}

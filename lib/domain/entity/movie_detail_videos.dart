import 'package:json_annotation/json_annotation.dart';

part 'movie_detail_videos.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailVideos {
  final List<MovieDetailVideosResult> results;

  MovieDetailVideos({required this.results});

  factory MovieDetailVideos.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailVideosFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailVideosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailVideosResult {
  @JsonKey(name: 'iso_639_1')
  final String iso6391;
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  MovieDetailVideosResult(
      {required this.iso6391,
      required this.iso31661,
      required this.name,
      required this.key,
      required this.site,
      required this.size,
      required this.type,
      required this.official,
      required this.publishedAt,
      required this.id});

  factory MovieDetailVideosResult.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailVideosResultFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailVideosResultToJson(this);
}

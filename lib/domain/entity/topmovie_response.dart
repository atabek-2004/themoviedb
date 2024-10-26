import 'package:json_annotation/json_annotation.dart';
import 'package:themoviedb/domain/entity/topmovie.dart';

part 'topmovie_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TopmovieResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<TopMovie> movies;
  final int totalPages;
  final int totalResults;

  TopmovieResponse({
    required this.page,
    required this.movies,
    required this.totalResults,
    required this.totalPages,
  });

  factory TopmovieResponse.fromJson(Map<String, dynamic> json) =>
      _$TopmovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TopmovieResponseToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topmovie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopmovieResponse _$TopmovieResponseFromJson(Map<String, dynamic> json) =>
    TopmovieResponse(
      page: (json['page'] as num).toInt(),
      movies: (json['results'] as List<dynamic>)
          .map((e) => TopMovie.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: (json['total_results'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$TopmovieResponseToJson(TopmovieResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.movies.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

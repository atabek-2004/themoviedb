import 'dart:convert';
import 'dart:io';

import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/domain/entity/topmovie_response.dart';

enum ApiClientExceptionType { network, auth, other }

class ApiClientExeption implements Exception {
  final ApiClientExceptionType type;

  ApiClientExeption({required this.type});
}

class ApiClient {
  final _apiClient = HttpClient();

  static const _host = 'https://api.themoviedb.org/3';
  static const _apiKey = '1e90f50e12198910872fb719e55917d4';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validateUser = await _validateUser(
        userName: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validateUser);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final url = Uri.parse('$_host$path');

    if (parameters != null) {
      return url.replace(queryParameters: parameters);
    } else {
      return url;
    }
  }

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);

    try {
      final request = await _apiClient.getUrl(url);
      final response = await request.close();
      final json = await response.jsonDecode();
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(type: ApiClientExceptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExceptionType.other);
    }
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic>? bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);
      final request = await _apiClient.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));

      final response = await request.close();
      final json = await response.jsonDecode();
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(type: ApiClientExceptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExceptionType.other);
    }
  }

  Future<String> _makeToken() async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _get(
      '/authentication/token/new',
      parser,
      {'api_key': _apiKey},
    );
    return result;
  }

  Future<PopularMovieResponse> popularMovies(int page, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _get(
      '/movie/popular',
      parser,
      {
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  Future<PopularMovieResponse> searchMovies(
      int page, String locale, String query) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _get(
      '/search/movie',
      parser,
      {
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  Future<TopmovieResponse> searchTopMovies(
      int page, String locale, String query) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TopmovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _get(
      '/search/movie',
      parser,
      {
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
        'query': query,
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = _get(
      '/movie/$movieId',
      parser,
      {
        'append_to_response': 'credits,videos',
        'api_key': _apiKey,
        'language': locale,
      },
    );
    return result;
  }

  Future<TopmovieResponse> topReatedMovies(int page, String locale) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = TopmovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _get(
      '/movie/top_rated',
      parser,
      {
        'api_key': _apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  Future<String> _validateUser({
    required String userName,
    required String password,
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'username': userName,
      'password': password,
      'request_token': requestToken,
    };

    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _post(
      '/authentication/token/validate_with_login',
      parameters,
      parser,
      {'api_key': _apiKey},
    );

    return result;
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };

    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['session_id'] as String;
      return token;
    }

    final result = _post(
      '/authentication/session/new',
      parameters,
      parser,
      {'api_key': _apiKey},
    );

    return result;
  }

  void _validateResponse(
      HttpClientResponse response, Map<String, dynamic> json) {
    if (response.statusCode == 401) {
      final status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientExeption(type: ApiClientExceptionType.auth);
      } else {
        throw ApiClientExeption(type: ApiClientExceptionType.other);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  dynamic jsonDecode() {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then((v) => json.decode(v) as dynamic);
  }
}

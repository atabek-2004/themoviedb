import 'package:flutter/material.dart';
import 'package:themoviedb/ui/Theme/app_color.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  final String movieKey;
  const MovieTrailerWidget({super.key, required this.movieKey});

  @override
  State<MovieTrailerWidget> createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  late final YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.movieKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        
        controller: _controller,
      
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.appColor,
            foregroundColor: AppColor.foreGroundColor,
            title: const Text('Trailer'),
          ),
          body: Center(child: player),
        );
      },
    );
  }
}

// ignore_for_file: non_constant_identifier_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoController extends StatefulWidget {
  final String VideoUrl;
  VideoController(this.VideoUrl);

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);

  initVideo() {
    _controller = VideoPlayerController.network(widget.VideoUrl,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    _initializeVideoPlayerFuture = _controller!.initialize();
  }

  @override
  void initState() {
    initVideo();
    _initializeVideoPlayerFuture = _controller!.initialize();

    _controller!.setLooping(true);
    _controller!.setVolume(1.0);
    _controller!.addListener(() {
      if (_controller!.value.isInitialized) {
        currentPosition.value = _controller!.value;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller!.play();
    _controller!.setVolume(0.0);
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              child: VideoPlayer(_controller!),
            );
          } else {
            return Center(
                child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              strokeWidth: 1,
            ));
          }
        });
  }
}

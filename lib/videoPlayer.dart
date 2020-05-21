import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class videoPlayer extends StatefulWidget{
  String path;
  videoPlayer(this.path);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _stateI(path);
  }

}

class _stateI extends State<videoPlayer> {

  VideoPlayerController _controller;
  _stateI(this.p);
  String p;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(p))
    ..initialize().then((value) => {});
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Preview and share your Video", style: TextStyle(color:Colors.white),),),
      backgroundColor: Colors.pinkAccent,
      body: Center(
        child: _controller.value.initialized?AspectRatio(aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
        ):CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );

  }

}
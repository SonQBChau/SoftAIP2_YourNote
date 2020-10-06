import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import './string_duration.dart';

class MyPageWithAudio extends StatefulWidget {
  @override
  _MyPageWithAudioState createState() => _MyPageWithAudioState();
}

class _MyPageWithAudioState extends State<MyPageWithAudio> {
  bool _play = false;
  String _currentPosition = "";

  @override
  Widget build(BuildContext context) {
    return AudioWidget.assets(
      path: "assets/audios/1.mp3",
      play: _play,
      onReadyToPlay: (total) {
        setState(() {
          _currentPosition = "${Duration().mmSSFormat} / ${total.mmSSFormat}";
        });
      },
      onPositionChanged: (current, total) {
        setState(() {
          _currentPosition = "${current.mmSSFormat} / ${total.mmSSFormat}";
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text("TED talks"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              shape: CircleBorder(),
              padding: EdgeInsets.all(14),
              color: Theme.of(context).primaryColor,
              child: Icon(
                _play ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _play = !_play;
                });
              },
            ),
          ),
          Text(_currentPosition),
        ],
      ),
    );
  }
}
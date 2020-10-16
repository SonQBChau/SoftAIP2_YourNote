import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/speech_to_text_beta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';



import 'package:flutter_spinkit/flutter_spinkit.dart';
import './string_duration.dart';

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          defaultTextColor: Color(0xFF3E3E3E),
          baseColor: Color(0xFFDDE6E8),
        ),
        darkTheme: neumorphicDefaultDarkTheme.copyWith(defaultTextColor: Colors.white70),
        child: _Page());
  }
}

class _Page extends StatefulWidget {
  @override
  __PageState createState() => __PageState();
}

class __PageState extends State<_Page> {
  String transcript = '';
  bool recognizing = false;
  bool summarizing = false;
  bool recognizeFinished = false;
  bool summarizeFinished = false;
  String text = '';
  bool _play = false;
  // String _currentPosition = "";
  double currentPosition = 0.0;
  double totalDuration = 100.0;

  void recognize() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount =
        ServiceAccount.fromString('${(await rootBundle.loadString('assets/google_key.json'))}');
    final speechToText = SpeechToTextBeta.viaServiceAccount(serviceAccount);
    final config = _getConfig();
    final audio = await _getAudioContent('ml2.mp3');

    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        text = value.results.map((e) => e.alternatives.first.transcript).join('\n');
      });
      // widget.notifyParent(text);
    }).whenComplete(() => setState(() {
          recognizeFinished = true;
          recognizing = false;
          transcript = text;
          print(transcript);
        }));
  }

  void getSummary() async {
    var url = 'http://sonchau.pythonanywhere.com/summarizer/api/v1.0/summarize';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode({'transcript': '$transcript'});
    setState(() {
      summarizing = true;
    });

    // make POST request
    Response response = await post(url, headers: headers, body: json);

    // check the status code for the result

    if (response.statusCode == 200) {
      setState(() {
        summarizing = false;
        summarizeFinished = true;
        transcript = jsonDecode(response.body)['lessons'];
        print(transcript);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      summarizing = false;
      summarizeFinished = true;
      print(response.statusCode);
      throw Exception('Failed to get data');
    }
  }

  RecognitionConfigBeta _getConfig() => RecognitionConfigBeta(
      // encoding: AudioEncoding.LINEAR16,
      encoding: AudioEncoding.ENCODING_UNSPECIFIED,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'de-DE',
      alternativeLanguageCodes: ['fr-FR', 'en-US']);

  Future<void> _copyFileFromAssets(String name) async {
    var data = await rootBundle.load('assets/$name');
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    await File(path).writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<List<int>> _getAudioContent(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    if (!File(path).existsSync()) {
      await _copyFileFromAssets(name);
    }
    return File(path).readAsBytesSync().toList();
  }

  buildControlsBar(BuildContext context) {
    return AudioWidget.assets(
        path: "assets/ml2.mp3",
        play: _play,
        onReadyToPlay: (total) {
          setState(() {
            currentPosition = Duration().toDigitSeconds.toDouble();
            totalDuration = total.toDigitSeconds * 1.0;
          });
        },
        onPositionChanged: (current, total) {
          setState(() {
            currentPosition = current.toDigitSeconds * 1.0;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NeumorphicButton(
              padding: const EdgeInsets.all(24.0),
              onPressed: () {
                setState(() {
                  _play = !_play;
                });
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: Icon(
                // Icons.play_arrow,
                _play ? Icons.pause : Icons.play_arrow,
                size: 42,
                color: _iconsColor(),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NeumorphicBackground(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              _buildTitle(context),
              SizedBox(height: 30),
              buildControlsBar(context),
              SizedBox(height: 10),
              _buildSeekBar(context, currentPosition, totalDuration),
              SizedBox(height: 30),
              _buildTranscriptButton(context),
              SizedBox(height: 30),
              _buildTranscriptArea(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Audio Recording",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 34,
                color: NeumorphicTheme.defaultTextColor(context))),
        const SizedBox(
          height: 4,
        ),
        Text("Machine Learning From Hero to Zero",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: NeumorphicTheme.defaultTextColor(context))),
      ],
    );
  }

  Widget _buildSeekBar(BuildContext context, double currentPosition, double totalDuration) {
    // print(currentPosition);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "0:${currentPosition.toInt()}",
                    style: TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
                  )),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "0:${totalDuration.toInt()}",
                    style: TextStyle(color: NeumorphicTheme.defaultTextColor(context)),
                  )),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          NeumorphicSlider(
            height: 8.0,
            min: 0.0,
            max: totalDuration,
            value: currentPosition,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }

  Color _iconsColor() {
    final theme = NeumorphicTheme.of(context);
    if (theme.isUsingDark) {
      return theme.current.accentColor;
    } else {
      return null;
    }
  }

  Widget _buildTranscriptArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Text(transcript,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: NeumorphicTheme.defaultTextColor(context))),
    );
  }

  Widget _buildTranscriptButton(BuildContext context) {
    Widget button;
    if (recognizeFinished && !summarizeFinished) {
      button = NeumorphicButton(
        onPressed: summarizing ? () {} : getSummary,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: summarizing
            ? Container(
                width: 50,
                height: 30,
                child: SpinKitWave(color: Colors.blue, type: SpinKitWaveType.center, size: 30))
            : Text(
                "Summarize it!",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
      );
    } else if (recognizeFinished && summarizeFinished) {
      button = NeumorphicButton(
        onPressed: () {},
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text(
          "Done",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      );
    } else {
      button = NeumorphicButton(
        onPressed: recognizing ? () {} : recognize,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: recognizing
            ? Container(
                width: 50,
                height: 30,
                child: SpinKitWave(color: Colors.blue, type: SpinKitWaveType.center, size: 30))
            : Text(
                "Get Transcript from Google",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
      );
    }

    return Container(
      child: Center(child: button),
    );
  }
}

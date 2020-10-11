import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/speech_to_text_beta.dart';
import 'package:path_provider/path_provider.dart';


class AudioRecognize extends StatefulWidget {
  final Function(String) notifyParent;
  AudioRecognize({Key key, @required this.notifyParent}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AudioRecognizeState();
}

class _AudioRecognizeState extends State<AudioRecognize> {
  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';


  void recognize() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/google_key.json'))}');
    final speechToText = SpeechToTextBeta.viaServiceAccount(serviceAccount);
    final config = _getConfig();
    final audio = await _getAudioContent('1.mp3');
    // final audio = await _getAudioContent('ted.mp3');

    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        text = value.results
            .map((e) => e.alternatives.first.transcript)
            .join('\n');
      });
      widget.notifyParent(text);
    }).whenComplete(() => setState(() {
      recognizeFinished = true;
      recognizing = false;
    }));
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
    await File(path).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<List<int>> _getAudioContent(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    if (!File(path).existsSync()) {
      await _copyFileFromAssets(name);
    }
    return File(path).readAsBytesSync().toList();
  }



  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

            RaisedButton(
              onPressed: recognizing ? () {} : recognize,
              child: recognizing
                  ? CircularProgressIndicator()
                  : Text('Test with recognize'),
            ),
            // if (recognizeFinished)
            //   _RecognizeContent(
            //     text: text,
            //   ),

          ],
        ),
      ); // This trailing comma makes auto-formatting nicer for build methods.

  }
}

class _RecognizeContent extends StatelessWidget {
  final String text;

  const _RecognizeContent({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'The text recognized by the Google Speech Api:',
          ),

          SizedBox(
            height: 16.0,
          ),
          Container(
            height: 200,
            child: SingleChildScrollView(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),

    );
  }
}
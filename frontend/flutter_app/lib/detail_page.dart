
import 'package:flutter/material.dart';
import 'audio_widget.dart';
import 'lesson.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/speech_to_text_beta.dart';
import 'package:path_provider/path_provider.dart';

class DetailPage extends StatefulWidget {
  final Lesson lesson;

  DetailPage({Key key, this.lesson}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String text_content = "";



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
      // widget.notifyParent(text);
    }).whenComplete(() => setState(() {
      recognizeFinished = true;
      recognizing = false;
      text_content = text;
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

    final bottomContentText = Expanded(

        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              text_content,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),

    );



    final readButton = Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 16),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          // onPressed: () => {
          //
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => SummaryPage(text_content: text_content)))
          //
          // },
          onPressed: recognizing ? () {} : recognize,
          child: recognizing
              ? CircularProgressIndicator()
              : Text('Test with recognize'),
        ),
          color: Color.fromRGBO(58, 66, 86, 1.0),
          // child:
          // Text("GET SUMMARY", style: TextStyle(color: Colors.white)),
        // )
    );


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: Column(
        children: <Widget>[
          MyPageWithAudio(),
          bottomContentText,
          readButton],
      ),
    );
  }
}
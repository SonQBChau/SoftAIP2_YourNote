
import 'package:flutter/material.dart';
import 'package:flutter_app/utils.dart';

import 'lesson.dart';

class SummaryPage extends StatefulWidget {
  final String text_content;
  SummaryPage({Key key, this.text_content}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {

  Future <String> summary ;

  @override
  void initState() {
    super.initState();
    summary = getSummary(this.widget.text_content);
  }

  @override
  Widget build(BuildContext context) {

    final bottomContentText = Expanded(

      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: FutureBuilder<String>(
            future: summary,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                return Text(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),

    );



    final readButton = Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 16),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
          Text("BACK", style: TextStyle(color: Colors.white)),
        ));


    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
      ),
      body: Column(
        children: <Widget>[ bottomContentText, readButton],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/summary_page.dart';
import 'package:flutter_app/utils.dart';

import 'lesson.dart';

class DetailPage extends StatelessWidget {
  final Lesson lesson;
  DetailPage({Key key, this.lesson}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final bottomContentText = Expanded(

        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              lesson.content,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),

    );



    final readButton = Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 16),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SummaryPage(lesson: lesson)))

          },
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
          Text("GET SUMMARY", style: TextStyle(color: Colors.white)),
        ));


    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Column(
        children: <Widget>[ bottomContentText, readButton],
      ),
    );
  }
}
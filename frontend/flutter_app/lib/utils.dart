import 'package:http/http.dart';
import 'dart:convert';

Future<String> getSummary(content) async {
  var url = 'http://sonchau.pythonanywhere.com/summarizer/api/v1.0/summarize';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = jsonEncode({'transcript': '$content'});

  // make POST request
  Response response = await post(url, headers: headers, body: json);

  // check the status code for the result

  if (response.statusCode == 200) {
    // print(response.body);
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.statusCode);
    throw Exception('Failed to get data');
  }
}

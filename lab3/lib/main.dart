import 'package:html/parser.dart' show parse;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

void main() => runApp(MaterialApp(
      home: WorkWithRequests(),
    ));

class WorkWithRequests extends StatefulWidget {
  @override
  _WorkWithRequestsState createState() => new _WorkWithRequestsState();
}

class _WorkWithRequestsState extends State<WorkWithRequests> {
  String data = "";
  String htmlData = "";

  _loadData() async {
    //final response = await http.get('https://pub.dev/packages/http');
    var url = Uri.parse("https://pub.dev/packages/http");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      setState(() {
        htmlData = response.body;
        //data = document.getElementsByClassName('likes-count')[0].text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Requests"),
          backgroundColor: Colors.black,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  _loadData();
                },
                child: Text("Загрузить данные"),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(htmlData),
        )),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(data != "" ? "Кол-во лайков: $data" : "",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          padding: EdgeInsets.all(20),
          color: Colors.black,
        ),
        backgroundColor: Colors.white);
  }
}

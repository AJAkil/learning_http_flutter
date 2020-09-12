import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'album.dart';

void main() {
  runApp(Myapp());
}

Future<Album> fetchAlbum() async{
  final response = await http.get('https://jsonplaceholder.typicode.com/albums/2');

  if (response.statusCode == 200){
    // ok response, let'a parse the json object
    return Album.fromJson(json.decode(response.body));
  }else{
    throw Exception('Failed to load the response');
  }
}

Future<Album> createAlbum(String title) async{
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'body': 'THis is just a body with the title $title',
    })
  );

  if (response.statusCode == 201){
    return Album.fromJsonPost(json.decode(response.body));
  }else{
    throw Exception('Error posting data!');
  }
}



class Myapp extends StatefulWidget {
  Myapp({Key key}) : super(key: key);

  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  Future<Album> futureAlbum;

  final TextEditingController _controller = TextEditingController();
  Future<Album> _postAlbum;

  @override
  void initState(){
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch data example',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTTP Test')
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: futureAlbum,
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    return Text(snapshot.data.title, style: TextStyle(fontSize: 20),);
                  }else if(snapshot.hasError){
                    return Text("${snapshot.error}");
                  }

                  return CircularProgressIndicator();
                },
              ),
              SizedBox(
                height: 3,
                width: 300,
                child: Container(
                  color: Colors.blue,
                ),
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter Title'),
              ),
              RaisedButton(
                child: Text('Create Data'),
                onPressed: () {
                  setState(() {
                    _postAlbum = createAlbum(_controller.text);
                  });
                },
              ),
              (_postAlbum == null)
              ? Container()
                  : FutureBuilder<Album>(
                future: _postAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data.id);
                    print(snapshot.data.title);
                    print(snapshot.data.body);
                    return Text(snapshot.data.id.toString());
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}



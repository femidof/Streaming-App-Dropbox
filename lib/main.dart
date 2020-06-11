import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart' as path;
import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;

final pathSuffix = '/deeMusic/downloads';
String wow = "";
String hmm = "";
Future<String> _getDownloadPath(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final prefix = dir.path;
  final absolutePath = prefix + filename;

  // print("This is where you have your path:= $absolutePath");
  return absolutePath;
}

void download() async {
  // print("What did you expect uncle");
  String downloadLocation;
  Map<String, String> myHeader = {
    "Authorization":
        "Bearer RKHeZb5kSwAAAAAAAAABWaffxG5G7mLr256QMIHIjdylAJLNnAUoi1DW7YQYhIPw",
    'Dropbox-API-Arg': '{"path": "$wow"}',
  };
  final response = await http.post(
      'https://content.dropboxapi.com/2/files/download',
      headers: <String, String>{
        'Content-Type': '',
        'Dropbox-API-Arg': '{"path": "$wow"}',
        'Authorization':
            'Bearer RKHeZb5kSwAAAAAAAAABWaffxG5G7mLr256QMIHIjdylAJLNnAUoi1DW7YQYhIPw'
      });

  // print(response.body);
  // print(wow);
  // http.StreamedResponse req = http.StreamedResponse();
  // final req = http.Request(
  //   'POST',
  //   Uri.parse('https://content.dropboxapi.com/2/files/download'),
  // )..headers.addAll(myHeader);
  // final res = await req.send();
  if (response.statusCode != 200)
    throw Exception('OMG  Unexpected HTTP code: ${response.statusCode}');

  final contentLength = response.contentLength;
  var downloadedLength = 0;
  String filePath = await _getDownloadPath(wow.split(".").last);
  // print("File path is $filePath");
  final file = File(filePath + ".mp3");
  // File(filePath)
  await file.writeAsBytes(response.bodyBytes,
      mode: FileMode.write, flush: false);
  // res.stream
  //     .map((chunk) {
  //       downloadedLength += chunk.length;
  //       // if (updates != null) updates(downloadedLength / contentLength);
  //       return chunk;
  //     })
  //     .pipe(file.openWrite())
  //     .whenComplete(() {
  //       // TODO save this to sharedprefs or similar.
  // file.writeAsBytes(response.bodyBytes);
  downloadLocation = filePath;
  hmm = filePath + ".mp3";
  // print("Download Complete $hmm");
  //       // notifyListeners();
  //     })
  //     .catchError((e) => print('An Error has occurred!!!: $e'));
}

// Rssfeed
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Testing",
      // home: MusicsPage(),
      home: LoadingSplash(),
    );
  }
}

class Music with ChangeNotifier {
  Map<String, bool> downloadStatus;

  Future musicRequest(String path) async {
    http.Response response = await http.post(
      'https://api.dropboxapi.com/2/files/list_folder',
      // Send authorization headers to the backend.
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer RKHeZb5kSwAAAAAAAAABWaffxG5G7mLr256QMIHIjdylAJLNnAUoi1DW7YQYhIPw'
      },
      body: jsonEncode({
        'path': '$path',
        // 'recursive': true,
      }),
      encoding: Encoding.getByName('utf-8'),
    );
    dynamic responseJson = json.decode(response.body);
  }
}

class LoadingSplash extends StatefulWidget {
  @override
  _LoadingSplashState createState() => _LoadingSplashState();
}

class _LoadingSplashState extends State<LoadingSplash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 7),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MusicsPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.amber[200],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/welcome.jpg"),
                      radius: 200,
                      // child: CircularProgressIndicator(   ),
                      child: Text(
                        "deeMUSIC",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    // Text(
                    //   "deeMUSIC",
                    //   style: TextStyle(
                    //     color: Colors.red,
                    //     fontSize: 25.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(
                      height: 100.0,
                    ),
                    SpinKitDoubleBounce(
                      color: Colors.cyanAccent,
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       // SpinKitDoubleBounce(
              // color: Colors.cyanAccent,
              // ),
              //       // Text("Freedom is yours"),
              //       Padding(
              //         padding: EdgeInsets.only(top: 10.0),
              //       ),
              //     ],
              // ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class MusicsPage extends StatefulWidget {
  @override
  _MusicsPageState createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var genrePath;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: FutureBuilder(
        future: http.post(
          'https://api.dropboxapi.com/2/files/list_folder',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer RKHeZb5kSwAAAAAAAAABWaffxG5G7mLr256QMIHIjdylAJLNnAUoi1DW7YQYhIPw'
          },
          body: jsonEncode({
            'path': '',
            // 'recursive': true,
          }),
          encoding: Encoding.getByName('utf-8'),
        ),
        builder: (context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            final response = snapshot.data;
            if (response.statusCode == 200) {
              dynamic jsonResponse = json.decode(response.body);
              genrePath = [];
              List<Widget> genreName = [];
              var arr = jsonResponse["entries"];
              for (var i = 0; i < arr.length; i++) {
                genrePath.add(arr[i]["path_lower"]);
              }
              for (var i = 0; i < arr.length; i++) {
                genreName.add(
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ShowMedia(path: arr[i]["path_lower"])));
                      // MusicsPage(path: arr[i]["path_lower"])));
                    },
                    child: Container(
                      // color: Colors.amberAccent,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/$i.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          arr[i]["name"].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontSize: 35.00,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        // onTap: ,
                      ),
                    ),
                  ),
                );
              }
              // print("genrePath: $genrePath");
              // print("genreName: $genreName");
              //genreName.forEach((name) => Text(name));
              List<Widget> widg = genreName;
              // parse File
              return GridView.count(
                crossAxisSpacing: 5,
                // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: widg, // genreName.forEach((name) =>
                //Text("$genreName[$name]")), //map items from the listfolder
              );
            } else {
              return (MusicsPage == null)
                  ? Center(
                      // child: SpinKitDoubleBounce(
                      // color: Colors.cyanAccent,
                      // ),
                      child: SpinKitDoubleBounce(
                        color: Colors.cyanAccent,
                      ),
                    )
                  : Center(
                      // child: SpinKitDoubleBounce(
                      // color: Colors.cyanAccent,
                      // ),
                      child: SpinKitDoubleBounce(
                        color: Colors.cyanAccent,
                      ),
                    );
            }
          } else {
            return Center(
              child: SpinKitDoubleBounce(
                color: Colors.cyanAccent,
              ),
            );
          }
        },
      ),
    );
  }
}

Future<void> listAlbum(path) async {
  http.Response response = await http.post(
    'https://api.dropboxapi.com/2/files/list_folder',
    // Send authorization headers to the backend.
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer RKHeZb5kSwAAAAAAAAABWaffxG5G7mLr256QMIHIjdylAJLNnAUoi1DW7YQYhIPw'
    },
    body: jsonEncode({
      'path': '$path',
      // 'recursive': true,
    }),
    encoding: Encoding.getByName('utf-8'),
  );
  dynamic responseJson = json.decode(response.body);
  // print(responseJson);
  var tmp = [];
  var arr = responseJson["entries"];
  for (var i = 0; i < arr.length; i++) {
    tmp.add(arr[i]["path_lower"]);
  }
  // print(tmp);
  // print(responseJson['entries'][2]..['path_lower']);
  // print()
  // print(accessToken);
  // return response;
}

class ShowMedia extends StatefulWidget {
  var path;
  ShowMedia({Key key, @required this.path}) : super(key: key);

  @override
  _ShowMediaState createState() => _ShowMediaState();
}

class _ShowMediaState extends State<ShowMedia> {
  @override
  var genrePath;
  Widget build(BuildContext context) {
    // listAlbum(widget.path);
    var path = widget.path;
    // print("Oh my what $path");
    return Scaffold(
      backgroundColor: Colors.black54,
      body: FutureBuilder(
        future: http.post(
          'https://api.dropboxapi.com/2/files/list_folder',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer RKHeZb5kSwAAAAAAAAABWaffxG5G7mLr256QMIHIjdylAJLNnAUoi1DW7YQYhIPw'
          },
          body: jsonEncode({
            'path': '$path',
            // 'recursive': true,
          }),
          encoding: Encoding.getByName('utf-8'),
        ),
        builder: (context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            final response = snapshot.data;
            if (response.statusCode == 200) {
              dynamic jsonResponse = json.decode(response.body);
              genrePath = [];
              List<Widget> genreName = [];
              var arr = jsonResponse["entries"];
              for (var i = 0; i < arr.length; i++) {
                genrePath.add(arr[i]["path_lower"]);
              }
              for (var i = 0; i < arr.length; i++) {
                genreName.add(
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ShowMedia(path: arr[i]["path_lower"])));
                    },
                    child: Container(
                      // color: Colors.black,
                      // color: Colors.amberAccent,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/music.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          arr[i]["name"].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            wordSpacing: 2,
                            fontSize: 20.00,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // onTap: ,
                      ),
                    ),
                  ),
                );
              }
              // print("genrePath: $genrePath");
              // print("genreName: $genreName");
              //genreName.forEach((name) => Text(name));
              List<Widget> widg = genreName;
              // parse File
              return GridView.count(
                crossAxisSpacing: 5,
                // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: widg, // genreName.forEach((name) =>
                //Text("$genreName[$name]")), //map items from the listfolder
              );
            } else {
              path = widget.path;
              // final String file = "" + path;
              wow = widget.path;
              // print('$widget.path');

              return Center(
                // child: SpinKitDoubleBounce(
                // color: Colors.cyanAccent,
                // ),
                child: PlayerPage(),
              );
            }
          } else {
            return Center(
              child: SpinKitDoubleBounce(
                color: Colors.cyanAccent,
              ),
            );
          }
        },
      ),
    );
  }
}

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Player(),
        ),
      ),
    );
  }
}

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future really(context) async {
      await download();
      print("DONE");
      return Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Loaded ${wow.split("/").last}'),
        ),
      );
    }

    really(context);

    return Column(
      children: <Widget>[
        Flexible(
          flex: 9,
          child: Placeholder(),
        ),
        Flexible(
          flex: 2,
          child: AudioControls(),
        ),
      ],
    );
  }
}

class AudioControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PlayBackButtons(),
      ],
    );
  }
}

class PlayBackButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: PlayBackButton());
  }
}

class PlayBackButton extends StatefulWidget {
  @override
  _PlayBackButtonState createState() => _PlayBackButtonState();
}

class _PlayBackButtonState extends State<PlayBackButton> {
  bool _isPlaying = false;

  // 'https://incompetech.com/music/royalty-free/mp3-royaltyfree/Surf%20Shimmy.mp3'; //works
  // 'https://uc3416c74bccad9e469be7bd32a7.dl.dropboxusercontent.com/cd/0/get/A0BupeL2Luee3pW4uH5Ap7HPb6lhT0GKdp7Rz33etVF4VHlAFYN8po7-zQO4UlxA6YY_EK_LJeSVmFp3rmKHRXxF4NnK6zUXmzlm3dvCEpYzJs19MVwKvOQg5lg4Pjyf6Oo/file?dl=1'; // works
  // 'https://www.dropbox.com/s/mxxpercplsbnn6s/Nelly-DAHM.mp3'; // not working
  // 'https://www.dropbox.com/s/mxxpercplsbnn6s/Nelly-DAHM.mp3?dl=0'; // not working
  FlutterSound _sound;
  double _playPosition;
  Stream<PlayStatus> _playerSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sound = FlutterSound();
    _playPosition = 0;
  }

  void _stop() async {
    await _sound.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  void _play() async {
    setState(() {});
    final String url = hmm;
    // print("object $url");
    String path = await _sound.startPlayer('$url');
    // String path = await flutterSound.startPlayer('assets/responseaudio.mp3');
    // print("startPlayer: $path");

    _playerSubscription = _sound.onPlayerStateChanged
      ..listen((e) {
        if (e != null) {
          // String txt = DateFormat("mm:ss:SS", 'en_US').format(date);

          // print(e.currentPosition);
          // e.duration;
          setState(() {
            _playPosition = e.currentPosition / e.duration;
          });
        }
      });
    setState(() {
      _isPlaying = true;
    });
  }

  void _fastForward() {}
  void _rewind() {}
  void _pause() async {
    await _sound.pausePlayer();
    setState(() {
      if (_isPlaying) {
        _isPlaying = false;
      } else
        _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Slider(
            value: _playPosition,
            onChanged: (value) {
              setState(() {
                _sound.seekToPlayer(value.toInt());
                _playPosition = value;
              });
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.fast_rewind),
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: () {
                setState(() {
                  _pause();
                });
              },
            ),
            IconButton(
              icon: (_isPlaying) ? Icon(Icons.stop) : Icon(Icons.play_arrow),
              onPressed: () {
                setState(() {
                  if (_isPlaying) {
                    _stop();
                  } else {
                    _play();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.fast_forward),
              onPressed: null,
            ),
          ],
        ),
      ],
    );
  }
}

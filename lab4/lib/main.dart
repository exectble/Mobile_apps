import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'lab5.dart';

void main()=>runApp(const MaterialApp(
  home: LoginScreen(),
));


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  late StreamSubscription<String> _onUrlChanged;String accessToken = "";
  String userId = "";
  String userFirstname = "";
  String userLastname = "";
  String userImageUrl = "https://avatars.yandex.net/get-music-user-playlist/51766/335367275.1063.25038/m1000x1000?1494579498903&webp=false";
  var numOfFriends = 0;
  late List<dynamic> friendsList;

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();


    setUserData() async {
      var url = 'https://api.vk.com/method/users.get?user_id=$userId&access_token=$accessToken&fields=photo_50&v=5.110';
      final response = await http.get(url);
      var jsonData = jsonDecode(response.body);
      jsonData = jsonData['response'][0];
      setState(() {
        userFirstname = jsonData['first_name'];
        userLastname = jsonData['last_name'];
        userImageUrl = jsonData['photo_50'];
      });
    }

    setAccessToken(String url){
      setState(() {
        print("URL changed: $url");
        if (url.contains('https://oauth.vk.com/blank.html#access_token=')) {
          var first = url.toString().split("access_token=");
          var _final = first[1].split("&");
          this.accessToken = _final[0].toString();
          //print(this.accessToken);
        }
      });
    }

    setUserId(String url) {
      setState(() {
        print("URL changed: $url");
        if (url.contains('user_id=')) {
          var first = url.toString().split("user_id=");
          var _final = first[1].split("&");
          this.userId = _final[0].toString();
          //print(this.userId);
          setUserData();
          flutterWebviewPlugin.dispose();
        }
      });
    }
    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setAccessToken(url);
        setUserId(url);
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onUrlChanged.cancel();flutterWebviewPlugin.dispose();
    super.dispose();
  }

  setFriendsList() async {
    var response = await http.get(
        'https://api.vk.com/method/friends.get?user_id=$userId&access_token=$accessToken&v=5.110&fields=photo_50,online_mobile,online');
    var friendsList = jsonDecode(response.body)['response'];
    setState(() {
      numOfFriends = friendsList['count'];
      this.friendsList = friendsList['items'];
    });
  }

  @override
  Widget build(BuildContext context) {
    String appId = '8176610';
    String redirectUrl = 'https://oauth.vk.com/blank.html';
    String loginUrl = "https://oauth.vk.com/authorize?client_id=$appId&display=page&redirect_uri=$redirectUrl&scope=friends&response_type=token&v=5.110&state=123456";

    return WebviewScaffold(
        url: loginUrl,
        appBar: new AppBar(
          title: new Text("$userFirstname $userLastname"),
          leading: Image.network(
              userImageUrl),
          backgroundColor: Colors.black,
        ),
        bottomNavigationBar: Container(
          child: Text(accessToken != "" ? "Access token: $accessToken" : "", style: TextStyle(color: Colors.white)),
          padding: EdgeInsets.all(12),
          color: Colors.black,
        ),
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: () {
              flutterWebviewPlugin.cleanCookies();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Выход ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Icon(Icons.logout, size: 30.0,),
              ],
            ),
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.lightBlue)),
          ),
          accessToken != "" ? ElevatedButton(
            onPressed: () async {
              await setFriendsList();
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => FriendsList(accessToken: accessToken, userId: userId, userImageUrl: userImageUrl,
                    numOfFriends: numOfFriends, friendsList: friendsList, userFirstname: userFirstname, userLastname: userLastname, key: null,)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Список друзей ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Icon(Icons.assignment_ind_outlined, size: 30.0,),
              ],
            ),
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.lightBlue)),
          )
              : Text(""),
        ]
    );
  }
}
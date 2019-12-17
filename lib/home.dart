import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/account.dart';
import 'package:flutter_app/settings.dart';
import 'package:flutter_app/slideright.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  Future<Quote> quote;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      counter++;
    });
  }

  void onButtonTapp() {}

  Future<Quote> getQuote() async {
    String url = 'https://quotes.rest/qod.json';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  void showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.display2,
            ),
            RaisedButton.icon(
              icon: const Icon(
                Icons.add_a_photo,
                size: 20,
              ),
              label: Text("Open Camera"),
              color: Theme.of(context).primaryColor,
              onPressed: onButtonTapp,
            ),
            RaisedButton(
              child: Text("Bottom Sheet"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(
          Icons.add_circle,
          size: 50,
        ),
      ),
      drawer: getNavDrawer(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Drawer getNavDrawer(BuildContext context) {
    var headerChild = DrawerHeader(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: 60.0,
          height: 60.0,
          decoration: new BoxDecoration(
            color: const Color(0xf08c94b6),
            image: new DecorationImage(
              image: new NetworkImage('http://i.imgur.com/QSev0hg.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            border: new Border.all(
              color: Theme.of(context).primaryColor,
              width: 4.0,
            ),
          ),
        ),
        Spacer(flex: 1),
        Text("First Name", style: Theme.of(context).textTheme.title)
      ],
    ));
    ListTile getNavItem(var icon, String s, Widget widget) {
      return ListTile(
        leading: Icon(icon),
        title: Text(s),
        onTap: () {
          setState(() {
            // pop closes the drawer
            Navigator.of(context).pop();
            // navigate to the route
//              Navigator.of(context).pushNamed("/");
            if (s != "Home")
              Navigator.of(context).push(SlideRightRoute(page: widget));
          });
        },
      );
    }

    var myNavChildren = [
      headerChild,
      getNavItem(Icons.settings, "Settings", new SettingsScreen()),
      getNavItem(Icons.home, "Home", new MyHomePage()),
      getNavItem(Icons.account_box, "Account", new AccountScreen()),
    ];

    ListView listView = ListView(children: myNavChildren);

    return Drawer(
      child: listView,
    );
  }

  @override
  void initState() {
    super.initState();
    quote = getQuote();
  }
}

class Quote {
  final String author;
  final String quote;

  Quote({this.author, this.quote});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        author: json['contents']['quotes'][0]['author'],
        quote: json['contents']['quotes'][0]['quote']);
  }
}

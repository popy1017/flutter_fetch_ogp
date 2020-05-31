import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OGP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MetaDataView(),
    );
  }
}

class MetaDataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("'Flutter OGP Demo'")),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                Text("Flutter - Beautiful native apps in record time"),
                Image.network(
                    "https://flutter.dev/images/flutter-logo-sharing.png"),
                Text(
                    "Flutter is Google's UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.  Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.")
              ],
            )),
            SizedBox(height: 100, child: Container(color: Colors.cyan)),
          ],
        ));
  }
}

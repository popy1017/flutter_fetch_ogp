import 'package:fetch_ogp/components/fetch_ogp_form.dart';
import 'package:fetch_ogp/components/metadata_detail.dart';
import 'package:fetch_ogp/models/metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      home: MetadataView(),
    );
  }
}

class MetadataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Flutter OGP Demo")),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ChangeNotifierProvider(
              create: (context) => MetadataModel(),
              child: Column(
                children: <Widget>[MetadataDetail(), FetchOgpForm()],
              ),
            ),
          ),
        ));
  }
}

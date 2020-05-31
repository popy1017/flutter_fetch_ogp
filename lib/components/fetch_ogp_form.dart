import 'package:flutter/material.dart';

class FetchOgpForm extends StatefulWidget {
  @override
  _FetchOgpFormState createState() => _FetchOgpFormState();
}

class _FetchOgpFormState extends State<FetchOgpForm> {
  String _url = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                setState(() {
                  _url = text;
                });
              },
            ),
            RaisedButton(
              onPressed: () {
                print("Current url is $_url");
                // fetchMetadata(_url);
              },
              child: Text("Fetch"),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        ));
  }
}

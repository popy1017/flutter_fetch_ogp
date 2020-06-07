import 'package:fetch_ogp/models/metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        child: TextField(
          decoration: InputDecoration(hintText: "https://www.example.com"),
          textInputAction: TextInputAction.send,
          onChanged: (text) {
            setState(() {
              _url = text;
            });
          },
          onSubmitted: (text) async {
            print("Current url is $_url");
            final success =
                await context.read<MetadataModel>().fetchOgpFrom(_url);

            if (!success) {
              final SnackBar _snackBar = SnackBar(
                content: Text("Error happened."),
                backgroundColor: Colors.red[300],
              );
              Scaffold.of(context).showSnackBar(_snackBar);
            }
          },
        ));
  }
}

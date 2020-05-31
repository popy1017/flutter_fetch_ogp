import 'package:flutter/material.dart';

class MetadataDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: <Widget>[
        Text("Flutter - Beautiful native apps in record time"),
        Image.network("https://flutter.dev/images/flutter-logo-sharing.png"),
        Text(
            "Flutter is Google's UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.  Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.")
      ],
    ));
  }
}

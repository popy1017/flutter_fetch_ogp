import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

// テスト用。あとで消す。
Map<String, dynamic> mockJson = {
  "title": "Flutter - Beautiful native apps in record time",
  "image": "https://flutter.dev/images/flutter-logo-sharing.png",
  "description":
      "Flutter is Google's UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.  Flutter works with existing code, is used by developers and organizations around the world, and is free and open source"
};

class MetadataModel extends ChangeNotifier {
  Metadata ogp = Metadata.fromJson(mockJson);
  // fetchOgpFrom(String url) {};
}

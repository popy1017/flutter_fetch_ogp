import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// テスト用。あとで消す。
Map<String, dynamic> mockJson = {
  "title": "Flutter - Beautiful native apps in record time",
  "image": "https://flutter.dev/images/flutter-logo-sharing.png",
  "description":
      "Flutter is Google's UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.  Flutter works with existing code, is used by developers and organizations around the world, and is free and open source"
};

class MetadataModel extends ChangeNotifier {
  Metadata ogp = Metadata.fromJson(mockJson);
  StreamSubscription _intentDataStreamSubscription;

  MetadataModel() {
    // アプリ起動中の処理
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      final json = jsonDecode(value);
      if (json["url"] != null) {
        fetchOgpFrom(json["url"]);
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null) {
        final json = jsonDecode(value);
        if (json["url"] != null) {
          fetchOgpFrom(json["url"]);
        }
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  Future<bool> fetchOgpFrom(String _url) async {
    try {
      final response = await http.get(_url);
      final document = responseToDocument(response);
      ogp = MetadataParser.OpenGraph(document);

      notifyListeners();
      return true;
    } catch (e) {
      print(e.message ?? e);
      return false;
    }
  }
}

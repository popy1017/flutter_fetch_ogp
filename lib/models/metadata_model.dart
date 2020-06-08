import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// 初期表示用
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
      if (value != null) {
        fetchOgpByPlatform(value);
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null) {
        fetchOgpByPlatform(value);
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  void fetchOgpByPlatform(String value) {
    if (Platform.isIOS) {
      // iOSの場合、JSON文字列で送られてくるので、JSONに変換する
      final json = jsonDecode(value);
      if (json["url"] != null) {
        fetchOgpFrom(json["url"]);
      }
    } else if (Platform.isAndroid) {
      // Androidの場合、普通の文字列で送られてくるのでそのまま使う
      fetchOgpFrom(value);
    }
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

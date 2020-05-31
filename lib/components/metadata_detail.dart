import 'package:fetch_ogp/models/metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:provider/provider.dart';

final noImagePath =
    "https://www.shoshinsha-design.com/wp-content/uploads/2016/10/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88-2016-10-05-0.41.12.png";

class MetadataDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Metadata _ogp = context.select((MetadataModel _model) => _model.ogp);

    return Expanded(
        child: Column(
      children: <Widget>[
        Text(
          _ogp.title ?? "No title",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Image.network(_ogp.image ?? noImagePath),
        Text(_ogp.description ?? "No description")
      ],
    ));
  }
}

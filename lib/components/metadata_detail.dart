import 'package:fetch_ogp/models/metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:provider/provider.dart';

class MetadataDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Metadata _ogp = context.select((MetadataModel _model) => _model.ogp);

    return Expanded(
        child: Column(
      children: <Widget>[
        Text(
          _ogp.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Image.network(_ogp.image),
        Text(_ogp.description)
      ],
    ));
  }
}

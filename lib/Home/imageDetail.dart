import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDetail extends StatefulWidget {
  String url;

  ImageDetail(this.url, {Key key}) : super(key: key);

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color(0xFF73AEF5),
        title: Text('Image'),
      ),
      body: CachedNetworkImage(
        imageUrl: widget?.url ?? "",
        placeholder: ((context, s) => Center(
              child: CircularProgressIndicator(),
            )),
        fit: BoxFit.cover,
      ),
    );
  }
}

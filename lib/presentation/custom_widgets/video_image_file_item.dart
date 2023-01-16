import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoIageFileItem extends StatefulWidget {
  final String videoName;
  final bool videoFromInternet;
  final double width;
  final double height;
  final bool withClipprect;
  const VideoIageFileItem({
    Key key,
    @required this.videoName,
    @required this.videoFromInternet,
    this.height = 100,
    this.width = 100,
    this.withClipprect = false,
  }) : super(key: key);

  @override
  _VideoIageFileItem createState() => _VideoIageFileItem();
}

class _VideoIageFileItem extends State<VideoIageFileItem> {
  Future<Image> generateThumbnail(String videoName) async {
    if (widget.videoFromInternet) {
      String baseUrl = Urls.BASE_URL;
      final uint8list = await VideoThumbnail.thumbnailFile(
        video: baseUrl + widget.videoName.substring(1),
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 100,
        maxWidth: 100,
        quality: 25,
      );
      Uri uri = Uri.parse(uint8list);
      File file = File.fromUri(uri);
      return Image.file(
        file,
        fit: BoxFit.cover,
        cacheHeight: 100,
        cacheWidth: 100,
      );
    } else {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoName,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 650,
        maxHeight: 800,
        quality: 25,
      );
      return Image.memory(
        uint8list,
        fit: BoxFit.cover,
      );
    }
  }

  Future<Image> image;
  @override
  void initState() {
    super.initState();
    image = generateThumbnail(widget.videoName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
      future: image,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius:
                BorderRadius.circular((widget.withClipprect) ? 12 : 0),
            child: Container(
              width: widget.width,
              height: widget.height,
              child: snapshot.data,
            ),
          );
        } else {
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey,
          );
        }
      },
    );
  }
}

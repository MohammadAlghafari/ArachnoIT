import 'dart:io';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:flutter/cupertino.dart';

class ImageType {
  String fileFromDataBase;
  bool isFromDataBase;
  File fileFromDevice;
  String imageID;
  ImageType(
      {this.fileFromDataBase = "",
      this.isFromDataBase = true,
      this.fileFromDevice,
      this.imageID});
}

// ignore: must_be_immutable
class ShowFileImage extends StatelessWidget {
  ImageType imageFile;
  ShowFileImage({this.imageFile});
  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return Container();
    } else if (imageFile.isFromDataBase) {
      if (imageFile.fileFromDataBase.length == 0) return Container();
      return initalStatus(context);
    } else {
      return fileFromDevice(context);
    }
  }

  Widget fileFromDevice(BuildContext context) {
    String _file = imageFile.fileFromDevice.path;
    return (GlobalPurposeFunctions.fileTypeIsImage(filePath: _file))
        ? Container(
            child: Image.file(
              imageFile.fileFromDevice,
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          )
        : Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.9,
            child: GlobalPurposeFunctions.handleFileTypeIcon(fileUrl: _file),
          );
  }

  Widget initalStatus(BuildContext context) {
    if (GlobalPurposeFunctions.fileTypeIsImage(
        filePath: imageFile.fileFromDataBase)) {
      return Container(
        child: ChachedNetwrokImageView(
          imageUrl: imageFile.fileFromDataBase,
          height: 200,
          width: MediaQuery.of(context).size.width,
        ),
      );
    } else {
      return Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          child: GlobalPurposeFunctions.handleFileTypeIcon(
              fileUrl: imageFile.fileFromDataBase));
    }
  }
}

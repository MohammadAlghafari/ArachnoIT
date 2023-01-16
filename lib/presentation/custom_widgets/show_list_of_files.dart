import 'dart:io';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/blog_post_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:arachnoit/presentation/custom_widgets/video_image_file_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cached_network_image_view.dart';

class ShowListOfFilesFileImage extends StatelessWidget {
  final Function removeItemFunction;
  final ImageType imageFile;
  ShowListOfFilesFileImage(
      {@required this.imageFile, @required this.removeItemFunction});
  @override
  Widget build(BuildContext context) {
    if (!imageFile.isFromDataBase) {
      return fileFromDevice(context);
    } else {
      if (imageFile.fileFromDataBase.length == 0)
        return Container();
      else
        return initalStatus(context);
    }
  }

  Widget fileFromDevice(BuildContext context) {
    String _item = imageFile.fileFromDevice.path;
    return GlobalPurposeFunctions.fileTypeIsImage(filePath: _item)
        ? Padding(
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Image.file(
                      imageFile.fileFromDevice,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                removeItemFromList(context),
              ],
            ),
          )
        : GlobalPurposeFunctions.fileTypeIsVideo(filePath: _item)
            ? Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VideoIageFileItem(
                          videoName: _item,
                          videoFromInternet: false,
                        )),
                    removeItemFromList(context),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: GlobalPurposeFunctions.handleFileTypeIcon(
                            fileUrl: _item),
                      ),
                    ),
                    removeItemFromList(context),
                  ],
                ),
              );
  }

  Widget initalStatus(BuildContext context) {
    String _item = imageFile.fileFromDataBase;
    return GlobalPurposeFunctions.fileTypeIsImage(filePath: _item)
        ? Padding(
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: ChachedNetwrokImageView(
                      imageUrl: _item,
                    ),
                  ),
                ),
                removeItemFromList(context),
              ],
            ),
          )
        : GlobalPurposeFunctions.fileTypeIsVideo(filePath: _item)
            ? Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VideoIageFileItem(
                          videoName: _item,
                          videoFromInternet: true,
                        )),
                    removeItemFromList(context),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: GlobalPurposeFunctions.handleFileTypeIcon(
                            fileUrl: _item),
                      ),
                    ),
                    removeItemFromList(context),
                  ],
                ),
              );
  }

  Widget removeItemFromList(BuildContext context) {
    return Positioned(
      top: -10,
      left: 85,
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.4),
        child: Center(
          child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).accentColor,
              ),
              onPressed: removeItemFunction),
        ),
      ),
    );
  }
}

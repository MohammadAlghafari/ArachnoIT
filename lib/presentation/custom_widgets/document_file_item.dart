import 'package:flutter/material.dart';

import '../../common/global_prupose_functions.dart';
import '../../infrastructure/common_response/file_response.dart';

class DocumentFileItem extends StatelessWidget {
  const DocumentFileItem(
      {Key key,
      @required this.file,
      @required this.index,
      @required this.filesLength})
      : super(key: key);
  final FileResponse file;
  final int index;
  final int filesLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlobalPurposeFunctions.handleFileTypeIcon(
            fileExtension: file.extension, fileUrl: file.url, context: context),
        SizedBox(
          width: 5,
        ),
        Text(
          file.name.length > 20
              ? file.name.substring(0, 20) + '...'
              : file.name,
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        index != filesLength - 1
            ? Text(
                ',',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Padding(padding: EdgeInsets.all(0)),
      ],
    );
  }
}

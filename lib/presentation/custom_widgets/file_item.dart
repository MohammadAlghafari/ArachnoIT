import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FileItem extends StatelessWidget {
  const FileItem({
    @required this.fileExtension,
    this.fileName,
    @required this.filePath,
    this.fileId,
  });
  final String fileExtension;
  final String fileName;
  final String filePath;
  final String fileId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 64.0,
          width: 48.0,
          child: (fileExtension == "jpg" ||
                  fileExtension == "jpeg" ||
                  fileExtension == "png")
              ? (filePath.startsWith("/Q") || filePath.startsWith("/B"))
                  ? Image.network(
                      Urls.BASE_URL + filePath,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(filePath),
                      fit: BoxFit.cover,
                    )
              : SvgPicture.asset(
                  "assets/images/ic_$fileExtension\_file.svg",
                  fit: BoxFit.contain,
                ),
        ),
        Container(
          width: 70.0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              fileName,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
           AppLocalizations.of(context).remove,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }
}

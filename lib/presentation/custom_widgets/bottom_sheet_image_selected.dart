import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomSheetImageSelected {

  static Future getDialog(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text(AppLocalizations.of(context).gallery),
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);
                  Navigator.of(context).pop({"file": pickedFile});
                },
              ),
              ListTile(
                leading: new Icon(Icons.camera),
                title: new Text(AppLocalizations.of(context).camera),
                onTap: () async {
                  final picker = ImagePicker();
                  
                  final pickedFile =
                      await picker.getImage(source: ImageSource.camera);
                  
                  Navigator.of(context).pop({"file": pickedFile});
                  return pickedFile;
                },
              ),
              ListTile(
                leading: new Icon(Icons.delete),
                title: new Text(AppLocalizations.of(context).delete_image),
                onTap: () async {
                  Navigator.of(context).pop({"delete": true});
                },
              ),
            ],
          );
        });
  }
}

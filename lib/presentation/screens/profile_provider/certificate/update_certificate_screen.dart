import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
import 'package:arachnoit/application/profile_provider_cerificate/profile_provider_certificate_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:arachnoit/presentation/custom_widgets/start_and_end_time.dart';
import 'package:arachnoit/presentation/custom_widgets/text_field_date_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../application/profile_provider_cerificate/profile_provider_certificate_bloc.dart';
import '../../../../infrastructure/profile_provider_certificate/repository/certificate_response.dart';

class UpdateCertificateScreen extends StatefulWidget {
  final String id;
  final CertificateResponse certificateItem;
  final ProfileProviderCertificateBloc blocFromLastScreen;
  final int index;
  const UpdateCertificateScreen({
    @required this.blocFromLastScreen,
    @required this.id,
    @required this.index,
    @required this.certificateItem,
  });

  @override
  _UpdateCertificateScreen createState() => new _UpdateCertificateScreen();
}

class _UpdateCertificateScreen extends State<UpdateCertificateScreen> {
  bool checkBoxNoEnd = false;
  ImageType imageType = ImageType();
  File file;
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  ProfileProviderCertificateBloc profileProviderCertificateBloc;
  ValueNotifier<bool> isExpire = ValueNotifier(true);
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  List<String> removedFiles = [];
  @override
  void initState() {
    super.initState();
    bool isExpired = false;
    profileProviderCertificateBloc = serviceLocator<ProfileProviderCertificateBloc>();
    startTime.text = DateFormat('yyyy-MM-dd').format(widget.certificateItem.issueDate);
    endTime.text = widget.certificateItem.expirationDate.toString();
    _titleController.text = widget.certificateItem.name;
    _descriptionController.text = widget.certificateItem.organization;
    _urlController.text = widget.certificateItem.url;
    if (widget.certificateItem.attachments.length != 0) {
      imageType.fileFromDataBase = widget.certificateItem.attachments[0].url;
      imageType.isFromDataBase = true;
      imageType.imageID = widget.certificateItem.attachments[0].id;
    }
    if (endTime.text == "null") {
      endTime.text = "";
      isExpired = true;
    } else {
      endTime.text = DateFormat('yyyy-MM-dd').format(widget.certificateItem.expirationDate);
    }
    startAndEndTimeWithExpire = StartAndEndTimeWithExpire(
      endTime: endTime,
      startTime: startTime,
      isExpired: isExpired,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).update_certificate),
      body: BlocProvider<ProfileProviderCertificateBloc>(
        create: (context) => profileProviderCertificateBloc,
        child: BlocListener<ProfileProviderCertificateBloc, ProfileProviderCertificateState>(
          listener: (contex, state) {
            if (state is SucceessUpdateCertificate) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                widget.blocFromLastScreen.add(UpdateSelectedLicenseAfterSuccessRequest(
                    certificate: state.newResponse, index: widget.index));
                Navigator.of(context).pop();
              });
            } else if (state is NewEndDateTimeState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              checkBoxNoEnd = state.state;
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderCertificateBloc, ProfileProviderCertificateState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 20, right: 17, left: 17, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      topImage(),
                      SizedBox(height: 10),
                      filedTitle(),
                      SizedBox(height: 8),
                      showDescription(),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).url),
                      SizedBox(height: 20),
                      urlPath(),
                      SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context).files + " * ",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles(allowedExtensions: [
                            "png",
                            "jpg",
                            "jpeg",
                            'doc',
                            'docx',
                            'ppt',
                            'xls',
                            'xlsx',
                            'bmp',
                            'gif',
                            'tiff',
                            'odf',
                            'pdf',
                            'equb',
                            'pub',
                            'sldx',
                            'ppsx',
                            'pps',
                          ], allowCompression: true, type: FileType.custom);
                          if (result != null) {
                            file = File(result.files.single.path);
                            file = await GlobalPurposeFunctions.cropImage(file);
                            if (imageType.isFromDataBase) removedFiles.add(imageType.imageID);
                            imageType.fileFromDevice = file;
                            imageType.isFromDataBase = false;
                            profileProviderCertificateBloc.add(ChangeTheFileImagePath(file: file));
                          } else {}
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(color: Color(0XFFC4C4C4))),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Color(0XFFC4C4C4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ShowFileImage(
                        imageFile: imageType,
                      ),
                      SizedBox(height: 10),
                      saveAndCancel(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget saveAndCancel() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
            color: Colors.transparent,
            child: Center(
              child: Text(
                AppLocalizations.of(context).cancel,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        SizedBox(
          width: 10,
        ),
        RaisedButton(
            color: Color(0XFFF65636),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Text(
                AppLocalizations.of(context).update_certificate,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            onPressed: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderCertificateBloc.add(UpdateSelectedCertificate(
                  file: imageType.isFromDataBase ? null : imageType.fileFromDevice,
                  expirationDate: endTime.text,
                  issueDate: startTime.text,
                  name: _titleController.text,
                  organization: _descriptionController.text,
                  url: _urlController.text,
                  context: context,
                  id: widget.id,
                  withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
                  removedfiles: removedFiles));
            }),
      ],
    );
  }

  Widget showDescription() {
    return Container(
      margin: EdgeInsets.all(0.0),
      color: Color(0XFFEFEFEF),
      child: TextField(
        maxLines: 1,
        controller: _descriptionController,
        decoration: new InputDecoration(
          labelText: AppLocalizations.of(context).company + " * ",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0), gapPadding: 15),
          //  labelText:'description title...',
        ),
      ),
    );
  }

  Widget filedTitle() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        controller: _titleController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0), gapPadding: 15),
          labelText: AppLocalizations.of(context).filed_title + " * ",
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget urlPath() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        controller: _urlController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0), gapPadding: 15),
          labelText: AppLocalizations.of(context).path,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget topImage() {
    return Hero(
      tag: ProfileProviderAddItemIcons.certificates,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Color(0XFFC4C4C4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                ProfileProviderAddItemIcons.getIconByKeyValue(
                    key: ProfileProviderAddItemIcons.certificates),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

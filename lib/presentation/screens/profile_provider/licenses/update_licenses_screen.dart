import 'dart:io';
import 'package:arachnoit/application/profile_provider_licenses/profile_provider_licenses_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/licenses_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateLicesnseScreen extends StatefulWidget {
  final String id;
  final LicensesResponse licensesItem;
  final ProfileProviderLicensesBloc blocFromLastScreen;
  final int index;
  UpdateLicesnseScreen({
    @required this.id,
    @required this.licensesItem,
    @required this.blocFromLastScreen,
    @required this.index,
  });
  @override
  _UpdateLicesnseScreen createState() => new _UpdateLicesnseScreen();
}

class _UpdateLicesnseScreen extends State<UpdateLicesnseScreen> {
  bool checkBoxNoEnd = false;
  File file;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ProfileProviderLicensesBloc profileProviderLicensesBloc;
  ImageType imageType = ImageType();
  @override
  void initState() {
    super.initState();
    profileProviderLicensesBloc = serviceLocator<ProfileProviderLicensesBloc>();
    _titleController.text = widget.licensesItem.title;
    _descriptionController.text = widget.licensesItem.description;
    imageType.fileFromDataBase = widget.licensesItem.fileUrl;
    imageType.isFromDataBase = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarProject.showAppBar(
            title: AppLocalizations.of(context).add_new_license),
        body: BlocProvider<ProfileProviderLicensesBloc>.value(
            value: profileProviderLicensesBloc,
            child: BlocListener<ProfileProviderLicensesBloc,
                ProfileProviderLicensesState>(
              listener: (context, state) {
                if (state is SuccessUpdateProfile) {
                  widget.blocFromLastScreen.add(
                      UpdateSelectedLicenseAfterSuccessRequest(
                          index: widget.index, license: state.license));
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                          context, false)
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                } else if (state is ErrorState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false);
                } else {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false);
                }
              },
              child: BlocBuilder<ProfileProviderLicensesBloc,
                  ProfileProviderLicensesState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 20, right: 17, left: 17, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          showTopImage(),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Color(0XFFEFEFEF),
                            child: TextField(
                              controller: _titleController,
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                    gapPadding: 15),
                                labelText: AppLocalizations.of(context).filed_title+" * ",
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(AppLocalizations.of(context).description_title+" * "),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            margin: EdgeInsets.all(0.0),
                            color: Color(0XFFEFEFEF),
                            child: TextField(
                              maxLines: 5,
                              controller: _descriptionController,
                              decoration: new InputDecoration(
                                hintText:
                                    AppLocalizations.of(context).description,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                    gapPadding: 15),
                                //  labelText:'description title...',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context).file+" * ",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                allowedExtensions: [
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
                                  'pps'
                                ],
                                allowCompression: true,
                                type: FileType.custom,
                              );
                              if (result != null) {
                                file =await GlobalPurposeFunctions.cropImage(File(result.files.single.path));
                                imageType.isFromDataBase = false;
                                imageType.fileFromDevice = file;
                                profileProviderLicensesBloc
                                    .add(ChangeTheFileImagePath());
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
                          SizedBox(height: 10),
                          ShowFileImage(
                            imageFile: imageType,
                          ),
                          SizedBox(height: 10),
                          cancelOrSave(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )));
  }

  Widget cancelOrSave() {
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Text(
              AppLocalizations.of(context).save,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            onPressed: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderLicensesBloc.add(UpdateLicense(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  file: imageType.isFromDataBase
                      ? null
                      : imageType.fileFromDevice,
                  id: widget.id,
                  context: context));
            }),
      ],
    );
  }

  Widget showTopImage() {
    return Hero(
      tag: ProfileProviderAddItemIcons.licenses,
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
                    key: ProfileProviderAddItemIcons.licenses),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

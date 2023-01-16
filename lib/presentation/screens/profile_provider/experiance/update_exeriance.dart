import 'dart:io';

import 'package:arachnoit/application/profile_provider_experiance/profile_provider_experiance_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/show_list_of_files.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:arachnoit/presentation/custom_widgets/start_and_end_time.dart';
import 'package:arachnoit/presentation/custom_widgets/text_field_date_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../application/profile_provider_experiance/profile_provider_experiance_bloc.dart';
import '../../../../infrastructure/common_response/attachment_response.dart';
import '../../../../infrastructure/profile_provider_experiance/response/experiance_response.dart';

//
class UpdateExperianceScreen extends StatefulWidget {
  final ExperianceResponse experianceResponse;
  final ProfileProviderExperianceBloc bloc;
  final String id;
  final int index;
  const UpdateExperianceScreen({
    this.experianceResponse,
    this.bloc,
    this.id,
    this.index,
  });

  @override
  _UpdateExperianceScreen createState() => new _UpdateExperianceScreen();
}

class _UpdateExperianceScreen extends State<UpdateExperianceScreen> {
  List<ImageType> file = [];
  bool isExpired = false;
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _compayController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  ProfileProviderExperianceBloc profileProviderExperianceBloc;
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  bool noEndDate = false;
  ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  List<String> removedfiles = [];
  @override
  void initState() {
    super.initState();
    profileProviderExperianceBloc = serviceLocator<ProfileProviderExperianceBloc>();
    startTime.text = DateFormat('yyyy-MM-dd').format(widget.experianceResponse.startDate);
    endTime.text = widget.experianceResponse.endDate.toString();
    _titleController.text = widget.experianceResponse.title;
    _compayController.text = widget.experianceResponse.company;
    _urlController.text = widget.experianceResponse.link;
    _detailController.text = widget.experianceResponse.description;
    for (AttachmentResponse item in widget.experianceResponse.attachments) {
      file.add(ImageType(isFromDataBase: true, fileFromDataBase: item.url, imageID: item.id));
    }
    if (endTime.text == "null") {
      endTime.text = "";
      isExpired = true;
    } else {
      endTime.text = DateFormat('yyyy-MM-dd').format(widget.experianceResponse.endDate);
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
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).update_experience),
      body: BlocProvider<ProfileProviderExperianceBloc>(
        create: (context) => profileProviderExperianceBloc,
        child: BlocListener<ProfileProviderExperianceBloc, ProfileProviderExperianceState>(
          listener: (contex, state) {
            if (state is AddItemToFileListState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              file.addAll(state.file);
            } else if (state is SuccessUpdateExperiance) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                widget.bloc.add(UpdateInfoAfterSuccess(
                    index: widget.index, response: state.newExperianceResponse));
                Navigator.of(context).pop();
              });
            } else if (state is RemoveItemFromFileListState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              removedfiles.add(file[state.index].imageID);
              file.removeAt(state.index);
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderExperianceBloc, ProfileProviderExperianceState>(
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
                      showCompany(),
                      SizedBox(height: 15),
                      startAndEndTimeWithExpire,
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).link),
                      SizedBox(height: 10),
                      urlPath(),
                      SizedBox(height: 10),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).details),
                      SizedBox(height: 10),
                      showDetailView(),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context).files,
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult result = await FilePicker.platform.pickFiles(
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
                                'pps',
                              ],
                              type: FileType.custom,
                              allowMultiple: true,
                              allowCompression: true,
                              withData: true);
                          if (result != null) {
                            List<ImageType> files =
                                await GlobalPurposeFunctions.cropListImage(result);

                            profileProviderExperianceBloc.add(AddItemToFileList(file: files));
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
                      SizedBox(height: 10),
                      Container(
                        height: (file.length == 0) ? 0 : 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ShowListOfFilesFileImage(
                              imageFile: file[index],
                              removeItemFunction: () {
                                profileProviderExperianceBloc
                                    .add(RemoveItemFromFileList(index: index));
                              },
                            );
                          },
                          itemCount: file.length,
                        ),
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
                AppLocalizations.of(context).update_experience,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            onPressed: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderExperianceBloc.add(
                UpdateExperianceEvent(
                  file: file,
                  name: _titleController.text,
                  organization: _compayController.text,
                  url: _urlController.text,
                  context: context,
                  withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
                  description: _detailController.text,
                  endDate: endTime.text,
                  startDate: startTime.text,
                  id: widget.id,
                  removedFiles: removedfiles,
                ),
              );
            }),
      ],
    );
  }

  Widget showCompany() {
    return Container(
      margin: EdgeInsets.all(0.0),
      color: Color(0XFFEFEFEF),
      child: TextField(
        maxLines: 1,
        controller: _compayController,
        decoration: new InputDecoration(
          hintText: AppLocalizations.of(context).company + " * ",
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
          labelText: AppLocalizations.of(context).jop_title + " * ",
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget showDetailView() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        controller: _detailController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0), gapPadding: 15),
          labelText: AppLocalizations.of(context).details,
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
          labelText: AppLocalizations.of(context).link,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget topImage() {
    return Hero(
      tag: ProfileProviderAddItemIcons.experiance,
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
                    key: ProfileProviderAddItemIcons.experiance),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

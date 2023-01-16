import 'dart:io';

import 'package:arachnoit/application/profile_provider_education/profile_provider_education_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/show_list_of_files.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:arachnoit/presentation/custom_widgets/start_and_end_time.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../application/profile_provider_education/profile_provider_education_bloc.dart';
import '../../../../infrastructure/common_response/attachment_response.dart';
import '../../../../infrastructure/profile_provider_educations/response/educations_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateEducationScreen extends StatefulWidget {
  final EducationsResponse response;
  final int index;
  final ProfileProviderEducationBloc bloc;
  final String id;
  const UpdateEducationScreen({
    this.id,
    this.index,
    this.bloc,
    this.response,
  });

  @override
  _UpdateEducationScreen createState() => new _UpdateEducationScreen();
}

class _UpdateEducationScreen extends State<UpdateEducationScreen> {
  bool checkBoxNoEnd = false;
  bool _showFileType = false;
  List<ImageType> file = [];
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController _fieldOfStydyController = TextEditingController();
  TextEditingController _schooldController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _degreeController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  ProfileProviderEducationBloc profileProviderEducationBloc;
  bool noEndDate = false;
  ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  List<String> removedFiles = [];
  @override
  void initState() {
    super.initState();
    bool isExpired = false;
    profileProviderEducationBloc = serviceLocator<ProfileProviderEducationBloc>();
    startTime.text = DateFormat('yyyy-MM-dd').format(widget.response.startDate);
    endTime.text = widget.response.endDate.toString();
    _fieldOfStydyController.text = widget.response.fieldOfStudy;
    _schooldController.text = widget.response.school;
    _urlController.text = widget.response.link;
    _detailController.text = widget.response.description;
    _degreeController.text = widget.response.degree;
    _gradeController.text = widget.response.grade;
    if (endTime.text == "null") {
      endTime.text = "";
      isExpired = true;
    } else {
      endTime.text = DateFormat('yyyy-MM-dd').format(widget.response.endDate);
    }
    for (AttachmentResponse item in widget.response.attachments) {
      file.add(ImageType(isFromDataBase: true, fileFromDataBase: item.url, imageID: item.id));
    }
    startAndEndTimeWithExpire = StartAndEndTimeWithExpire(
      startTime: startTime,
      endTime: endTime,
      isExpired: isExpired,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).add_new_educations),
      body: BlocProvider<ProfileProviderEducationBloc>(
        create: (context) => profileProviderEducationBloc,
        child: BlocListener<ProfileProviderEducationBloc, ProfileProviderEducationState>(
          listener: (contex, state) {
            if (state is AddItemToFileListState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              file.addAll(state.file);
            } else if (state is SuccessUpdateValue) {
              widget.bloc.add(UpdateEducationList(
                index: widget.index,
                educationResponse: state.newEducationResponse,
              ));
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                Navigator.of(context).pop();
              });
            } else if (state is RemoveItemFromFileListState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              file.removeAt(state.index);
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderEducationBloc, ProfileProviderEducationState>(
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
                      showFiledOfStudy(),
                      SizedBox(height: 8),
                      showSchool(),
                      SizedBox(height: 15),
                      startAndEndTimeWithExpire,
                      Text(AppLocalizations.of(context).degree),
                      SizedBox(height: 10),
                      showDegree(),
                      Text(AppLocalizations.of(context).grade),
                      SizedBox(height: 10),
                      showGrade(),
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

                            profileProviderEducationBloc.add(AddItemToFileList(file: files));
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
                                if (file[index].isFromDataBase) {
                                  removedFiles.add(file[index].imageID);
                                }
                                profileProviderEducationBloc
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
                AppLocalizations.of(context).save,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            onPressed: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderEducationBloc.add(
                UpdateEducation(
                    context: context,
                    withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
                    description: _detailController.text,
                    endDate: endTime.text,
                    startDate: startTime.text,
                    fieldOfStudy: _fieldOfStydyController.text,
                    file: file,
                    grade: _gradeController.text,
                    link: _urlController.text,
                    school: _schooldController.text,
                    id: widget.id,
                    removedFiles: removedFiles),
              );
            }),
      ],
    );
  }

  Widget showGrade() {
    return Container(
      margin: EdgeInsets.all(0.0),
      color: Color(0XFFEFEFEF),
      child: TextField(
        maxLines: 1,
        controller: _gradeController,
        decoration: new InputDecoration(
          hintText: AppLocalizations.of(context).grade,
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

  Widget showDegree() {
    return Container(
      margin: EdgeInsets.all(0.0),
      color: Color(0XFFEFEFEF),
      child: TextField(
        maxLines: 1,
        controller: _degreeController,
        decoration: new InputDecoration(
          hintText: AppLocalizations.of(context).degree,
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

  Widget showSchool() {
    return Container(
      margin: EdgeInsets.all(0.0),
      color: Color(0XFFEFEFEF),
      child: TextField(
        maxLines: 1,
        controller: _schooldController,
        decoration: new InputDecoration(
          labelText: AppLocalizations.of(context).school + " * ",
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

  Widget showFiledOfStudy() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        controller: _fieldOfStydyController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0), gapPadding: 15),
          labelText: AppLocalizations.of(context).field_of_study + " * ",
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget showDetailView() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        maxLines: 3,
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
      tag: ProfileProviderAddItemIcons.educations,
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
                    key: ProfileProviderAddItemIcons.educations),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

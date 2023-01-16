import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

import 'package:arachnoit/application/profile_provider_lectures/profile_provider_lectures_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/infrastructure/common_response/attachment_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/call/update_lectures.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/new_lectures_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/qualifications_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/show_list_of_files.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:arachnoit/presentation/custom_widgets/start_and_end_time.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateLecturesScreen extends StatefulWidget {
  final QualificationsResponse item;
  final ProfileProviderLecturesBloc bloc;
  final int index;
  UpdateLecturesScreen({this.item, this.bloc, this.index});
  @override
  _UpdateLecturesScreen createState() => new _UpdateLecturesScreen();
}

class _UpdateLecturesScreen extends State<UpdateLecturesScreen> {
  bool checkBoxNoEnd = false;
  bool _showFileType = false;
  List<ImageType> file = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ProfileProviderLecturesBloc profileProviderLecturesBloc;
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  bool noEndDate = false;
  ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  List<String> removedFile = [];
  @override
  void initState() {
    super.initState();
    profileProviderLecturesBloc = serviceLocator<ProfileProviderLecturesBloc>();
    _titleController.text = widget.item.title;
    _descriptionController.text = widget.item.description;
    for (AttachmentResponse item in widget.item.attachments) {
      file.add(ImageType(
          isFromDataBase: true,
          fileFromDataBase: item.url,
          imageID: item.id,
          fileFromDevice: File("")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).update_lecture),
      body: BlocProvider<ProfileProviderLecturesBloc>(
        create: (context) => profileProviderLecturesBloc,
        child: BlocListener<ProfileProviderLecturesBloc, ProfileProviderLecturesState>(
          listener: (contex, state) {
            if (state is AddItemToFileListState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              file.addAll(state.file);
            } else if (state is SuccessUpdateLectures) {
              widget.bloc.add(UpdateValue(index: state.index, item: state.newItem));
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                Navigator.pop(context);
              });
            } else if (state is RemoveItemFromFileListState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              removedFile.add(file[state.index].imageID);
              file.removeAt(state.index);
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderLecturesBloc, ProfileProviderLecturesState>(
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
                      SizedBox(height: 15),
                      Text(
                        AppLocalizations.of(context).files + " * ",
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
                                'mp4',
                              ],
                              type: FileType.custom,
                              allowMultiple: true,
                              allowCompression: true,
                              withData: true);
                          if (result != null) {
                            List<ImageType> files =
                                await GlobalPurposeFunctions.cropListImage(result);

                            profileProviderLecturesBloc.add(AddItemToFileList(file: files));
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
                                profileProviderLecturesBloc
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
              AppLocalizations.of(context).update_lecture,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onPressed: () {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            profileProviderLecturesBloc.add(UpdateLecturesState(
                file: file,
                context: context,
                description: _descriptionController.text,
                title: _titleController.text,
                itemId: widget.item.id,
                index: widget.index,
                removedFile: removedFile));
          },
        ),
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
          labelText: AppLocalizations.of(context).lecture_title + " * ",
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget topImage() {
    return Hero(
      tag: ProfileProviderAddItemIcons.lecturesKey,
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
                    key: ProfileProviderAddItemIcons.lecturesKey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

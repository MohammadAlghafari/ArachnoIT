import 'dart:io';

import 'package:arachnoit/application/profile_provider_projects/profile_provider_projects_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/show_list_of_files.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:arachnoit/presentation/custom_widgets/start_and_end_time.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProjectScreen extends StatefulWidget {

  @override
  _AddProjectScreen createState() => new _AddProjectScreen();
}

class _AddProjectScreen extends State<AddProjectScreen> {
  bool checkBoxNoEnd = false;
  List<ImageType> file = [];
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  ProfileProviderProjectsBloc profileProviderProjectsBloc;
  bool noEndDate = false;
  ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  @override
  void initState() {
    super.initState();
    profileProviderProjectsBloc = serviceLocator<ProfileProviderProjectsBloc>();
    startAndEndTimeWithExpire = StartAndEndTimeWithExpire(
      startTime: startTime,
      endTime: endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).projects),
      body: BlocProvider<ProfileProviderProjectsBloc>(
        create: (context) => profileProviderProjectsBloc,
        child: BlocListener<ProfileProviderProjectsBloc,
            ProfileProviderProjectsState>(
          listener: (contex, state) {
            if (state is AddItemToFileListState) {
              file.addAll(state.file);
            } else if (state is RemoveItemFromFileListState) {
              file.removeAt(state.index);
            } else if (state is SuccessAddNewProject) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) => {Navigator.pop(context)});
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ProfileProviderProjectsBloc,
              ProfileProviderProjectsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  margin:
                      EdgeInsets.only(top: 20, right: 17, left: 17, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      topImage(),
                      SizedBox(height: 10),
                      showFiledOfStudy(),
                      SizedBox(height: 15),
                      startAndEndTimeWithExpire,
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).link),
                      SizedBox(height: 10),
                      urlPath(),
                      SizedBox(height: 10),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).details+" * "),
                      SizedBox(height: 10),
                      showDetailView(),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context).files,
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult result = await FilePicker.platform
                              .pickFiles(
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
                         List<ImageType> files = await GlobalPurposeFunctions.cropListImage(result);
                            profileProviderProjectsBloc
                                .add(AddItemToFileList(file: files));
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
                                profileProviderProjectsBloc
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
              profileProviderProjectsBloc.add(
                SetNewProject(
                  context: context,
                  withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
                  description: _detailController.text,
                  endDate: endTime.text,
                  startDate: startTime.text,
                  file: file,
                  link: _urlController.text,
                  name: _nameController.text,
                ),
              );
            }),
      ],
    );
  }

  Widget showFiledOfStudy() {
    return Container(
      color: Color(0XFFEFEFEF),
      child: TextField(
        controller: _nameController,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              gapPadding: 15),
          labelText: AppLocalizations.of(context).project_name+" * ",
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
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              gapPadding: 15),
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
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              gapPadding: 15),
          labelText: AppLocalizations.of(context).link+" * ",
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget topImage() {
   return Hero(
      tag: ProfileProviderAddItemIcons.projects,
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
                  key: ProfileProviderAddItemIcons.projects
                ),
              ),
            ),
          ),
        ),
      ),
    );
  
  }
}

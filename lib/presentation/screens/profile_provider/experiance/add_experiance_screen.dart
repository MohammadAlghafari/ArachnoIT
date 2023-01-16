import 'dart:io';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/application/profile_provider_experiance/profile_provider_experiance_bloc.dart';
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

class AddExperianceScreen extends StatefulWidget {
  @override
  _AddExperianceScreen createState() => new _AddExperianceScreen();
}

class _AddExperianceScreen extends State<AddExperianceScreen> {
  List<ImageType> file = [];
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
  @override
  void initState() {
    super.initState();
    profileProviderExperianceBloc = serviceLocator<ProfileProviderExperianceBloc>();
    startAndEndTimeWithExpire = StartAndEndTimeWithExpire(
      endTime: endTime,
      startTime: startTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).experience),
      body: BlocProvider<ProfileProviderExperianceBloc>(
        create: (context) => profileProviderExperianceBloc,
        child: BlocListener<ProfileProviderExperianceBloc, ProfileProviderExperianceState>(
          listener: (contex, state) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            if (state is AddItemToFileListState) {
              file.addAll(state.file);
            } else if (state is SuccessAddNewExperiance) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else if (state is RemoveItemFromFileListState) {
              file.removeAt(state.index);
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
              AppLocalizations.of(context).save,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onPressed: () {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            profileProviderExperianceBloc.add(
              AddNewExperiance(
                  file: file,
                  name: _titleController.text,
                  organization: _compayController.text,
                  url: _urlController.text,
                  context: context,
                  withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
                  description: _detailController.text,
                  endDate: endTime.text,
                  startDate: startTime.text),
            );
          },
        ),
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

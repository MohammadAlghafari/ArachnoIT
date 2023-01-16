import 'dart:io';
import 'package:arachnoit/application/profile_provider_skills/profile_provider_skills_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/common/profile_provider_add_item_icons.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/skills_response.dart';
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
import 'package:intl/intl.dart';

class UpdateSkillScreen extends StatefulWidget {
  final int index;
  final ProfileProviderSkillsBloc bloc;
  final SkillsResponse skillsItem;
  UpdateSkillScreen({this.index, this.bloc, this.skillsItem});
  @override
  _UpdateSkillScreen createState() => new _UpdateSkillScreen();
}

class _UpdateSkillScreen extends State<UpdateSkillScreen> {
  bool isExpired = false;
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  StartAndEndTimeWithExpire startAndEndTimeWithExpire;
  ProfileProviderSkillsBloc profileProviderSkillsBloc;
  bool noEndDate = false;
  ValueNotifier<DateTime> time = ValueNotifier(DateTime.now());
  @override
  void initState() {
    super.initState();
    profileProviderSkillsBloc = serviceLocator<ProfileProviderSkillsBloc>();
    endTime.text = widget?.skillsItem?.endDate.toString() ?? "";
    startTime.text =
        DateFormat('yyyy-MM-dd').format(widget?.skillsItem?.startDate);
    if (endTime.text == "null") {
      isExpired = true;
      endTime.text = "";
    } else {
      endTime.text =
          DateFormat('yyyy-MM-dd').format(widget?.skillsItem?.endDate);
    }
    _nameController.text = widget?.skillsItem?.name ?? "";
    _detailController.text = widget?.skillsItem?.description ?? "";
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
      appBar: AppBarProject.showAppBar(title: AppLocalizations.of(context).update_skills),
      body: BlocProvider<ProfileProviderSkillsBloc>(
        create: (context) => profileProviderSkillsBloc,
        child:
            BlocListener<ProfileProviderSkillsBloc, ProfileProviderSkillsState>(
          listener: (contex, state) {
            if (state is SuccessUpdateSkill) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                widget.bloc.add(UpdateValueAfterSuccess(
                  index: widget.index,
                  skillResponse: state.newSkill,
                ));
                Navigator.pop(context);
              });
            } else if (state is ErrorState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                GlobalPurposeFunctions.showToast(state.errorMessage, context);
              });
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
            //  if (state is SuccessAddNewProject) {
            //   GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
            //       .then((value) => {Navigator.pop(context)});
            // } else {
            //   GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            // }
          },
          child: BlocBuilder<ProfileProviderSkillsBloc,
              ProfileProviderSkillsState>(
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
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).details+" * "),
                      SizedBox(height: 10),
                      showDetailView(),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
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
              profileProviderSkillsBloc.add(AddNewSkill(
                context: context,
                description: _detailController.text,
                endDate: endTime.text,
                startDate: startTime.text,
                name: _nameController.text,
                withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
              ));
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              profileProviderSkillsBloc.add(
                UpdateSkill(
                  context: context,
                  withExpireTime: startAndEndTimeWithExpire.getExpireValue(),
                  description: _detailController.text,
                  endDate: endTime.text,
                  startDate: startTime.text,
                  name: _nameController.text,
                  itemId: widget.skillsItem.id,
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
          labelText: AppLocalizations.of(context).field_of_study,
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
          labelText: AppLocalizations.of(context).details+" * ",
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget topImage() {
    return Hero(
      tag: ProfileProviderAddItemIcons.skills,
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
                  key: ProfileProviderAddItemIcons.skills
                ),
              ),
            ),
          ),
        ),
      ),
    );
  
  }
}
